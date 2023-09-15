//
//  CTMediator+AmenFeed.m
//  AmenFeed-Category
//
//  Created by zhuyuhui on 2021/6/18.
//

#import "CTMediator+AmenFeed.h"

@implementation CTMediator (AmenFeed)
- (void)mediator_showFeedViewController:(nullable NSMutableDictionary *)params {
    [self performTarget:@"AmenFeed" action:@"showFeedViewController" params:params shouldCacheTarget:NO];
}


@end
