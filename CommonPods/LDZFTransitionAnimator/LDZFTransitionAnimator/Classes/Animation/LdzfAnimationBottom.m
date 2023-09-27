
#import "LdzfAnimationBottom.h"

@implementation LdzfAnimationBottom

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentWidthRatio = 1;
        self.contentHeightRatio = 0.5;
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
    
    CGFloat screenH = CGRectGetHeight(containerView.bounds);
    CGFloat screenW = CGRectGetWidth(containerView.bounds);
    
    CGFloat w = screenW * self.contentWidthRatio;
    CGFloat h = screenH * self.contentHeightRatio;
    CGFloat x = (screenW - w) / 2;

    CGRect showFrame = CGRectMake(x, screenH - h, w, h);
    CGRect hiddenFrame = CGRectMake(x, screenH, w, h);
    
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
