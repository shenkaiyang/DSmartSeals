//
//  ISBLECommandConstant.h
//  IntelligentSeals
//
//  Created by iCourt  on 2018/5/14.
//  Copyright © 2018年 iCourt . All rights reserved.
//

#import <Foundation/Foundation.h>
// 协议中的 命令类型
typedef NS_ENUM(NSInteger, ISBLECommandCmdType) {
    ISBLECommandCmdTypeConnect      = 0x01, // 连接请求：手机连接设备，由App发起
    ISBLECommandCmdTypeConnack      = 0x02, // 连接确认：设备收到连接请求后，返回确认信息
    ISBLECommandCmdTypePublish      = 0x03, // 推送消息：App端发起控制命令来操作设备
    ISBLECommandCmdTypePuback       = 0x04, // 推送确认：设备收到控制命令后，返回确认信息
    ISBLECommandCmdTypeNotify       = 0x05, // 上报消息：设备上报设备信息给手机App
    ISBLECommandCmdTypeNotack       = 0x06, // 上报确认：App收到上报信息后，返回确认信息
    ISBLECommandCmdTypePingReq      = 0x07, // 连接心跳：App发起心跳
    ISBLECommandCmdTypePingRes      = 0x08, // 心跳确认：设备收到App的心跳后，返回确认信息
    ISBLECommandCmdTypeDisconn      = 0x09, // 断开连接：手机断开设备蓝牙，由App发起
    ISBLECommandCmdTypeDisconnack   = 0x0A  // 断开确认：设备收到断开请求后，返回确认信息并断开连接
};

typedef NS_ENUM(NSInteger, ISBLECommandDataType) {
    ISBLECommandDataTypeConnectTime              = 0x0101,       // 连接时间：Value:6bytes(year/month/date/hour/minute/second)
    ISBLECommandDataTypePublishOpenCover         = 0x0301,       // 推送打开盖子请求：Value:0 byte
    ISBLECommandDataTypePublishStamp             = 0x0302,       // 推送盖章请求：Value:0 byte
    ISBLECommandDataTypePublishStretchStamp      = 0x0303,       // 推送伸出章模请求：Value:0 byte
    ISBLECommandDataTypePublishRetractStamp      = 0x0304,       // 推送缩回章模请求：Value:0 byte
    ISBLECommandDataTypePublishCloseCover        = 0x0305,       // 推送关闭盖子请求：Value:0 byte
    ISBLECommandDataTypePublishQRCode            = 0x0306,       // 推送二维码信息：Value:4 byte
    ISBLECommandDataTypePubackOpenCover          = 0x0401,       // 设备确认收到打开盖子请求：Value:0 byte
    ISBLECommandDataTypePubackStamp              = 0x0402,       // 设备确认收到盖章请求：Value:0 byte
    ISBLECommandDataTypePubackStretchStamp       = 0x0403,       // 设备确认收到：Value:0 byte
    ISBLECommandDataTypePubackRetractStamp       = 0x0404,       // 设备确认收到缩回章模请求 Value: 0 byte
    ISBLECommandDataTypePubackCloseCover         = 0x0405,       // 设备确认收到关闭盖子请求：Value:0 byte
    ISBLECommandDataTypePubackQRCode             = 0x0406,       // 设备确认收到二维码信息：Value:0 byte
    ISBLECommandDataTypeNotifyOpenCoverStatus    = 0x0501,       // 上报打开盖子完成状态：Value:1 byte(0x00: suc   0x01:fail)
    ISBLECommandDataTypeNotifyStampStatus        = 0x0502,       // 上报盖章完成状态：Value: 1byte(0x00: suc   0x01:fail)
    ISBLECommandDataTypeNotifyStretchStamp       = 0x0503,       // 上报伸出章模完成状态：Value:1 byte(0x00: suc   0x01:fail)
    ISBLECommandDataTypeNotifyRetractStamp       = 0x0504,       // 上报缩回章模完成状态：Value:1 byte(0x00: suc   0x01:fail)
    ISBLECommandDataTypeNotifyCloseCoverStatus   = 0x0505,       // 上报关闭盖子完成状态：Value:1 byte(0x00: suc   0x01:fail)
    ISBLECommandDataTypeNotifyDeviceAlarm        = 0x0506,       // 设备报警：Value:1 byte(0x01: 印章未伸出时，强行将纸张塞进印章内触发报警；其他待定)
    ISBLECommandDataTypeNotackOpenCoverStatus    = 0x0601,       // APP确认收到设备上报打开盖子完成状态：Value:0 byte
    ISBLECommandDataTypeNotackStampStatus        = 0x0602,       // APP确认收到设备上报盖章完成状态：Value:0 byte
    ISBLECommandDataTypeNotackStretchStamp       = 0x0603,       // APP确认收到设备上报伸出章模完成状态：Value:0 byte
    ISBLECommandDataTypeNotackRetractStamp       = 0x0604,       // APP确认收到设备上报缩回章模完成状态：Value:0 byte
    ISBLECommandDataTypeNotackCloseCoverStatus   = 0x0605,       // APP确认收到设备上报关闭盖子完成状态：Value:0 byte
    ISBLECommandDataTypeNotackDeviceAlarm        = 0x0606,       // APP确认收到设备报警信息：Value:0 byte
};

@interface ISBLECommandConstant : NSObject

@end
