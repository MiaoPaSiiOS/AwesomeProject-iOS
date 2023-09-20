//
//  NrNavItem.m
//  TmallUIKit
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "NrNavItem.h"

@implementation NrNavItem
- (instancetype)init {
    if (self = [super init]) {
        _title = nil;
        _img = nil;
        _titleColor = [UIColor whiteColor];
        _titleFont = [UIFont systemFontOfSize:20];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)nTitle img:(UIImage *)nImg {
    if (self = [self init]) {
        _title = nTitle;
        _img = nImg;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)nTitle {
    if (self = [self init]) {
        _title = nTitle;
    }
    return self;
}

- (instancetype)initWithImg:(UIImage *)nImg {
    if (self = [self init]) {
        _img = nImg;
    }
    return self;
}


@end
