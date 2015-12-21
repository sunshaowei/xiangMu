//
//  BalanceWithdrawalsTableViewCell.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/19.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceWithdrawalsTableViewCell : UITableViewCell
@property(nonatomic,retain) UIImageView *cardImage; //银行卡图片
@property(nonatomic,retain) UILabel *bankName; //银行名
@property(nonatomic,retain) UILabel *cardStyle; //银行卡类型
@property(nonatomic,retain) UILabel *cardNumber; //银行卡号

@end
