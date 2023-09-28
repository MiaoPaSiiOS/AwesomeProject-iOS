//
//  DSCommonMethods.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 常用Block定义
typedef void (^IUVoidBlock)(void);
typedef BOOL (^IUBoolBlock)(void);
typedef int  (^IUIntBlock) (void);
typedef id   (^IUIDBlock)  (void);

typedef void (^IUVoidBlock_int)(int);
typedef BOOL (^IUBoolBlock_int)(int);
typedef int  (^IUIntBlock_int) (int);
typedef id   (^IUIDBlock_int)  (int);

typedef void (^IUVoidBlock_string)(NSString *);
typedef BOOL (^IUBoolBlock_string)(NSString *);
typedef int  (^IUIntBlock_string) (NSString *);
typedef id   (^IUIDBlock_string)  (NSString *);

typedef void (^IUVoidBlock_id)(id);
typedef BOOL (^IUBoolBlock_id)(id);
typedef int  (^IUIntBlock_id) (id);
typedef id   (^IUIDBlock_id)  (id);


@interface DSCommonMethods : NSObject
#pragma mark - 颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
+ (UIColor *)colorWithColorString:(NSString *)colorString;
+ (UIColor *)randomColor;

#pragma mark - UIWindow | UIViewController
+ (nullable UIWindow *)findWindow;
+ (nullable UIViewController *)findTopViewController;
+ (nullable UIViewController *)findTopViewController:(UIViewController *)rootViewController;
+ (nullable UIViewController *)findCurrentViewControllerAtView:(UIView *)view;


#pragma mark - NSString
/**
 判断对象是否存在, 是否为 NSString 类型

 @param obj 要判断的对象
 @return 对象为 NSString 类型: YES, 对象不存在或不是 NSString 类型: NO
 */
+(BOOL)isString:(id)obj;

/**
 判断对象是否存在, 是否为 NSString 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isStringEmptyOrNil:(id)obj;

/**
 直接取值

 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: 空字符串, 其他情况: 原值
 */
+(NSString* )safeString:(id)obj;
#pragma mark - NSArray

/**
 判断对象是否存在, 是否为 NSArray 类型

 @param obj 要判断的对象
 @return 对象存在为 NSArray 类型: YES, 对象不存在或不是 NSArray 类型: NO
 */
+(BOOL)isArray:(id)obj;

/**
 判断对象是否存在, 是否为 NSArray 类型, 是否有数据 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSArray 类型 或数组为空 或为nil: YES, 其他情况: NO
 */
+(BOOL)isArrayEmptyOrNil:(id)obj;

#pragma mark - NSDictionary


/**
 判断对象是否存在, 是否为 NSDictionary 类型

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型: YES, 对象不存在或不是 NSDictionary 类型: NO
 */
+(BOOL)isDictionary:(id)obj;

/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型且字典不为空: 原对象字典, 其他情况: 空字典
 */
+(NSDictionary *)isEmptyDict:(id)obj;


/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSDictionary 类型 或字典为空 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isDictEmptyOrNil:(id)obj;

#pragma mark - JSON & STRING
+(NSDictionary*)JSON_OBJ_FROM_STRING:(NSString *)jsonString;
+(NSString*)JSON_STRING_FROM_OBJ:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
