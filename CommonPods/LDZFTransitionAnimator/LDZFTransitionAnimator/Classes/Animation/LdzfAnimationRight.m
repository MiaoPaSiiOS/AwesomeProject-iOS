#import "LdzfAnimationRight.h"

@implementation LdzfAnimationRight
- (instancetype)init
{
    self = [super init];
    if (self) {        
        self.contentWidthRatio = 0.8;
        self.contentHeightRatio = 1;
    }
    return self;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BOOL isPresenting = (fromVC == self.presentingViewController);
    
    UIView *fromV = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toV = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toV];
    
    CGFloat screenWidth = CGRectGetWidth(containerView.bounds);
    CGFloat screenHeight = CGRectGetHeight(containerView.bounds);
    CGFloat w = screenWidth * self.contentWidthRatio;
    CGFloat h = screenHeight * self.contentHeightRatio;
    CGFloat y = (screenHeight - h) / 2;

    CGRect showFrame = CGRectMake(screenWidth - w, y, w, h);
    CGRect hiddenFrame = CGRectMake(screenWidth, y, w, h);
    
    if (isPresenting) toV.frame = hiddenFrame;
    
    [UIView animateWithDuration:self.transitionDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:self.velocity options:self.options animations:^{
        if (isPresenting) {
            toV.frame = showFrame;
        } else {
            fromV.frame = hiddenFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}


@end
