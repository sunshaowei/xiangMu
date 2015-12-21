//
//  IncomeDetailTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/23.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"

@implementation IncomeDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _reasonLable = [[UILabel alloc] init];
        [self.contentView addSubview:_reasonLable];
        
        _money = [[UILabel alloc] init];
        [self.contentView addSubview:_money];
        
        _timeLable = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLable];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _reasonLable.frame = CGRectMake(20*OffWidth, 20*OffHeight, 100*OffWidth, 30*OffHeight);
    
    _money.frame = CGRectMake(140*OffWidth, 20*OffHeight, 200*OffWidth, 30*OffHeight);
    
    _timeLable.frame = CGRectMake(self.frame.size.width - 220*OffWidth, 50*OffHeight, 200*OffWidth, 30*OffHeight);
    _timeLable.textAlignment = NSTextAlignmentRight;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
