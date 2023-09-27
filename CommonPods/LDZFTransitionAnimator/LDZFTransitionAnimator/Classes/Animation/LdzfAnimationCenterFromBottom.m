
#import "LdzfAnimationCenterFromBottom.h"

@implementation LdzfAnimationCenterFromBottom
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentWidthRatio = 0.8;
        self.contentHeightRatio = 0.6;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 1.获取源控制器、目标控制器、动画容器View
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 2. 获取源控制器、目标控制器 的View，但是注意二者在开始动画，消失动画，身份是不一样的：
    // 也可以直接通过上面获取控制器获取，比如：toViewController.view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView addSubview:toView];  //必须添加到动画容器View上。
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGFloat screenW = CGRectGetWidth(containerView.bounds);
    CGFloat screenH = CGRectGetHeight(containerView.bounds);
    
    CGFloat w = screenW * self.contentWidthRatio;
    CGFloat h = screenH * self.contentHeightRatio;
    CGFloat x = (screenW - w) / 2;
    CGFloat y = (screenH - h) / 2;
    
    // 屏幕顶部
    CGRect beginFrame = CGRectMake(x, screenH, w, h);
    // 屏幕中间：
    CGRect showFrame = CGRectMake(x, y, w, h);
    // 屏幕底部
    CGRect endFrame = CGRectMake(x, -1 * screenH, w, h);
    
    if (isPresenting) toView.frame = beginFrame;
        
    [UIView animateWithDuration:self.transitionDuration delay:self.delay usingSpringWithDamping:self.dampingRatio initialSpringVelocity:self.velocity options:self.options animations:^{
        if (isPresenting)
            toView.frame = showFrame;
        else
            fromView.frame = endFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}
@end
