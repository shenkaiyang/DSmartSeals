//
//  ISDataUtils.h
//  IntelligentSeals
//
//  Created by iCourt  on 2018/5/5.
//  Copyright © 2018年 iCourt . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISDataUtils : NSObject
/**
 *  @brief 反转字节序列
 *
 *  @param  srcData 原始字节NSData
 *
 *  @return 反转序列后字节NSData
 */
+ (nonnull NSData * )dataWithReverse:(nonnull NSData *)srcData;

/**
 *  @brief 将数值转成字节。编码方式：低位在前，高位在后
 *
 *  @param   value    原始int值
 *
 *  @return  转换后的NSData
 */
+ (nonnull NSData *)byteFromInt8:( int8_t)value;
+ (nonnull NSData *)bytesFromInt16:(int16_t)value;
+ (nonnull NSData *)bytesFromInt32:(int32_t)value;
+ (nonnull NSData *)bytesFromInt64:(int64_t)value;
/**
 *  @brief 将数值转成字节。编码方式：低位在前，高位在后
 *
 *  @param   value        原始int值
 *  @param   byteCount    需要转换的字节数 eg : int32 为4
 *  @return  转换后的NSData
 */
+ (nonnull NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount;
/**
 *  @brief 将数值转成字节。编码方式：低位在前，高位在后
 *
 *  @param   value        原始int值
 *  @param   byteCount    需要转换的字节数 eg : int32 为4
 *  @param   reverse      是否反转字节序 默认为低位在前，高位在后
 *  @return  转换后的NSData
 */
+ (nonnull NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount reverse:(BOOL)reverse;
/**
 *  @brief 将字节转成数值。解码方式：前序字节为低位，后续字节为高位
 *
 *  @param   data        原始int值
 *  @return  转换后的NSData
 */
+ (int8_t)int8FromBytes:(nonnull NSData *)data;
+ (int16_t)int16FromBytes:(nonnull NSData *)data;
+ (int32_t)int32FromBytes:(nonnull NSData *)data;
+ (int64_t)int64FromBytes:(nonnull NSData *)data;
+ (int64_t)valueFromBytes:(nonnull NSData *)data;
/**
 *  @brief 将字节转成数值。解码方式：前序字节为低位，后续字节为高位
 *
 *  @param   data         原始字节
 *  @param   reverse      是否反转字节序 默认为低位在前，高位在后
 *  @return  转换后的数值
 */
+ (int64_t)valueFromBytes:(nonnull NSData *)data reverse:(BOOL)reverse;
/**
 *  @brief 将字符串转换为data。例如：返回8个字节的data， upano --> <7570616e 6f000000>
 *
 *  @param   normalString        原始字符串
 *  @param   byteCount           需要转换成的字节数
 *  @return  转换后的NSData
 */
+ (nonnull NSData *)dataFromNormalString:(nonnull NSString *)normalString byteCount:(int)byteCount;
/**
 *  @brief 将16进制字符串转换为data。24211D3498FF62AF  -->  <24211D34 98FF62AF>
 *
 *  @param   hexString           原始十六进制字符串
 *  @return  转换后的NSData
 */
+ (nonnull NSData *)dataFromHexString:(nonnull NSString *)hexString;
/**
 *  @brief data转换为16进制字符串。<24211D34 98FF62AF>  -->  24211D3498FF62AF
 *
 *  @param   data           原始字节
 *  @return  转换后的16进制字符串
 */
+ (nonnull NSString *)hexStringFromData:(nonnull NSData *)data;
/**
 *  @brief hex字符串转换为ascii码。00de0f1a8b24211D3498FF62AF -->  3030646530663161386232343231314433343938464636324146
 *
 *  @param   hexString           原始十六进制字符串
 *  @return  转换后的ascii字符串
 */
/**  */
+ (nonnull NSString *)asciiStringFromHexString:(nonnull NSString *)hexString;
/**
 *  @brief   ascii码转换为hex字符串。343938464636324146 --> 498FF62AF
 *
 *  @param   asciiString            原始asciiString字符串
 *  @return  转换后的hex字符串
 */
+ (nonnull NSString *)hexStringFromASCIIString:(nonnull NSString *)asciiString;

+ (NSString *)convertToNSStringWithNSData:(NSData *)data;

@end
