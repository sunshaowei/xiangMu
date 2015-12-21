//
//  MyCommentCell.m
//  JiaoLian2.0
//
//  Created by 孙少伟 on 15/11/17.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "MyCommentCell.h"

@implementation MyCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _headView.layer.cornerRadius=6;
    _headView.layer.masksToBounds = YES;}

@end
