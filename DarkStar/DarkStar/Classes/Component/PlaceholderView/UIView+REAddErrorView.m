//
//  UIView+REAddErrorView.m
//  REWLY
//
//  Created by zhuyuhui on 2023/6/1.
//

#import "UIView+REAddErrorView.h"
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

NSUInteger const HPErrorViewTag = 1024;

@implementation UIView (REAddErrorView)
/**
 显示错误页
 */
- (void)showErrorViewWithType:(REErrorType)errorType {
    [self showErrorViewWithType:errorType insets:UIEdgeInsetsZero];
}

- (void)showErrorViewWithType:(REErrorType)errorType insets:(UIEdgeInsets)insets {
    [self showErrorViewWithType:errorType insets:insets target:nil action:nil];
}

- (void)showErrorViewWithType:(REErrorType)errorType target:(nullable id)target action:(nullable SEL)action {
    [self showErrorViewWithType:errorType insets:UIEdgeInsetsZero target:target action:action];
}

- (void)showErrorViewWithType:(REErrorType)errorType insets:(UIEdgeInsets)insets target:(id)target action:(SEL)action {
    dispatch_main_async_safe(^{
        REErrorView *errorView = [self checkErrorViewExist];
        if (!errorView) {
            errorView = [[REErrorView alloc] init];
            errorView.tag = HPErrorViewTag;
            [self addSubview:errorView];
        }
        errorView.errorType = errorType;
        [errorView addTarget:target action:action];
        [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(insets);
        }];
        [self bringSubviewToFront:errorView];
    });
}

/**
 移除错误页
 */
- (void)removeErrorView {
    dispatch_main_async_safe(^{
        REErrorView *errorView = [self checkErrorViewExist];
        if (errorView) {
            [errorView removeFromSuperview];
        }
    });
}

/**
 检测当前页面是否存在ErrorView
 
 @return ErrorView
 */
- (REErrorView *)checkErrorViewExist {
    return [self viewWithTag:HPErrorViewTag];
}
@end
