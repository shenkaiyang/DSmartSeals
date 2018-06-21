//
//  ISDataUtils.m
//  IntelligentSeals
//
//  Created by iCourt  on 2018/5/5.
//  Copyright © 2018年 iCourt . All rights reserved.
//

#import "ISDataUtils.h"

@implementation ISDataUtils

+ (NSData *)dataWithReverse:(NSData *)srcData
{
    NSUInteger byteCount = srcData.length;
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:srcData];
    NSUInteger halfLength = byteCount / 2;
    
    NSRange begin;
    NSRange end;
    
    NSData  *beginData;
    NSData  *endData;
    for (NSUInteger i=0; i<halfLength; i++) {
        begin           = NSMakeRange(i, 1);
        end             = NSMakeRange(byteCount - i - 1, 1);
        beginData       = [srcData subdataWithRange:begin];
        endData         = [srcData subdataWithRange:end];
        
        [dstData replaceBytesInRange:begin withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:beginData.bytes];
    }
    return dstData;
}

+ (NSData *)byteFromInt8:(int8_t)value
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&value length:1];
    return valData;
}

+ (NSData *)bytesFromInt16:(int16_t)value
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&value length:2];
    return valData;
}

+ (NSData *)bytesFromInt32:(int32_t)value
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&value length:4];
    return valData;
}

+ (NSData *)bytesFromInt64:(int64_t)value
{
    NSMutableData *tempData = [[NSMutableData alloc] init];
    [tempData appendBytes:&value length:8];
    return tempData;
}

+ (NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    int64_t tempVal = value;
    int offset = 0;
    
    while (offset < byteCount) {
        unsigned char valChar = 0xff & tempVal;
        [valData appendBytes:&valChar length:1];
        tempVal = tempVal >> 8;
        offset++;
    }
    
    return valData;
}

+ (NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount reverse:(BOOL)reverse
{
    NSData *tempData = [self bytesFromValue:value byteCount:byteCount];
    if (reverse) {
        return tempData;
    }
    
    return [self dataWithReverse:tempData];
}

+ (int8_t)int8FromBytes:(NSData *)data
{
    NSAssert(data.length >= 1, @"uint8FromBytes: (data length < 1)");
    
    int8_t val = 0;
    [data getBytes:&val length:1];
    return val;
}

+ (int16_t)int16FromBytes:(NSData *)data
{
    NSAssert(data.length >= 2, @"uint16FromBytes: (data length < 2)");
    
    int16_t val = 0;
    [data getBytes:&val length:2];
    return val;
}

+ (int32_t)int32FromBytes:(NSData *)data
{
    NSAssert(data.length >= 4, @"uint16FromBytes: (data length < 4)");
    
    int32_t val = 0;
    [data getBytes:&val length:4];
    return val;
}

+ (int64_t)int64FromBytes:(NSData *)data
{
    NSAssert(data.length >= 8, @"uint16FromBytes: (data length < 8)");
    
    int64_t val = 0;
    [data getBytes:&val length:8];
    return val;
}

+ (int64_t)valueFromBytes:(NSData *)data
{
    NSUInteger dataLen = data.length;
    int64_t value = 0;
    int offset = 0;
    
    while (offset < dataLen) {
        int32_t tempVal = 0;
        [data getBytes:&tempVal range:NSMakeRange(offset, 1)];
        value += (tempVal << (8 * offset));
        offset++;
    }//while
    
    return value;
}

+ (int64_t)valueFromBytes:(NSData *)data reverse:(BOOL)reverse
{
    NSData *tempData = data;
    if (reverse) {
        tempData = [self dataWithReverse:tempData];
    }
    return [self valueFromBytes:tempData];
}

+ (NSData *)dataFromNormalString:(NSString *)normalString byteCount:(int)byteCount
{
    NSAssert(byteCount > 0, @"byteCount <= 0");
    
    char normalChar[byteCount];
    memset(normalChar, 0, byteCount);
    memcpy(normalChar, [normalString UTF8String], MIN(normalString.length, byteCount));
    return [[NSData alloc] initWithBytes:normalChar length:byteCount];
}

+ (NSData *)dataFromHexString:(NSString *)hexString
{
    NSAssert((hexString.length > 0) && (hexString.length % 2 == 0), @"hexString.length mod 2 != 0");
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSRange   tempRange;
    NSString  *tempStr;
    NSScanner *scanner;
    unsigned int tempIntValue;

    for (NSUInteger i=0; i<hexString.length; i+=2) {
        tempRange = NSMakeRange(i, 2);
        tempStr   = [hexString substringWithRange:tempRange];
        scanner   = [NSScanner scannerWithString:tempStr];
        [scanner scanHexInt:&tempIntValue];
        [data appendBytes:&tempIntValue length:1];
    }
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)data
{
    NSAssert(data.length > 0, @"data.length <= 0");
    NSMutableString *hexString  = [[NSMutableString alloc] init];
    const Byte *bytes           = data.bytes;
    
    Byte value;
    Byte high;
    Byte low;
    
    for (NSUInteger i=0; i<data.length; i++) {
        value = bytes[i];
        high  = (value & 0xf0) >> 4;
        low   =  value & 0xf;
        [hexString appendFormat:@"%x%x", high, low];
    }
    return hexString;
}

+ (NSString *)asciiStringFromHexString:(NSString *)hexString
{
    NSMutableString *asciiString = [[NSMutableString alloc] init];
    const char *bytes            = [hexString UTF8String];
    for (NSUInteger i=0; i<hexString.length; i++) {
        [asciiString appendFormat:@"%0.2X", bytes[i]];
    }
    return asciiString;
}

+ (NSString *)hexStringFromASCIIString:(NSString *)asciiString
{
    NSMutableString *hexString   = [[NSMutableString alloc] init];
    const char *asciiChars       = [asciiString UTF8String];
    for (NSUInteger i=0; i<asciiString.length; i+=2) {
        char hexChar = '\0';
        
        //high
        if (asciiChars[i] >= '0' && asciiChars[i] <= '9') {
            hexChar = (asciiChars[i] - '0') << 4;
        } else if (asciiChars[i] >= 'a' && asciiChars[i] <= 'z') {
            hexChar = (asciiChars[i] - 'a' + 10) << 4;
        } else if (asciiChars[i] >= 'A' && asciiChars[i] <= 'Z') {
            hexChar = (asciiChars[i] - 'A' + 10) << 4;
        }
        
        //low
        if (asciiChars[i+1] >= '0' && asciiChars[i+1] <= '9') {
            hexChar += asciiChars[i+1] - '0';
        } else if (asciiChars[i+1] >= 'a' && asciiChars[i+1] <= 'z') {
            hexChar += asciiChars[i+1] - 'a' + 10;
        } else if (asciiChars[i+1] >= 'A' && asciiChars[i+1] <= 'Z') {
            hexChar += asciiChars[i+1] - 'A' + 10;
        }
        
        [hexString appendFormat:@"%c", hexChar];
    }
    return hexString;
}


+ (NSString *)convertToNSStringWithNSData:(NSData *)data
{
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    
    const unsigned char *szBuffer = [data bytes];
    
    for (NSInteger i=0; i < [data length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    
    return strTemp;
}

@end
