//
//  UIView+DSErrorView.h
//  REWLY
//
//  Created by zhuyuhui on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "DSErrorView.h"
NS_ASSUME_NONNULL_BEGIN

/**
 错误页的tag
 */
extern NSUInteger const HPErrorViewTag;

@interface UIView (DSErrorView)
/**
 显示错误页
 */
- (void)showErrorViewWithType:(DSErrorType)errorType;
- (void)showErrorViewWithType:(DSErrorType)errorType insets:(UIEdgeInsets)insets;
- (void)showErrorViewWithType:(DSErrorType)errorType target:(nullable id)target action:(nullable SEL)action;
- (void)showErrorViewWithType:(DSErrorType)errorType insets:(UIEdgeInsets)insets target:(nullable id)target action:(nullable SEL)action;


/**
 移除错误页
 */
- (void)removeErrorView;
/**
 检测当前页面是否存在ErrorView
 
 @return ErrorView
 */
- (DSErrorView *)checkErrorViewExist;
@end

NS_ASSUME_NONNULL_END
