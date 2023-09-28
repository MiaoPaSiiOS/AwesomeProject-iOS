//
//  Target_AmenFeed.m
//  AmenHome
//
//  Created by zhuyuhui on 2021/6/15.
//

#import "Target_AmenFeed.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "FeedappViewController.h"
@implementation Target_AmenFeed

- (void)Action_showFeedViewController:(nullable NSDictionary *)parameter;
{
    FeedappViewController *vc = [[FeedappViewController alloc] init];
    vc.parameter = parameter;
    [[DSCommonMethods findTopViewController].navigationController pushViewController:vc animated:YES];
}


@end
