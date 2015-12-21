//
//  WalletTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "WalletTableViewCell.h"

@interface WalletTableViewCell ()
//@property(nonatomic,retain) UIImageView *cardImage; //银行卡图片
//@property(nonatomic,retain) UILabel *bankName; //银行名
//@property(nonatomic,retain) UILabel *cardStyle; //银行卡类型
//@property(nonatomic,retain) UILabel *cardNumber; //银行卡号
//
@end

@implementation WalletTableViewCell
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
        
        
        self.selectedButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.selectedButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cardImage.frame = CGRectMake(20*OffWidth, 30*OffHeight, 40*OffWidth, 40*OffHeight);
    self.cardImage.layer.cornerRadius = 20;
    
    self.bankName.frame  =CGRectMake(80*OffWidth, 30*OffHeight, 200*OffWidth, 40*OffHeight);
    //self.bankName.text = @"银行名称";
    self.bankName.font = [UIFont systemFontOfSize:25];
    
    self.cardStyle.frame = CGRectMake(80*OffWidth, 70*OffHeight, 100*OffWidth, 20*OffWidth);
    //self.cardStyle.text = @"卡类型";
    self.cardStyle.font = [UIFont systemFontOfSize:15];
    [self.cardStyle setTextColor:[UIColor grayColor]];
    
    self.cardNumber.frame = CGRectMake(80*OffWidth, 100*OffHeight, 300*OffWidth, 30*OffHeight);
    //self.cardNumber.text = @"*******************1234";
    self.cardNumber.font = [UIFont systemFontOfSize:20];
    
    self.selectedButton.frame = CGRectMake(370*OffWidth, 60*OffHeight, 20*OffWidth, 20*OffHeight);
   // self.selectedButton.backgroundColor = [UIColor yellowColor];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
