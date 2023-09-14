//
//  RELoginUtil.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/4.
//

#import "RELoginUtil.h"
#import "RELoginViewController.h"
@implementation RELoginUtil

+ (void)loginFromVC:(UIViewController *)controller dealResult:(void (^)(BOOL isSuccess))handle {
    if ([[self ds_topViewController] isKindOfClass:RELoginViewController.class]) {
        NSLog(@"登录控制器已存在");
        return;
    }
    
    RELoginViewController *loginVC = [[RELoginViewController alloc] init];
    [loginVC setLoginBlock:^(BOOL success, NSError *error) {
        handle(success);
    }];
    REUINavigationController *naviVC = [[REUINavigationController alloc] initWithRootViewController:loginVC];
    naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:naviVC animated:YES completion:nil];
}
@end
