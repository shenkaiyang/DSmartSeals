//
//  DUSealViewController.m
//  DSmartSeals
//
//  Created by shenkaiyang on 2018/6/15.
//  Copyright © 2018年 shenkaiyang. All rights reserved.
//

#import "DUSealViewController.h"
#import "DBluetoothManager.h"
@interface DUSealViewController ()

@end

@implementation DUSealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能印章";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failAction) name:@"FAIL" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)failAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DBluetoothManager shareInstance] disconnectPeripheralConnection:[DBluetoothManager shareInstance].peripheralInfo];
}


- (IBAction)operatingSealAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            {
                Byte dataArr[2];
                //数据D3
                dataArr[0]=0x0044; dataArr[1]=0x0033;
                NSData * myData = [NSData dataWithBytes:dataArr length:2];

                [self sendDataToBLE:myData];
            }
            break;
        case 101:
        {
            Byte dataArr[2];
            //数据D3
            dataArr[0]=0x0044; dataArr[1]=0x0033;
            NSData * myData = [NSData dataWithBytes:dataArr length:2];
            
            [self sendDataToBLE:myData];
            
        }
            break;
        case 102:
        {
            Byte dataArr[2];
            //数据D3
            dataArr[0]=0x0044; dataArr[1]=0x0033;
            NSData * myData = [NSData dataWithBytes:dataArr length:2];
            
            [self sendDataToBLE:myData];
        }
            break;
        case 103:
        {
            Byte dataArr[2];
            //数据D3
            dataArr[0]=0x0044; dataArr[1]=0x0033;
            NSData * myData = [NSData dataWithBytes:dataArr length:2];
            
            [self sendDataToBLE:myData];
        }
            break;
        case 104:
        {
            Byte dataArr[2];
            //数据D3
            dataArr[0]=0x0044; dataArr[1]=0x0033;
            NSData * myData = [NSData dataWithBytes:dataArr length:2];
            
            [self sendDataToBLE:myData];
        }
            break;
        default:
            break;
    }
}
-(void)sendDataToBLE:(NSData *)data{
    [[DBluetoothManager shareInstance] writeData:data forCharacteristic:[DBluetoothManager shareInstance].characteristic];
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
