//
//  UTF8Two.m
//  jieKouCeShi
//
//  Created by 孙少伟 on 15/11/30.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "UTF8Two.h"

@implementation UTF8Two
+(NSString*)stringToUTF8Str:(NSString*)str{

    NSString*str1=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    NSString*str2=[ str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str2;
}

@end
