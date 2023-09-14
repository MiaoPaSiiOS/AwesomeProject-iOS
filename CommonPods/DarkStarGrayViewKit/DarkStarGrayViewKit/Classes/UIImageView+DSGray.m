//
//  UIImageView+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UIImageView+DSGray.h"
#import "DSGrayUtil.h"

@implementation UIImageView (DSGray)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [UIImageView class];
        
        Method setImageMethod = class_getInstanceMethod(class, @selector(setImage:));
        Method setGrayImageMethod = class_getInstanceMethod(class, @selector(setGrayImage:));
        
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(setImage:) oriMethod:setImageMethod swizzledSel:@selector(setGrayImage:) swizzledMethod:setGrayImageMethod oriClass:class];
        
        Method setAnimationImagesMethod = class_getInstanceMethod(class, @selector(setAnimationImages:));
        Method setGrayAnimationImagesMethod = class_getInstanceMethod(class, @selector(setGrayAnimationImages:));
        
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(setAnimationImages:) oriMethod:setAnimationImagesMethod swizzledSel:@selector(setGrayAnimationImages:) swizzledMethod:setGrayAnimationImagesMethod oriClass:class];
    });
}

- (void)setGrayAnimationImages:(NSArray <UIImage *> *)array {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:array.count];
    if (array.count && [DSGrayManager shared].grayViewEnabled) {
        
        [array enumerateObjectsUsingBlock:^(UIImage *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [arr addObject:[DSGrayUtil grayImageForUIImage:obj]];
        }];
        [self setGrayAnimationImages:arr.copy];
    }else{
        [self setGrayAnimationImages:array];
    }
}

- (void)setGrayImage:(UIImage *)image {
    //系统键盘处理（如果不过滤，这系统键盘字母背景是黑色）|| UISearchBarSearchFieldBackgroundView过滤处理 否则iOS12会失真
    if ([self.superview isKindOfClass:NSClassFromString(@"UIKBSplitImageView")] || [self isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")] ) {
        [self setGrayImage:image];
        return;
    }
    if (image && [DSGrayManager shared].grayViewEnabled) {
        image = [DSGrayUtil grayImageForUIImage:image];
    }
    [self setGrayImage:image];
}


@end
