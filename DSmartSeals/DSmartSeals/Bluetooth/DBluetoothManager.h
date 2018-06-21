//
//  DBluetoothManager.h
//  DSmartSeals
//
//  Created by shenkaiyang on 2018/6/14.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ISBLEPeripheralInfo.h"

@protocol DBluetoothManagerDelegate <NSObject>

/**
 
扫码设备代理
 @param peripherals 设备数组
 */
- (void)scanDidDiscoverPeripheral:(NSMutableArray <ISBLEPeripheralInfo*> *)peripherals;


/**
 链接成功
 */
- (void)didConnectSuccess;


/**
 链接失败
 */
- (void)didConnectfail;







@end;



/**
 * 连接设备回调
 */
typedef void (^blueToothConnectDeviceCallback)(ISBLEPeripheralInfo *perpheral,BOOL success);
/**
 * 设备断开连接回调
 */
typedef void (^blueToothDisconnectCallback)(ISBLEPeripheralInfo *peripheral , BOOL success );

/**
 * 读取RSSI回调，次回掉之后会一次返回结果
 */
typedef void (^blueToothReadRSSICallback)(ISBLEPeripheralInfo *peripheral , NSNumber *RSSI , BOOL success);

/**
 * 寻找设备中的服务回掉
 */
typedef void (^blueToothFindServiceCallback)(ISBLEPeripheralInfo *peripheral , NSArray<ISBLEPeripheralInfo *> *serviceArray , BOOL success);


@interface DBluetoothManager : NSObject


/**
 蓝牙链接中心

 @return 当前实例
 */
+(instancetype)shareInstance;

/**
 *  @brief 想要连接外设设备的 services的 id 数组 为了过滤用
 */
@property (nonatomic, readwrite, strong) NSArray <CBUUID *>       *servicesIDArray;
/**
 *  @brief 想要连接外设设备的 的 characteristics ID 数组 为了过滤用
 */
@property (nonatomic, readwrite, strong) NSArray <CBUUID *> *characteristicsIDArray;


@property (nonatomic, readwrite, strong) ISBLEPeripheralInfo *peripheralInfo;

@property (nonatomic, strong)  CBCharacteristic *characteristic;

@property (nonatomic, readwrite, strong) CBCentralManager *centralMgr;

@property (nonatomic, weak) id<DBluetoothManagerDelegate>delegate;

- (void)startScanPeripherals:(NSArray <CBUUID *> *)services;

/**
 开始链接
 */
- (void)connectPeripheralConnection:(ISBLEPeripheralInfo *)peripheralInfo withSuccess:(blueToothConnectDeviceCallback)success;

/**
 断开链接
 */

- (void)disconnectPeripheralConnection:(ISBLEPeripheralInfo *)peripheralInfo;


/**
 发送指令

 @param data 写入data
 @param characteristic 特征
 */
- (void)writeData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;



/**
 重新扫描
 */
- (void)resetScanPeripherals;

@end
