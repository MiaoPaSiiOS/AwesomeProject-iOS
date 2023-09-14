//
//  DarkStarDataType.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/6/20.
//

#import "DarkStarDataType.h"

@implementation DarkStarDataType


#pragma mark - NSString

/**
 判断对象是否存在, 是否为 NSString 类型

 @param obj 要判断的对象
 @return 对象为 NSString 类型: YES, 对象不存在或不是 NSString 类型: NO
 */
BOOL isString(id obj) {
    if (obj && [obj isKindOfClass:NSString.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSString 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: YES, 其他情况: NO
 */
BOOL isStringEmptyOrNil(id obj) {
    if (!obj || !isString(obj) || [obj length] < 1) {
        return YES;
    } else {
        return NO;
    }
}

/**
 直接取值

 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: 空字符串, 其他情况: 原值
 */
NSString* safeString(id obj) {
    if (obj && (NSNull *)obj != [NSNull null]) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj stringValue];
        } else if([obj isKindOfClass:[NSObject class]]){
            return [obj description];
        }
    }
    return @"";
}

#pragma mark - NSArray


/**
 判断对象是否存在, 是否为 NSArray 类型

 @param obj 要判断的对象
 @return 对象存在为 NSArray 类型: YES, 对象不存在或不是 NSArray 类型: NO
 */
BOOL isArray(id obj) {
    if (obj && [obj isKindOfClass:NSArray.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSArray 类型, 是否有数据 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSArray 类型 或数组为空 或为nil: YES, 其他情况: NO
 */
BOOL isArrayEmptyOrNil(id obj) {
    if (!obj || !isArray(obj) || [obj count] < 1) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - NSDictionary


/**
 判断对象是否存在, 是否为 NSDictionary 类型

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型: YES, 对象不存在或不是 NSDictionary 类型: NO
 */
BOOL isDictionary(id obj) {
    if (obj && [obj isKindOfClass:NSDictionary.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型且字典不为空: 原对象字典, 其他情况: 空字典
 */
NSDictionary *isEmptyDict(id obj) {
    if(!isDictEmptyOrNil(obj)){
        return obj;
    } else {
        return @{};
    }
}


/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSDictionary 类型 或字典为空 或为 nil: YES, 其他情况: NO
 */
BOOL isDictEmptyOrNil(id obj) {
    if (!obj || !isDictionary(obj) || [obj allKeys].count < 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - JSON & STRING
NSDictionary* JSON_OBJ_FROM_STRING(NSString *jsonString) {
    if (isStringEmptyOrNil(jsonString)) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || !isDictionary(JSONObject)) {
        return nil;
    }
    return JSONObject;

}

NSString* JSON_STRING_FROM_OBJ(NSDictionary *dic) {
    if (isDictEmptyOrNil(dic)) {
        return nil;
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError || !jsonData) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
