//
//  PersonalInfoTableViewCell.m
//  PersonalCenter
//
//  Created by 戴文博 on 15/11/20.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"
#import "Color.h"
@interface PersonalInfoTableViewCell ()

@end

@implementation PersonalInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pic = [[UIImageView alloc] init];
        [self.contentView addSubview:self.pic];
        
        self.infoField = [[UITextField alloc] init];
        [self.contentView addSubview:self.infoField];
    }
    return self;
}

- (void)layoutSubviews
{
    self.pic.frame = CGRectMake(20, 20, 30, 30);
    self.infoField.frame = CGRectMake(90, 20, 300, 30);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, 10)];
    view.backgroundColor = kUIColorFromRGB(0xF5F5F5);
    [self addSubview:view];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
