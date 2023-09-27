//
//  LdzfBaseTransitionAnimator.m
//  CRJLdzfBaseTransitionAnimator
//
//  Created by zhuyuhui on 2020/12/12.
//

#import "LdzfBaseTransitionAnimator.h"

@interface LdzfBaseTransitionAnimator ()

@end

@implementation LdzfBaseTransitionAnimator

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.transitionDuration = 0.5f;
        self.delay = 0.0f;
        self.dampingRatio = 0.9f;
        self.velocity = 0.3f;
        self.options = UIViewAnimationOptionCurveEaseInOut;
        
        self.contentWidthRatio = 0.5;
        self.contentHeightRatio = 0.5;
    }
    
    return self;
}

- (void)transitionAnimation {

    [NSException raise:@"LdzfBaseTransitionAnimator Error."
                format:@"You should overwrite this method in subclass."];
}

#pragma mark - Protocol UIViewControllerAnimatedTransitioning.

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {

    return self.transitionDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)animationEnded:(BOOL) transitionCompleted {
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionAnimationEnded:)]) {
        [self.delegate transitionAnimationEnded:self];
    }
}
@end
