//
//  DSDataView.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "DSDataView.h"

@implementation DSDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _userinfo = nil;
        _inset = UIEdgeInsetsZero;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


@end
