//
//  SDMajletUtil.m
//  DarkStarAwesomeKit
//
//  Created by zhuyuhui on 2023/10/7.
//

#import "SDMajletUtil.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <MJExtension/MJExtension.h>
static NSString *kBCMMyApplicationKey = @"PNCMyApplicationKey";

@implementation SDMajletUtil

+ (void)saveMyApplicationInfo:(NSDictionary *)infoDict {
    NSString *InfoJson = [DSHelper JSON_STRING_FROM_OBJ:infoDict];
    [[NSUserDefaults standardUserDefaults] setObject:InfoJson forKey:kBCMMyApplicationKey]; //保存用户信息至UserDefault
}

/// 清空常用应用信息
+ (void)clearMyApplicationInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBCMMyApplicationKey];
}

+ (NSDictionary *)loadApplicationInfoCache {
    NSString *useNameInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBCMMyApplicationKey];
    NSDictionary *InfoDict = [DSHelper JSON_OBJ_FROM_STRING:useNameInfo];
    return InfoDict;
}

+ (SDMajletModel *)createMyApplyModel {
    NSDictionary *cacheInfo = [self loadApplicationInfoCache];
    //有缓存，直接去缓存数据
    if (![DSHelper isDictEmptyOrNil:(cacheInfo)]) {
        SDMajletModel *myApply = [SDMajletModel mj_objectWithKeyValues:cacheInfo];
        return myApply;
    } else {
        SDMajletModel *myApply = [SDMajletModel mj_objectWithKeyValues:@{
            @"code": @"-10000",
            @"child": @[],
        }];
        return myApply;
    }
}

/// 是否存在本地应用
+ (BOOL)hasMyApplicationInfo {
    SDMajletModel *myApply = [self createMyApplyModel];
    if (![DSHelper isArrayEmptyOrNil:(myApply.child)]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)fetchApplicationListHandler:(void (^)(NSArray<SDMajletModel *> *))completionHandler {
    NSMutableArray *LIST = @[].mutableCopy;
    for (int i = 0; i < 10; i++) {
        SDMajletModel *group = [SDMajletModel mj_objectWithKeyValues:@{}];
        group.code = [NSString stringWithFormat:@"group-%d",i];
        group.name = [NSString stringWithFormat:@"组-%d",i];
        group.child = @[].mutableCopy;
        NSInteger randomValue = [DSHelper getRandomNumber:3 max:15];
        for (NSInteger i = 0; i < randomValue; i++) {
            SDMajletModel *item = [SDMajletModel mj_objectWithKeyValues:@{}];
            item.code = [NSString stringWithFormat:@"item-%ld",(long)i];
            item.name = [NSString stringWithFormat:@"子选项-%ld",(long)i];
            [group.child addObject:item];
        }
        [LIST addObject:group];
    }
    if (completionHandler) {
        completionHandler(LIST);
    }
}


@end
