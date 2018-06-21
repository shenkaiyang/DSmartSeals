//
//  RootViewController.m
//  DSmartSeals
//
//  Created by shenkaiyang on 2018/6/14.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import "RootViewController.h"

#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "LBXScanViewStyle.h"
#import <ZXBarcodeFormat.h>
#import "ScanViewController.h"



@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能印章";
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view, typically from a nib.
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanAction:(UIButton *)sender {
    
    
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            ScanViewController *scanVC = [ScanViewController new];
            scanVC.isOpenInterestRect = YES;
            scanVC.style = [weakSelf recoCropRect];
            scanVC.libraryType = SLT_Native;
            scanVC.scanCodeType = SCT_QRCode;
            
            [weakSelf.navigationController pushViewController:scanVC animated:YES];        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];

  
}

#pragma mark -框内区域识别
- (LBXScanViewStyle*)recoCropRect
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 80;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    return style;
}

@end
