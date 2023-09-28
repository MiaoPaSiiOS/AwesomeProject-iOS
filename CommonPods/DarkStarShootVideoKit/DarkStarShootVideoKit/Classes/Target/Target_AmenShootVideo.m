//
//  Target_AmenShootVideo.m
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import "Target_AmenShootVideo.h"
#import "AmenShootVideoScreen.h"
#import "GKDYHeader.h"
@implementation Target_AmenShootVideo
- (void)Action_ShowShootVideoViewController:(nullable NSDictionary *)parameter {
    AmenShootVideoScreen *vc = [[AmenShootVideoScreen alloc] init];
    vc.title = @"ShootVideo";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[DSHelper findTopViewController].navigationController presentViewController:nav animated:YES completion:nil];
}

@end
