//
//  BalanceTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "BalanceTableViewCell.h"
#import "Color.h"
@interface BalanceTableViewCell ()
@end


@implementation BalanceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.rootController =[[UIViewController alloc] init];
        
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(20*OffWidth, 10*OffHeight, 38*OffWidth, 38*OffHeight)];
        [self.contentView addSubview:self.picView];
        
        self.balanceLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.balanceLable];
        
        self.withdrawsButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.withdrawsButton];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picView.frame = CGRectMake(20*OffWidth, 15*OffHeight, 35*OffWidth, 38*OffHeight);
    self.picView.image = [UIImage imageNamed:@"iconfont-zhanghuyue@3x.png"];
    
    self.balanceLable.frame = CGRectMake(68*OffWidth, 10*OffHeight, 300*OffWidth, 56*OffHeight);
    self.balanceLable.font = [UIFont systemFontOfSize:22.5];
    //self.balanceLable.text = @"余额 0.00";
    
    self.withdrawsButton.frame = CGRectMake(self.frame.size.width - 130*OffWidth, 10*OffHeight, 110*OffWidth,56*OffHeight);
    [self.withdrawsButton setTitle:@"提现" forState:UIControlStateNormal];
    self.withdrawsButton.titleLabel.font = [UIFont systemFontOfSize:22.5];
    [self.withdrawsButton setBackgroundColor:kUIColorFromRGB(0x6fc4b2)];
    self.withdrawsButton.layer.cornerRadius = 10;
    [self.withdrawsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonClick:(id)sender
{
    [self.delegate withdrawsButtonAction:self];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
