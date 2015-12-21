//
//  StudentListModel.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/23.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "StudentListModel.h"

@implementation StudentListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"])
        self.ID = value;
}
@end
