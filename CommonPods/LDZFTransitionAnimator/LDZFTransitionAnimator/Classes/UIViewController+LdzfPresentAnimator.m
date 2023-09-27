//
//  UIViewController+LdzfPresentAnimator.m
//  CRJLdzfBaseTransitionAnimator
//
//  Created by zhuyuhui on 2020/12/12.
//

#import "UIViewController+LdzfPresentAnimator.h"
#import "LdzfCustomPresentationController.h"

@implementation UIViewController (LdzfPresentAnimator)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animation:(LdzfBaseTransitionAnimator *)animation completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        LdzfCustomPresentationController *presentingVC = [[LdzfCustomPresentationController alloc] initWithPresentedViewController:viewControllerToPresent presentingViewController:self];
        presentingVC.animation = animation;
        viewControllerToPresent.transitioningDelegate = presentingVC;
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    });
}

@end
