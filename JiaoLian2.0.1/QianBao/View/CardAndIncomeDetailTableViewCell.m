//
//  CardAndIncomeDetailTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "CardAndIncomeDetailTableViewCell.h"

@interface CardAndIncomeDetailTableViewCell ()
@end


@implementation CardAndIncomeDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picView];
        
        self.nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picView.frame = CGRectMake(20*OffWidth, 20*OffHeight, 38*OffWidth, 30*OffHeight);
    self.nameLable.frame = CGRectMake(78*OffWidth, 20*OffHeight, 200*OffWidth, 30*OffHeight);
    self.nameLable.font = [UIFont systemFontOfSize:22.5];
    //self.nameLable.font = [UIFont fontWithName:@"HiraginoSansGB W3" size:30];
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40*OffWidth, 25*OffHeight, 10*OffWidth, 20*OffHeight)];
    [self.contentView addSubview:pic];
    pic.image = [UIImage imageNamed:@"iconfont-youjiantou-副本-2@3x.png"];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
