//
//  AddView.m
//  Students_Wallets
//
//  Created by 戴文博 on 15/11/19.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20*OffWidth, 15*OffHeight, 30*OffWidth, 30*OffHeight)];
        pic.image = [UIImage imageNamed:@"iconfont-jia@3x.png"];
        [self addSubview:pic];
                
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80*OffWidth, 15*OffHeight, 200*OffWidth, 30*OffHeight)];
        lable.text = @"添加银行卡";
        lable.font = [UIFont systemFontOfSize:25];
        [self addSubview:lable];
        
        UIImageView *newPic = [[UIImageView alloc] initWithFrame:CGRectMake(370*OffWidth, 20*OffHeight, 10*OffWidth, 15*OffHeight)];
        newPic.image = [UIImage imageNamed:@"iconfont-youjiantou-副本-2@3x.png"];
        [self addSubview:newPic];
    }
    return self;
}


@end
