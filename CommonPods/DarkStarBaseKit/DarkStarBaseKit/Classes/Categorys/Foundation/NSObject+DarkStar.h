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




@end

NS_ASSUME_NONNULL_END
