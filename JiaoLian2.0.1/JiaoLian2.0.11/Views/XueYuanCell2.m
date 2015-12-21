//
//  XueYuanCell2.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/19.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "XueYuanCell2.h"

@implementation XueYuanCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _headVew.layer.cornerRadius=6;
    _headVew.layer.masksToBounds = YES;
}

@end
