//
//  NSMutableDictionary+RE.h
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (RE)

/**
 * 把某个键名对应的元素同步到另一个键上
 */
- (void)syncDataFromKey:(NSString *)fromKey toKey:(NSString *)toKey;

/**
 * 删除一个指定键名的元素
 */
- (void)remove:(NSString *)key;

/**
 * 设定一个字符串键值对
 */
- (void)setString:(NSString *)value forKey:(NSString *)key;

/**
 * 设定布尔键值对
 */
- (void)setBool:(BOOL)value forKey:(NSString *)key;

/**
 * 设定一个整型键值对
 */
- (void)setInt:(int)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)value forKey:(NSString *)key;

- (void)setFrame:(CGRect)frame forKey:(NSString *)key;
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets forKey:(NSString *)key;

/**
 * 判断两个 DataItem 对象是否相等
 */
- (BOOL)equals:(id)obj;

/**
 * 从另一个 DataItem 追加数据到本对象
 */
- (void)append:(NSDictionary *)item;
/**
 * 从另一个 DataItem 追加覆盖数据到本对象(非空不覆盖)
 */
- (void)appendNotNullData:(NSDictionary *)item;
- (NSMutableArray *)getMutableArray:(NSString *)aKey;
- (NSMutableDictionary *)getMutableDict:(NSString *)aKey;

@end
