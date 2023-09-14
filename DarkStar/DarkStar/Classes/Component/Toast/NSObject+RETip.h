//
//  NSObject+RETip.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RETip)

- (void)re_showMSG:(nullable NSString *)message;

- (void)re_showSuccess:(nullable NSString *)message;
- (void)re_showSuccess:(nullable NSString *)message toView:(nullable UIView *)view;

- (void)re_showError:(nullable NSString *)message;
- (void)re_showError:(nullable NSString *)message toView:(nullable UIView *)view;

- (MBProgressHUD *)re_showHUDMessage:(nullable NSString *)message;
- (MBProgressHUD *)re_showHUDMessage:(nullable NSString *)message toView:(nullable UIView *)view;

- (void)re_hideHUDForView:(nullable UIView *)view;
- (void)re_hideHUD;

@end

NS_ASSUME_NONNULL_END
