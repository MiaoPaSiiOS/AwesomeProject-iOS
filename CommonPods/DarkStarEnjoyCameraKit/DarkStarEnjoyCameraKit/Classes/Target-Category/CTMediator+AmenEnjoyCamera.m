//
//  CTMediator+AmenEnjoyCamera.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/11/14.
//

#import "CTMediator+AmenEnjoyCamera.h"

@implementation CTMediator (AmenEnjoyCamera)
- (void)mediator_showQMCameraViewController:(nullable NSDictionary *)params {
    [self performTarget:@"AmenEnjoyCamera"
                 action:@"showQMCameraViewController"
                 params:params shouldCacheTarget:NO];
}

@end
