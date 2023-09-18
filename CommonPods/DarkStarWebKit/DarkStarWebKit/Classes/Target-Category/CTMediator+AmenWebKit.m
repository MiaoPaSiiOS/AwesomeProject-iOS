//
//  CTMediator+AmenWebKit.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "CTMediator+AmenWebKit.h"

@implementation CTMediator (AmenWebKit)
- (void)mediator_pushWebViewController:(NSDictionary *)params {
    [self performTarget:@"AmenWebKit" action:@"pushWebViewController" params:params shouldCacheTarget:NO];
}
- (void)mediator_pushWebViewDemoController:(nullable NSDictionary *)params {
    [self performTarget:@"AmenWebKit" action:@"pushWebViewDemoController" params:params shouldCacheTarget:NO];
}
@end
