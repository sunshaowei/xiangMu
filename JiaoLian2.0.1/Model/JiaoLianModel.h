//
//  JiaoLianModel.h
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/25.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiaoLianModel : NSObject
@property(nonatomic,strong)NSString*ID;
@property(nonatomic,strong)NSString*c1_offer;
@property(nonatomic,strong)NSString*c2_offer;
@property(nonatomic,strong)NSString*cname;//教练名字
@property(nonatomic,strong)NSString*driving_coaching_grid;//场地
@property(nonatomic,strong)NSString*schname;//学名字
@property(nonatomic,strong)NSString*teach_exp;//教龄
@property(nonatomic,strong)NSString*photo_zip_url;//头像

@end
