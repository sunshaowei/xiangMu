//
//  BalanceWithdrawalsTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/19.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "BalanceWithdrawalsTableViewCell.h"

@interface BalanceWithdrawalsTableViewCell ()
@end

@implementation BalanceWithdrawalsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cardImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.cardImage];
        
        self.bankName = [[UILabel alloc] init];
        [self.contentView addSubview:self.bankName];
        
        self.cardStyle = [[UILabel alloc] init];
        [self.contentView addSubview:self.cardStyle];
        
        self.cardNumber = [[UILabel alloc] init];
        [self.contentView addSubview:self.cardNumber];
        
        UIImageView *new =[[UIImageView alloc] initWithFrame:CGRectMake(370*OffWidth, 60*OffHeight, 10*OffWidth, 15*OffHeight)];
        new.image = [UIImage imageNamed:@"iconfont-youjiantou-副本-2@2x.png"];
        [self.contentView addSubview:new];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cardImage.frame = CGRectMake(20*OffWidth, 30*OffHeight, 40*OffWidth, 40*OffHeight);
    //self.cardImage.backgroundColor = [UIColor yellowColor];
    self.cardImage.layer.cornerRadius = 20;
    
    self.bankName.frame  =CGRectMake(80*OffWidth, 30*OffHeight, 200*OffWidth, 40*OffHeight);
    //self.bankName.text = @"银行名称";
    self.bankName.font = [UIFont systemFontOfSize:25];
    
    self.cardStyle.frame = CGRectMake(80*OffWidth, 70*OffHeight, 100*OffWidth, 20*OffHeight);
    //self.cardStyle.text = @"卡类型";
    self.cardStyle.font = [UIFont systemFontOfSize:15];
    //[self.cardStyle setTextColor:[UIColor grayColor]];
    
    self.cardNumber.frame = CGRectMake(80*OffWidth, 100*OffHeight, 300*OffWidth, 30*OffHeight);
    //self.cardNumber.text = @"*******************1234";
    self.cardNumber.font = [UIFont systemFontOfSize:20];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
