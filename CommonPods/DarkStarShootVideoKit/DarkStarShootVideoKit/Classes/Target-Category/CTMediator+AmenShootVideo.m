//
//  CTMediator+AmenShootVideo.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/6/22.
//

#import "CTMediator+AmenShootVideo.h"

@implementation CTMediator (AmenShootVideo)
- (void)mediator_ShowShootVideoViewController:(nullable NSDictionary *)params {
     [self performTarget:@"AmenShootVideo" action:@"ShowShootVideoViewController" params:params shouldCacheTarget:NO];
}

@end
