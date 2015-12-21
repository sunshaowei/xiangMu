//
//  MD5.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/18.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5
+(NSString*)stringToMD5Str:(NSString*)str{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);//这地方(CC_LONG)来了个强转，消除了警告
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
@end
