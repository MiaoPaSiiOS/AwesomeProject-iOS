//
//  CTMediator+DarkStarAwesomeKit.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "CTMediator+DarkStarAwesomeKit.h"

@implementation CTMediator (DarkStarAwesomeKit)
- (void)mediator_pushAwesomeKitController:(nullable NSDictionary *)params {
    [self performTarget:@"DarkStarAwesomeKit" action:@"pushAwesomeKitController" params:params shouldCacheTarget:NO];
}
@end
