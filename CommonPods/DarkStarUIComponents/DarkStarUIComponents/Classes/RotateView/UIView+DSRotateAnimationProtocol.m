//
//  UIView+DSRotateAnimationProtocol.m
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import "UIView+DSRotateAnimationProtocol.h"
#import <objc/runtime.h>

@implementation UIView (DSRotateAnimationProtocol)
/**
 *  rotateDuration
 */
NSString * const _recognizerRotateDuration = @"_recognizerRotateDuration";
- (void)setTmRotateDuration:(CGFloat)tmRotateDuration {
    NSNumber *value = @(tmRotateDuration);
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerRotateDuration),
                             value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)tmRotateDuration {
    NSNumber *value = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerRotateDuration));
    return [value floatValue];
}

/**
 *  defaultTransform
 */
NSString * const _recognizerDefaultTransform = @"_recognizerDefaultTransform";
- (void)setTmDefaultTransform:(CGAffineTransform)tmDefaultTransform{
    NSValue *value = [NSValue valueWithCGAffineTransform:tmDefaultTransform];
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerDefaultTransform),
                             value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGAffineTransform)tmDefaultTransform {
    NSValue *value = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerDefaultTransform));
    return [value CGAffineTransformValue];
}
@end
