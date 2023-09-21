//
//  AMENCheckVersionMgr.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AMENCheckVersionMgr.h"

@interface AMENCheckVersionMgr ()
@property(nonatomic, assign) BOOL checkVersionFlag;
@end

@implementation AMENCheckVersionMgr

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AMENCheckVersionMgr *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.checkVersionFlag = NO;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}




@end
