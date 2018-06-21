//
//  ISBLEPeripheralInfo.h
//  IntelligentSeals
//
//  Created by iCourt  on 2018/5/10.
//  Copyright © 2018年 iCourt . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
/**
 *  @brief 用来记录 外设设备的消息
 */
@interface ISBLEPeripheralInfo : NSObject
/**
 *  @brief 外设
 */
@property (nonatomic, readwrite, strong) CBPeripheral *peripheral;
/**
 *  @brief 发现外设时的广播数据
 */
@property (nonatomic, readwrite, strong) NSDictionary<NSString *, id> *advertisementData;
/**
 *  @brief 发现外设时的RSSI  代表信号强弱
 */
@property (nonatomic, readwrite, strong) NSNumber     *RSSI;

@end
