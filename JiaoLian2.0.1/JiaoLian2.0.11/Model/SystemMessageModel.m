//
//  SystemMessageModel.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/23.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "SystemMessageModel.h"

@implementation SystemMessageModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"])
        self.ID = value;
}
@end
