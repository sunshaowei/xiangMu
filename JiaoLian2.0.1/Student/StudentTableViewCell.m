//
//  StudentTableViewCell.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/16.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "StudentTableViewCell.h"
@implementation StudentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImage];
        
        self.nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLable];
        
        self.scheduleLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.scheduleLable];
        
        self.carStyle = [[UILabel alloc] init];
        [self.contentView addSubview:self.carStyle];
        
        self.priceLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLable];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userImage.frame = CGRectMake(15, 10, 80, 80);
    self.userImage.backgroundColor = [UIColor yellowColor];
    self.userImage.layer.cornerRadius = 10;
    
    self.nameLable.frame = CGRectMake(110, 10, 100, 30);
    self.nameLable.font = [UIFont systemFontOfSize:20];
    self.nameLable.backgroundColor = [UIColor redColor];
    
    self.scheduleLable.frame = CGRectMake(110, 60, 150, 30);
    self.scheduleLable.textColor = [UIColor lightGrayColor];
    self.scheduleLable.font = [UIFont systemFontOfSize:17];
    self.scheduleLable.backgroundColor = [UIColor redColor];
    
    self.carStyle.frame = CGRectMake(self.frame.size.width - 150, 10, 30, 30);
    self.carStyle.backgroundColor = [UIColor redColor];
    self.carStyle.textAlignment = NSTextAlignmentCenter;
    
    self.priceLable.frame = CGRectMake(self.carStyle.frame.origin.x + self.carStyle.frame.size.width + 20, 10,90, 30);
    self.priceLable.textAlignment = NSTextAlignmentCenter;
    self.priceLable.backgroundColor = [UIColor redColor];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
