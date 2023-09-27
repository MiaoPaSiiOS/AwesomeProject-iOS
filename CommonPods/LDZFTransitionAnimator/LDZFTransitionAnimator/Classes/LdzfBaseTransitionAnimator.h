//
//  LdzfBaseTransitionAnimator.h
//  CRJLdzfBaseTransitionAnimator
//
//  Created by zhuyuhui on 2020/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LdzfBaseTransitionAnimator;

@protocol LdzfBaseTransitionAnimatorDelegate <NSObject>

@optional

- (void)transitionAnimationEnded:(LdzfBaseTransitionAnimator *)animator;

@end

@interface LdzfBaseTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  LdzfBaseTransitionAnimator's delegate.
 */
@property (nonatomic, weak) id <LdzfBaseTransitionAnimatorDelegate>  delegate;

/**
 *  Transition's duration, default value is 0.5f.
 */
@property (nonatomic) NSTimeInterval  transitionDuration;
// delay： 决定了动画在延迟多久之后执行, default value is 0.0f.
@property (nonatomic) NSTimeInterval  delay;
// damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强, default value is 0.9f.
@property (nonatomic) CGFloat  dampingRatio;
// velocity：初始化速度，值越高则物品的速度越快, default value is 0.3f.
@property (nonatomic) CGFloat  velocity;
// 常规动画属性设置, default value is UIViewAnimationOptionCurveEaseInOut
@property (nonatomic) UIViewAnimationOptions  options;

// 宽度占屏宽比例。取值范围0 ~ 1，default value is 0.5f.
@property (nonatomic) CGFloat  contentWidthRatio;
// 高度占屏高比例。取值范围0 ~ 1，default value is 0.5f.
@property (nonatomic) CGFloat  contentHeightRatio;


@property (nonatomic, strong) UIViewController * presentingViewController;
@end

