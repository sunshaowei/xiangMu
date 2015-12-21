//
//  AddStepTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/18.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "AddStepTableViewCell.h"

@implementation AddStepTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLable];
        
        self.nameField = [[UITextField alloc] init];
        [self.contentView addSubview:self.nameField];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLable.frame = CGRectMake(21*OffWidth, 30*OffHeight, 150*OffWidth, 30*OffHeight);
    self.nameLable.font = [UIFont systemFontOfSize:22.5];
    
    self.nameField.frame = CGRectMake(171*OffWidth, 30*OffHeight, 200*OffWidth, 30*OffHeight);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
