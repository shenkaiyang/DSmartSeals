//
//  DBluetoothManager.m
//  DSmartSeals
//
//  Created by shenkaiyang on 2018/6/14.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import "DBluetoothManager.h"
#import "SVProgressHUD.h"


//#define SERVICE_UUID        @"CDD1"
//
//#define CHARACTERISTIC_UUID @"CDD2"

@interface DBluetoothManager ()  <CBPeripheralManagerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>


@property (nonatomic, strong)  CBPeripheralManager *peripheralManager;
@property (nonatomic, assign)  BOOL loseConnent;
@property (nonatomic, assign)  BOOL isConnent;

@property (nonatomic, readwrite, strong) NSMutableArray <ISBLEPeripheralInfo*> *findedPeripheralsArray;

@end
@implementation DBluetoothManager




+(instancetype)shareInstance
{
    static DBluetoothManager *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[DBluetoothManager alloc]init];
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

    }
    return self;
}

- (void)resetScanPeripherals{
    [self.findedPeripheralsArray removeAllObjects];
}


- (void)startScanPeripherals:(nullable NSArray <CBUUID *> *)services
{
    self.servicesIDArray = services;
    self.loseConnent = NO;
    [self.centralMgr scanForPeripheralsWithServices:nil options:nil];

}
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (central.state != CBManagerStatePoweredOn) {
        NSString * authErrorStr;
        if (central.state == CBManagerStatePoweredOff) {
            
            authErrorStr =  @"您未打开蓝牙！请开启蓝牙";
        }else if (central.state == CBManagerStateUnauthorized){
            authErrorStr = @"设备未授权，请重试";
        }else if (central.state == CBManagerStateUnsupported){
            authErrorStr =@"链接失败，请重试";
        }else if (central.state == CBManagerStateResetting){
            authErrorStr = @"蓝牙被重置，请重试";
        }else if (central.state == CBManagerStateUnknown){
            authErrorStr = @"未知错误，请重试";
        }
        [SVProgressHUD showErrorWithStatus:authErrorStr]  ;
        return;
    }
    [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
}


/**
开始链接

 @param peripheralInfo 设备
 */
- (void)connectPeripheralConnection:(ISBLEPeripheralInfo *)peripheralInfo withSuccess:(blueToothConnectDeviceCallback)success
{
    if (!peripheralInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
            [self.delegate didConnectfail];
        }
        return;
    }
    self.peripheralInfo = peripheralInfo;
    [self.centralMgr connectPeripheral:self.peripheralInfo.peripheral options:nil];
}


- (void)disconnectPeripheralConnection:(ISBLEPeripheralInfo *)peripheralInfo
{
    
    if (!peripheralInfo || ![self isConnected]) {
        return;
    }
    self.loseConnent = YES;
    self.isConnent = NO;
    [self.centralMgr cancelPeripheralConnection:self.peripheralInfo.peripheral];
    [self.findedPeripheralsArray removeAllObjects];
}


/** 发现符合要求的外设，回调 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    // 对外设对象进行强引用
    
    NSLog(@"%@\n%@\n%@",peripheral.name,advertisementData,RSSI);
    ISBLEPeripheralInfo *peripheralInfo = [[ISBLEPeripheralInfo alloc]init];
    peripheralInfo.peripheral               = peripheral;
    peripheralInfo.advertisementData        = advertisementData;
    peripheralInfo.RSSI                     = RSSI;
    if ([self.findedPeripheralsArray containsObject:peripheralInfo]) {
        return;
    }
    [self.findedPeripheralsArray addObject:peripheralInfo];

    if (self.delegate && [self.delegate respondsToSelector:@selector(scanDidDiscoverPeripheral:)]) {
        [self.delegate scanDidDiscoverPeripheral:self.findedPeripheralsArray];
    }
    
  
}

/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    // 可以停止扫描
    [self.centralMgr stopScan];
    
    if (![peripheral isEqual:self.peripheralInfo.peripheral]) {
        return;
    }
    // 设置代理
    self.peripheralInfo.peripheral.delegate = self;
    // 根据UUID来寻找服务
    [self.peripheralInfo.peripheral discoverServices:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectSuccess)] && !self.isConnent) {
        [self.delegate didConnectSuccess];
    }
    self.isConnent = YES;
}

/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.isConnent = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
        [self.delegate didConnectfail];
    }
    self.isConnent = NO;
    self.loseConnent = YES;
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开连接");
    // 断开连接可以设置重新连接 手动断开链接就不要在继续链接了
    if (!self.loseConnent) {
        if (peripheral.state == CBPeripheralStateDisconnected || peripheral.state == CBPeripheralStateDisconnecting) {
            [SVProgressHUD showErrorWithStatus:@"蓝牙设备断开链接,请检查设备是否正常开启"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
                [self.delegate didConnectfail];
            }
            self.isConnent = NO;
            self.loseConnent = YES;
        }else{
            [central connectPeripheral:peripheral options:nil];

        }
    }
    
    
}




#pragma mark - CBPeripheralDelegate

static NSInteger count;
/** 发现服务 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSMutableArray *uuidStringArray = [NSMutableArray array];
    for (CBUUID * uuid in self.servicesIDArray) {
        [uuidStringArray addObject:uuid.UUIDString];
    }
    count = peripheral.services.count;
    for (CBService *service in peripheral.services){
        if ([uuidStringArray containsObject:service.UUID.UUIDString]) {
            
            [peripheral discoverCharacteristics:self.characteristicsIDArray forService:service];
            break;
        }
        count --;
        if (count <= 0) {
            [SVProgressHUD showErrorWithStatus:@"未匹配特征相同的蓝牙设备"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
                    [self.delegate didConnectfail];
                }
            });
            self.isConnent = NO;
            self.loseConnent = YES;
        }
        

        
    }
}

/** 发现特征回调 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    self.characteristic = service.characteristics.firstObject;
    
    if (self.characteristic) {
        [self.peripheralInfo.peripheral readValueForCharacteristic:self.characteristic ];
        [self.peripheralInfo.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    }else{
        [SVProgressHUD showErrorWithStatus:@"未匹配特征相同的蓝牙设备"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
                [self.delegate didConnectfail];
                
            }
            
        });
        self.isConnent = NO;
        self.loseConnent = YES;
    }
}

/** 订阅状态的改变  */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }else{
        if (characteristic.isNotifying) {
            NSLog(@"订阅成功");
        } else {
            NSLog(@"取消订阅");
        }
    }
    
}

/**
 
 读写操作
 */
#pragma mark - read & write
- (void)readCharacteristic:(CBCharacteristic *)characteristic
{
    if (!self.peripheralInfo) {
        return;
    }
    [self.peripheralInfo.peripheral readValueForCharacteristic:characteristic];
}

- (void)writeData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic
{
    if (!characteristic) {
        [SVProgressHUD showErrorWithStatus:@"未匹配到蓝牙设备"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectfail)]) {
            [self.delegate didConnectfail];
        }
        [self.centralMgr cancelPeripheralConnection:self.peripheralInfo.peripheral];
        self.isConnent = NO;
        self.loseConnent = YES;
        
        return;
    }
    [self.peripheralInfo.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


/**
 发送数据到蓝牙设备需要回调代理方法

 @param peripheral 外连设备
 @param characteristic 特征
 @param error 错误
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }else{
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"发送指令成功\n蓝牙设备为%@\n%@",peripheral.name,peripheral.identifier]];
    }
}

- (BOOL)isConnected
{
    return self.peripheralInfo.peripheral.state == CBPeripheralStateConnected;
}




- (NSMutableArray <ISBLEPeripheralInfo *>*)findedPeripheralsArray{
    if (nil == _findedPeripheralsArray) {
        _findedPeripheralsArray = [NSMutableArray array];
    }
    return _findedPeripheralsArray;
}










/**
 iOS 外设

 @param peripheral 外设信息

 */
- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    if (peripheral.state == CBManagerStatePoweredOn) {
      
    }
}

///** 创建服务和特征 */
//- (void)setupServiceAndCharacteristics {
//    // 创建服务
//    CBUUID *serviceID = [CBUUID UUIDWithString:SERVICE_UUID];
//    CBMutableService *service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
//    // 创建服务中的特征
//    CBUUID *characteristicID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
//    CBMutableCharacteristic *characteristic = [
//                                               [CBMutableCharacteristic alloc]
//                                               initWithType:characteristicID
//                                               properties:
//                                               CBCharacteristicPropertyRead |
//                                               CBCharacteristicPropertyWrite |
//                                               CBCharacteristicPropertyNotify
//                                               value:nil
//                                               permissions:CBAttributePermissionsReadable |
//                                               CBAttributePermissionsWriteable
//                                               ];
//    // 特征添加进服务
//    service.characteristics = @[characteristic];
//    // 服务加入管理
//    [self.peripheralManager addService:service];
//    
//    // 为了手动给中心设备发送数据
//    self.characteristic = characteristic;
//}

@end
