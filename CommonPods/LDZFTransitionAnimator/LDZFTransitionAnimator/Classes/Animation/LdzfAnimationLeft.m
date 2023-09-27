
#import "LdzfAnimationLeft.h"

@implementation LdzfAnimationLeft

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
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BOOL isPresenting = (fromController == self.presentingViewController);
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    CGFloat screenWidth = CGRectGetWidth(containerView.bounds);
    CGFloat screenHeight = CGRectGetHeight(containerView.bounds);
    CGFloat w = screenWidth * self.contentWidthRatio;
    CGFloat h = screenHeight * self.contentHeightRatio;
    CGFloat y = (screenHeight - h) / 2;

    CGRect showFrame = CGRectMake(0, y, w, h);
    CGRect hiddenFrame = CGRectMake(-w, y, w, h);

    if (isPresenting) toView.frame = hiddenFrame;
    
    [UIView animateWithDuration:self.transitionDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:self.velocity options:self.options animations:^{
        if (isPresenting) {
            toView.frame = showFrame;
        } else {
            fromView.frame = hiddenFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}


@end
