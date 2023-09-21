//
//  AMENSystemAdaptMgr.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AMENSystemAdaptMgr.h"
#import <UIKit/UIKit.h>
@implementation AMENSystemAdaptMgr

+ (void)setup {
    [self iOS11Adjuest];
}

#pragma mark - iOS11 适配
+ (void)iOS11Adjuest {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0) {
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    }
}

@end
