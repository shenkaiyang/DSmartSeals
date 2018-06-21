//
//  ScanViewController.m
//  DSmartSeals
//
//  Created by shenkaiyang on 2018/6/14.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import "ScanViewController.h"
#import "DBluetoothManager.h"
#import "ISDataUtils.h"
#import "SVProgressHUD.h"
#import "DUSealViewController.h"
#define SERVICE_UUID @"FFE0"
//6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTICNotify_UUID @"FFE2"
//@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTICWrite_UUID @"FFE1"
//@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"

@interface ScanViewController ()<DBluetoothManagerDelegate>
@property (nonatomic, readwrite, copy  ) NSString       *sealMacString;

@end

@implementation ScanViewController



#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    self.sealMacString = strResult;
    [DBluetoothManager shareInstance].delegate = self;
//    [DBluetoothManager shareInstance].characteristicsIDArray = @[[CBUUID UUIDWithString:CHARACTERISTICWrite_UUID],[CBUUID UUIDWithString:CHARACTERISTICNotify_UUID]];;
    [[DBluetoothManager shareInstance] startScanPeripherals:@[]];
//    [CBUUID UUIDWithString:SERVICE_UUID]
    
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    [self reStartDevice];
 
}




- (void)scanDidDiscoverPeripheral:(NSMutableArray <ISBLEPeripheralInfo*> *)peripherals{
    if (peripherals.count > 0) {
        ISBLEPeripheralInfo *willConnectPeripheral;
        for (ISBLEPeripheralInfo *bleInfo in peripherals) {
            NSData *macData = bleInfo.advertisementData[@"kCBAdvDataManufacturerData"];
            
            NSString *macString = [ISDataUtils convertToNSStringWithNSData:macData];
            macString = [macString stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([macString.lowercaseString hasSuffix:self.sealMacString.lowercaseString]) {
                willConnectPeripheral = bleInfo;
                break;
            }
        }
        if (!willConnectPeripheral) {
            
            return ;
        }
        
        [[DBluetoothManager shareInstance] connectPeripheralConnection:willConnectPeripheral withSuccess:^(ISBLEPeripheralInfo *perpheral, BOOL success) {

        }];
        
    }
    
}

/**
 链接成功
 */
-(void)didConnectSuccess{
     [self reStartDevice];
    DUSealViewController *vc = [[DUSealViewController alloc]initWithNibName:@"DUSealViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];

}
/**
 链接失败
 */
- (void)didConnectfail{
    [self reStartDevice];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FAIL" object:nil];
    NSLog(@"-----fail");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraInvokeMsg = @"相机启动中";
    self.title = @"扫码";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
