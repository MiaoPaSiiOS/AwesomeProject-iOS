//
//  UILabel+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UILabel+DSGray.h"
#import "DSGrayUtil.h"

@implementation UILabel (DSGray)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [UILabel class];
        
        Method setTextColorMethod = class_getInstanceMethod(class, @selector(setTextColor:));
        Method setGrayTextColorMethod = class_getInstanceMethod(class, @selector(setGrayTextColor:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(setTextColor:) oriMethod:setTextColorMethod swizzledSel:@selector(setGrayTextColor:) swizzledMethod:setGrayTextColorMethod oriClass:class];
    });
}

- (void)setGrayTextColor:(UIColor *)color {
    if (color && [DSGrayManager shared].grayViewEnabled) {
        [self setGrayTextColor:[DSGrayUtil grayColorForUIColor:color]];
    } else {
        [self setGrayTextColor:color];
    }
}

@end
