//
//  Target_AmenEnjoyCamera.m
//  AmenEnjoyCamera
//
//  Created by zhuyuhui on 2021/11/14.
//

#import "Target_AmenEnjoyCamera.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "QMBaseNavigationController.h"
#import "QMCameraViewController.h"
@implementation Target_AmenEnjoyCamera
- (void)Action_showQMCameraViewController:(nullable NSDictionary *)parameter {
    QMCameraViewController *vc = [[QMCameraViewController alloc] init];
    
    QMBaseNavigationController *nav = [[QMBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[DSHelper findTopViewController].navigationController presentViewController:nav animated:YES completion:nil];
}

@end
