//
//  DSNETShareUtil.m
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSNETShareUtil.h"
#import <RealReachability/RealReachability.h>
@interface DSNETShareUtil()
@property(nonatomic, assign) BOOL isNet;
@end

@implementation DSNETShareUtil
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSNETShareUtil *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [GLobalRealReachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
        ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
        if (status!=0) {
            self.isNet = YES;
        }
    }
    return self;
}

- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case RealStatusNotReachable:
            {
                self.isNet = NO;
                break;
            }
                
            case RealStatusViaWiFi:
            {
                self.isNet = YES;
                break;
            }
            case RealStatusViaWWAN:
            {
                self.isNet = YES;
                break;
            }
                
            default:{
                self.isNet = YES;
            }
                break;
        }
    }];
}

+ (BOOL)isConnectionAvailable {
    return [DSNETShareUtil sharedInstance].isNet;
}
@end
