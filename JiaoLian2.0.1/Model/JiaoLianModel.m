//
//  JiaoLianModel.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/25.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "JiaoLianModel.h"

@implementation JiaoLianModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"])
        self.ID = value;
}
@end
