//
//  Target_DarkStarAwesomeKit.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "Target_DarkStarAwesomeKit.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSAwesomeKitViewController.h"

@implementation Target_DarkStarAwesomeKit

- (void)Action_pushAwesomeKitController:(nullable NSDictionary *)parameter {
    DSAwesomeKitViewController *webController = [[DSAwesomeKitViewController alloc] init];
    [[DSHelper findTopViewController].navigationController pushViewController:webController animated:YES];
}
@end
