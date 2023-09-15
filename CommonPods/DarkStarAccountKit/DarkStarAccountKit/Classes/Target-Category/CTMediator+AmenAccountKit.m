//
//  CTMediator+AmenAccountKit.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "CTMediator+AmenAccountKit.h"
//  字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_TargetName = @"AmenAccountKit";


@implementation CTMediator (AmenAccountKit)
- (void)mediator_TouchIDApp:(nullable NSMutableDictionary *)params
                 completion:(IUVoidBlock_id)completion;
{
    [params setValue:completion forKey:@"callback"];
    [self performTarget:kCTMediatorTarget_TargetName
                 action:@"TouchIDApp"
                 params:params shouldCacheTarget:NO];
}

- (void)mediator_VocalApp:(nullable NSMutableDictionary *)params
               completion:(IUVoidBlock_id)completion;
{
    [params setValue:completion forKey:@"callback"];
    [self performTarget:kCTMediatorTarget_TargetName
                 action:@"VocalApp"
                 params:params shouldCacheTarget:NO];
}

- (void)mediator_AppleIDApp:(nullable NSMutableDictionary *)params
               completion:(IUVoidBlock_id)completion;
{
    [params setValue:completion forKey:@"callback"];
    [self performTarget:kCTMediatorTarget_TargetName
                 action:@"AppleIDApp"
                 params:params shouldCacheTarget:NO];
}

@end
