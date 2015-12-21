//
//  WalletsModel.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/23.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletsModel : NSObject
@property(nonatomic,retain) NSString *mname; //持卡人名字
@property(nonatomic,retain) NSString *mnum;//银行卡账号
@property(nonatomic,retain) NSString *mtype; //银行卡类型
@property(nonatomic,retain) NSString *myhname; //银行名字
@property(nonatomic,retain) NSString *id_card;//持卡人身份证
@property(nonatomic,retain) NSString *mtel; //预留号码
@end
