//
//  CostCellTableViewCell.m
//  PersonalCenter
//
//  Created by 戴文博 on 15/11/20.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "CostCellTableViewCell.h"
#import "Color.h"
@interface CostCellTableViewCell ()

@end

@implementation CostCellTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cPic = [[UIImageView alloc] init];
        [self.contentView addSubview:self.cPic];
        
        self.priceLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLable];
        
        self.moneyField = [[UITextField alloc] init];
        [self.contentView addSubview:self.moneyField];
        
        
        self.chooseSwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:self.chooseSwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cPic.frame = CGRectMake(20, 20, 30, 30);
    self.priceLable.frame = CGRectMake(90, 20, 20, 30);
    self.priceLable.text = @"￥";
    self.moneyField.frame = CGRectMake(130, 20, 200, 30);
    self.moneyField.placeholder = @"请输入价格";
    self.chooseSwitch.frame = CGRectMake(self.frame.size.width - 60, 20, 40, 30);
//    [_chooseSwitch addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, 10)];
    view.backgroundColor = kUIColorFromRGB(0xF5F5F5);
    [self addSubview:view];
}

- (void)chooseAction:(id)sender
{
    [self.delegate changeCellAction:self];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
