//
//  AMENStartAdMgr.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AMENStartAdMgr.h"

@implementation AMENStartAdMgr

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AMENStartAdMgr *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)sendRequestOfStartAd {
    
}

@end
