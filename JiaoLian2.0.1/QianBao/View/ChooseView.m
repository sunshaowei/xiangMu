//
//  ChooseView.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/19.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20*OffWidth, 20*OffHeight, 30*OffWidth, 30*OffHeight)];
        pic.image = [UIImage imageNamed:@"iconfont-guanbi@3x.png"];
        [self addSubview:pic];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        pic.userInteractionEnabled = YES;
        [pic addGestureRecognizer:tap];
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(150*OffWidth, 20*OffHeight, 200*OffWidth, 30*OffHeight)];
        lable.text = @"选择银行卡";
        lable.font = [UIFont systemFontOfSize:22.5];
        [self addSubview:lable];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.delegate pushBack:tap];
}
@end
