//
//  ISBLEPeripheralInfo.m
//  IntelligentSeals
//
//  Created by iCourt  on 2018/5/10.
//  Copyright © 2018年 iCourt . All rights reserved.
//

#import "ISBLEPeripheralInfo.h"

@interface ISBLEPeripheralInfo()

- (BOOL)isEqualToPeripheralInfo:(ISBLEPeripheralInfo *)peripheralInfo;
@end

@implementation ISBLEPeripheralInfo

#pragma mark private
- (BOOL)isEqualToPeripheralInfo:(ISBLEPeripheralInfo *)peripheralInfo
{
    if (!peripheralInfo) {
        return NO;
    }
    BOOL haveEqualPeripheral = [self.peripheral.identifier isEqual:peripheralInfo.peripheral.identifier];
    
    return haveEqualPeripheral;
}

#pragma mark NSObject
- (BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ISBLEPeripheralInfo class]]) {
        return NO;
    }
    
    return [self isEqualToPeripheralInfo:(ISBLEPeripheralInfo *)object];
}

@end
