//
//  NSObject+DarkStar.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/10/8.
//

#import "NSObject+DarkStar.h"

@implementation NSObject (DarkStar)
#pragma mark ----- block 操作 -------
- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        aInMainBlock();
    });
}

- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock
                     afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        aInMainBlock();
    });
}

- (void)performInThreadBlock:(void (^)(void))aInThreadBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        aInThreadBlock();
    });
}

- (void)performInThreadBlock:(void (^)(void))aInThreadBlock
                 afterSecond:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void) {
        aInThreadBlock();
    });
}

#pragma mark ----- notification 操作 -------
- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:name object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name
{
    [self postNotification:name withObject:nil userInfo:nil];
}

- (void)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [self postNotification:name withObject:object userInfo:nil];
}

- (void)postNotification:(NSString *)name
              withObject:(NSObject *)object
                userInfo:(NSDictionary *)info
{
    [self performInMainThreadBlock:^{
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
