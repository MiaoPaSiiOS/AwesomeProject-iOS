//
//  NSObject+RE.h
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 RE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (RE)

- (NSArray *)toArray;
- (NSString *)toString;
- (NSNumber *)toNumberIfNeeded;


#pragma mark ----- block 操作 -------
// try catch
- (NSException *)tryCatch:(void (^)(void))block;
- (NSException *)tryCatch:(void (^)(void))block finally:(void (^)(void))aFinisheBlock;

/**
 *  在主线程运行block
 *
 *  @param aInMainBlock 被运行的block
 */
- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock;
/**
 *  延时在主线程运行block
 *
 *  @param aInMainBlock 被运行的block
 *  @param delay        延时时间
 */
- (void)performInMainThreadBlock:(void (^)(void))aInMainBlock
                     afterSecond:(NSTimeInterval)delay;
/**
 *  在非主线程运行block
 *
 *  @param aInThreadBlock 被运行的block
 */
- (void)performInThreadBlock:(void (^)(void))aInThreadBlock;
/**
 *  延时在非主线程运行block
 *
 *  @param aInThreadBlock 被运行的block
 *  @param delay          延时时间
 */
- (void)performInThreadBlock:(void (^)(void))aInThreadBlock
                 afterSecond:(NSTimeInterval)delay;

#pragma mark ----- notification 操作 -------
/**
 *  处理处理通知
 */
- (void)handleNotification:(NSNotification *)notification;
/**
 *  注册通知
 *
 *  @param name 通知名称
 */
- (void)observeNotification:(NSString *)name;
/**
 *  取消注册通知
 *
 *  @param name 通知名称
 */
- (void)unobserveNotification:(NSString *)name;
/**
 *  取消注册的所有通知
 */
- (void)unobserveAllNotifications;
/**
 *  发送通知
 *
 *  @param name 通知名称
 */
- (void)postNotification:(NSString *)name;
/**
 *  发送通知并传递参数
 *
 *  @param name   通知名称
 *  @param object 传递的参数
 */
- (void)postNotification:(NSString *)name withObject:(NSObject *)object;
/**
 *  发送通知并传递参数
 *
 *  @param name   通知名称
 *  @param object 传递的参数
 *  @param info 传递的参数
 */
- (void)postNotification:(NSString *)name
              withObject:(NSObject *)object
                userInfo:(NSDictionary *)info;


#pragma mark ----- runtime  操作 -------
@property(nonatomic, strong, readonly) NSMutableArray *associatedObjectNames;

/**
 *  为当前object动态增加分类
 *
 *  @param propertyName   分类名称
 *  @param value  分类值
 *  @param policy 分类内存管理类型
 */
- (void)objc_setAssociatedObject:(NSString *)propertyName
                           value:(id)value
                          policy:(objc_AssociationPolicy)policy;
/**
 *  获取当前object某个动态增加的分类
 *
 *  @param propertyName 分类名称
 *
 *  @return 值
 */
- (id)objc_getAssociatedObject:(NSString *)propertyName;
/**
 *  删除动态增加的所有分类
 */
- (void)objc_removeAssociatedObjects;

#pragma mark ----- 生成二维码 -------
/**
 *  生成二维码
 *
 *  param   string      将要转成二维码的字段
 *  param   scale       二维码清晰度
 */
+ (UIImage *)barImageWithString:(NSString*)string
                          scale:(CGFloat)scale;

+ (CAShapeLayer *)configRoundedRect:(CGRect)rect
                  byRoundingCorners:(UIRectCorner)corners
                        cornerRadii:(CGSize)cornerRadii;

+ (dispatch_source_t)queryGCDWithTimeout:(NSInteger)Timeout
              handleChangeCountdownBlock:(void(^)(NSInteger timeout))handleChangeCountdownBlock
                handleStopCountdownBlock:(void(^)(void))handleStopCountdownBlock;

@end
