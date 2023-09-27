//
//  UIViewController+LdzfPresentAnimator.h
//  CRJLdzfBaseTransitionAnimator
//
//  Created by zhuyuhui on 2020/12/12.
//

#import <UIKit/UIKit.h>
#import "LdzfBaseTransitionAnimator.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LdzfPresentAnimator)
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                    animation:(LdzfBaseTransitionAnimator *)animation
                   completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
