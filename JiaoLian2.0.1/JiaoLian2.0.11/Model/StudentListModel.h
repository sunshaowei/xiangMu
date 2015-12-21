//
//  StudentListModel.h
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/23.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentListModel : NSObject
@property(nonatomic,strong)NSString*ID;
@property(nonatomic,strong)NSString*head_url;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*driving;//是c1还是c2
@property(nonatomic,strong)NSString*schedule;//进度
@property(nonatomic,strong)NSString*sname;//名字

@end
