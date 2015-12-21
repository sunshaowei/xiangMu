//
//  PictureView.m
//  PersonalCenter
//
//  Created by 戴文博 on 15/11/21.
//  Copyright © 2015年 戴文博. All rights reserved.
//

#import "PictureView.h"
#import "Color.h"
@implementation PictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(80, 60, 30, 40)];
        [self.pic setImage:[UIImage imageNamed:@"upload_107.2px_1187547_easyicon.net@3x.png"]];
        [self addSubview:self.pic];


        self.picLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 150, 30)];
        _picLable.textAlignment = NSTextAlignmentCenter;
        _picLable.textColor = kUIColorFromRGB(0xdddddd);
        [self addSubview:self.picLable];
        
    }
    return self;
}

@end
