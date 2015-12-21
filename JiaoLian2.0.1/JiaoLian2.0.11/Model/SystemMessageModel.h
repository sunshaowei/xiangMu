//
//  SystemMessageModel.h
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/23.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject
@property(nonatomic,strong)NSString*cname;//教练name
@property(nonatomic,strong)NSString*msg_content;//消息内容
@property(nonatomic,strong)NSString*crt_time;//时间
@property(nonatomic,strong)NSString*ID;
@property(nonatomic,strong)NSString*msg_type;//消息类型
@property(nonatomic,strong)NSString*msg_status;//消息状态0已删除，1未读，2已读
@end
