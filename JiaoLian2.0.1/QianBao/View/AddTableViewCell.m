//
//  AddTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "AddTableViewCell.h"

@implementation AddTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20*OffWidth, 30*OffHeight, 30*OffWidth, 30*OffHeight)];
        pic.image = [UIImage imageNamed:@"iconfont-jia@3x.png"];
        [self.contentView addSubview:pic];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80*OffWidth, 30*OffHeight, 200*OffWidth, 30*OffHeight)];
        lable.text = @"添加银行卡";
        lable.font = [UIFont systemFontOfSize:25];
        [self.contentView addSubview:lable];
        
        UIImageView *newPic = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 35*OffHeight, 10*OffWidth, 15*OffHeight)];
        newPic.image = [UIImage imageNamed:@"iconfont-youjiantou-副本-2@3x.png"];
        [self.contentView addSubview:newPic];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
