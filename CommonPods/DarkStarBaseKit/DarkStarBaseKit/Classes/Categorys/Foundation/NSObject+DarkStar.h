//
//  NSObject+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DarkStar)

#pragma mark - UIWindow | UIViewController
/// 获取主窗体
+ (nullable UIWindow *)ds_window;
- (nullable UIViewController *)ds_topViewController;
- (nullable UIViewController *)ds_topViewController:(UIViewController *)rootViewController;


#pragma mark - JSONValue | JSONString

/// 将JSON 字符串转化成序列化对象
- (id)ds_JSONValue;

/// 将可 JSON 化对象转化成 JSON 字符串
- (NSString *)ds_JSONString;



#pragma mark - NSBundle
/// 获取Pod库中的指定NSBundle（Pod库中可能存在多个.bundle文件）
/// @param bundleName bundle名
/// @param podName pod名
+ (nullable NSBundle *)ds_bundleName:(nullable NSString *)bundleName inPod:(nullable NSString *)podName;


/// 获取指定bundle中的图片
/// @param name 图片名
/// @param bundle bundle
+ (nullable UIImage *)ds_imageNamed:(nullable NSString *)name inBundle:(nullable NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
