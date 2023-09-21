//
//  QMHUDProgress.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/9/19.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMProgressHUD.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import "Constants.h"

static DGActivityIndicatorView  *activityIndicatorView;

@implementation QMProgressHUD

+ (void)show
{
    if (activityIndicatorView.animating) {
        return;
    }
    void (^block)(void) = ^{
        if (!activityIndicatorView) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor colorWithRed:8/255.0 green:157/255.0 blue:184/255.0 alpha:1.0] size:40.0f];
            activityIndicatorView.frame = [UIScreen mainScreen].bounds;
            [window addSubview:activityIndicatorView];
        }
        [activityIndicatorView startAnimating];
    };
    if([NSThread isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)hide
{
    void (^block)(void) = ^{
        [activityIndicatorView stopAnimating];
    };
    if([NSThread isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
