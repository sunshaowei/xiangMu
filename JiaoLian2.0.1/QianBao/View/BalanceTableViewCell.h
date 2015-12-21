//
//  BalanceTableViewCell.h
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BalanceTableViewCellDelegate;

@interface BalanceTableViewCell : UITableViewCell
@property(nonatomic,assign) id<BalanceTableViewCellDelegate>delegate;

@property(nonatomic,retain) UIImageView *picView;
@property(nonatomic,retain) UILabel *balanceLable;
@property(nonatomic,retain) UIButton *withdrawsButton; //提现按钮

@end

@protocol BalanceTableViewCellDelegate <NSObject>

- (void)withdrawsButtonAction:(id)sender;

@end