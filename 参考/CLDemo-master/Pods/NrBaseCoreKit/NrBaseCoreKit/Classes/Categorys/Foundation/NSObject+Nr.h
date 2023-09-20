//
//  NSObject+Nr.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Nr)
/// 获取主窗体
+ (nullable UIWindow *)nr_window;
- (nullable UIViewController *)nr_topViewController;
- (nullable UIViewController *)nr_topViewController:(UIViewController *)rootViewController;

/// 将JSON 字符串转化成序列化对象
- (id)nr_JSONValue;

/// 将可 JSON 化对象转化成 JSON 字符串
- (NSString *)nr_JSONString;
@end

NS_ASSUME_NONNULL_END
