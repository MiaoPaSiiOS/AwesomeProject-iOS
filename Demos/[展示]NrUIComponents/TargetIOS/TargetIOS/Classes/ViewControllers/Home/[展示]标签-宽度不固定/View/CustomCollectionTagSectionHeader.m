//
//  CustomCollectionTagSectionHeader.m
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/6/16.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import "CustomCollectionTagSectionHeader.h"

@implementation CustomCollectionTagSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupStyleWithTitle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.botlabel.frame = self.bounds;
}

- (void)setupStyleWithTitle {
    [self addSubview:self.botlabel];
}

- (UILabel *)botlabel {
    if (_botlabel == nil) {
        _botlabel = [[UILabel alloc] init];
        _botlabel.textColor = [UIColor blackColor];
        _botlabel.font =  [UIFont boldSystemFontOfSize:15];
    }
    return _botlabel;
}
@end
