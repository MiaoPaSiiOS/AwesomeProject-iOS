//
//  NSObject+DarkStar.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/10/8.
//

#import "NSObject+DarkStar.h"

@implementation NSObject (DarkStar)
#pragma mark ----- block 操作 -------
- (void)ds_performInMainThreadBlock:(void (^)(void))aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        aInMainBlock();
    });
}

- (void)ds_performInMainThreadBlock:(void (^)(void))aInMainBlock
                     afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        aInMainBlock();
    });
}

- (void)ds_performInThreadBlock:(void (^)(void))aInThreadBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        aInThreadBlock();
    });
}

- (void)ds_performInThreadBlock:(void (^)(void))aInThreadBlock
                 afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void) {
        aInThreadBlock();
    });
}

#pragma mark ----- notification 操作 -------
- (void)ds_handleNotification:(NSNotification *)notification
{
    
}

- (void)ds_observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ds_handleNotification:) name:name object:nil];
}

- (void)ds_unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)ds_unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ds_postNotification:(NSString *)name
{
    [self ds_postNotification:name withObject:nil userInfo:nil];
}

- (void)ds_postNotification:(NSString *)name withObject:(NSObject *)object
{
    [self ds_postNotification:name withObject:object userInfo:nil];
}

- (void)ds_postNotification:(NSString *)name
                 withObject:(NSObject *)object
                   userInfo:(NSDictionary *)info
{
    [self ds_performInMainThreadBlock:^{
        @try
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                                object:object
                                                              userInfo:info];
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
    }];
}


@end
