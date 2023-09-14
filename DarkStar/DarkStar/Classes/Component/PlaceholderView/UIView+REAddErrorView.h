//
//  UIView+REAddErrorView.h
//  REWLY
//
//  Created by zhuyuhui on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "REErrorView.h"
NS_ASSUME_NONNULL_BEGIN

/**
 错误页的tag
 */
extern NSUInteger const HPErrorViewTag;

@interface UIView (REAddErrorView)
/**
 显示错误页
 */
- (void)showErrorViewWithType:(REErrorType)errorType;
- (void)showErrorViewWithType:(REErrorType)errorType insets:(UIEdgeInsets)insets;
- (void)showErrorViewWithType:(REErrorType)errorType target:(nullable id)target action:(nullable SEL)action;
- (void)showErrorViewWithType:(REErrorType)errorType insets:(UIEdgeInsets)insets target:(nullable id)target action:(nullable SEL)action;


/**
 移除错误页
 */
- (void)removeErrorView;
/**
 检测当前页面是否存在ErrorView
 
 @return ErrorView
 */
- (REErrorView *)checkErrorViewExist;
@end

NS_ASSUME_NONNULL_END
