//
//  NSObject+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/10/8.
//

#import <Foundation/Foundation.h>

@interface NSObject (DarkStar)
#pragma mark ----- block 操作 -------
/// 在主线程运行block
/// @param aInMainBlock 被运行的block
- (void)ds_performInMainThreadBlock:(void (^)(void))aInMainBlock;

/// 延时在主线程运行block
/// @param aInMainBlock 被运行的block
/// @param delay  延时时间
- (void)ds_performInMainThreadBlock:(void (^)(void))aInMainBlock
                     afterSecond:(NSTimeInterval)delay;

/// 在非主线程运行block
/// @param aInThreadBlock 被运行的block
- (void)ds_performInThreadBlock:(void (^)(void))aInThreadBlock;

/// 延时在非主线程运行block
/// @param aInThreadBlock 被运行的block
/// @param delay 延时时间
- (void)ds_performInThreadBlock:(void (^)(void))aInThreadBlock
                 afterSecond:(NSTimeInterval)delay;


#pragma mark ----- notification 操作 -------
/// 处理通知
/// @param notification notification description
- (void)ds_handleNotification:(NSNotification *)notification;

/// 注册通知
/// @param name 通知名称
- (void)ds_observeNotification:(NSString *)name;

/// 取消注册通知
/// @param name 通知名称
- (void)ds_unobserveNotification:(NSString *)name;

/// 取消注册的所有通知
- (void)ds_unobserveAllNotifications;

/// 发送通知
/// @param name 通知名称
- (void)ds_postNotification:(NSString *)name;

/// 发送通知并传递参数
/// @param name 通知名称
/// @param object 传递的参数
- (void)ds_postNotification:(NSString *)name withObject:(NSObject *)object;

/// 发送通知并传递参数
/// @param name  通知名称
/// @param object 传递的参数
/// @param info 传递的参数
- (void)ds_postNotification:(NSString *)name
                 withObject:(NSObject *)object
                   userInfo:(NSDictionary *)info;

@end
