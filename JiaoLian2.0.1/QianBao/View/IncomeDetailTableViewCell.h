//
//  IncomeDetailTableViewCell.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/23.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeDetailTableViewCell : UITableViewCell
@property(nonatomic,retain) UILabel *reasonLable; //输入名称
@property(nonatomic,retain) UILabel *money; //金额
@property(nonatomic,retain) UILabel *timeLable; //报名时间 或 提现时间
@end
