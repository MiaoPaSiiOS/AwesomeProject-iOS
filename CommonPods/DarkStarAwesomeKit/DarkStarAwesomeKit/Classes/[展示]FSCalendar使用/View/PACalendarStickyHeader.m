//
//  PACalendarStickyHeader.m
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import "PACalendarStickyHeader.h"

@implementation PACalendarStickyHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self addSubview:label];
        self.titleLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end
