//
//  NSObject+RETip.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/10.
//

#import "NSObject+RETip.h"

@implementation NSObject (RETip)

- (void)re_showMSG:(NSString *)message
{
    [self re_showMSG:message view:nil];
}


- (void)re_showError:(NSString *)message
{
    [self re_showError:message toView:nil];
}

- (void)re_showError:(NSString *)message toView:(UIView *)view
{
    [self re_show:message icon:[UIImage imageNamed:@"progresshud-error"] view:view];
}

- (void)re_showSuccess:(NSString *)message
{
    [self re_showSuccess:message toView:nil];
}

- (void)re_showSuccess:(NSString *)message toView:(UIView *)view
{
    [self re_show:message icon:[UIImage imageNamed:@"progresshud-success"] view:view];
}


- (MBProgressHUD *)re_showHUDMessage:(NSString *)message
{
    return [self re_showHUDMessage:message toView:nil];
}

- (MBProgressHUD *)re_showHUDMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    hud.backgroundView.color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.6];

    return hud;
}

- (void)re_hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)re_hideHUD
{
    [self re_hideHUDForView:nil];
}

#pragma mark Private
- (void)re_show:(NSString *)text icon:(UIImage *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.3];
}

- (void)re_showMSG:(NSString *)text view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:icon];
//    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.3];
}

@end
