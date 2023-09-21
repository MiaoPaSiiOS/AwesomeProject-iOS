//
//  AMENWidgetkitCalendarMgr.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AMENWidgetkitCalendarMgr.h"

@implementation AMENWidgetkitCalendarMgr

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AMENWidgetkitCalendarMgr *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

@end
