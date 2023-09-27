
#import "LdzfAnimationCenterFromTop.h"

@implementation LdzfAnimationCenterFromTop
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
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
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
    CGRect beginFrame = CGRectMake(x, -1 * screenH, w, h);
    // 屏幕中间：
    CGRect showFrame = CGRectMake(x, y, w, h);
    // 屏幕底部
    CGRect endFrame = CGRectMake(x, screenH, w, h);
    
    if (isPresenting) toView.frame = beginFrame;
        
    // duration： 动画时长
    // delay： 决定了动画在延迟多久之后执行
    // damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强
    // velocity：初始化速度，值越高则物品的速度越快
    // UIViewAnimationOptionCurveEaseInOut 加速，后减速
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
