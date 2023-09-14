//
//  NSDictionary+RE.h
//  RE
//
//  Created by 闫志强 on 2017/4/5.
//  Copyright © 2017年 RE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RE)

- (BOOL)isMutable;
- (BOOL)hasKey:(NSString *)aKey;
- (long)getLong:(NSString *)aKey;
- (BOOL)getBool:(NSString *)aKey;

/**
 *  忽略key大小写查询字典
 */
- (id)objectForCaseInsensitiveKey:(NSString *)aKey;
- (id)getObject:(NSString *)aKey;

- (int)getInt:(NSString *)aKey;
- (int)getInt:(NSString *)aKey defaultStr:(int)aDefault;


- (long long)getSuperLong:(NSString *)aKey;
- (double)getDouble:(NSString *)aKey;
- (double)getDouble:(NSString *)aKey min:(double)min;
- (double)getDouble:(NSString *)aKey defaultStr:(double)aDefault;
- (double)getDouble:(NSString *)aKey1 orKey:(NSString *)aKey2;
- (double)getDouble:(NSString *)aKey1 orKey:(NSString *)aKey2 orKey:(NSString *)aKey3;

- (NSNumber *)getNumber:(NSString *)aKey;

- (CGRect)getFrame:(NSString *)aKey;
- (UIEdgeInsets)getEdgeInsets:(NSString *)aKey;

- (NSString *)getString:(NSString *)aKey;
- (NSString *)getString:(NSString *)aKey1 or:(NSString *)aKey2;
- (NSString *)getString:(NSString *)aKey1 or:(NSString *)aKey2 or:(NSString *)aKey3;
- (NSString *)getString:(NSString *)aKey  defaultStr:(NSString *)aDefault;


- (NSAttributedString *)getAttrString:(NSString *)aKey;

- (NSArray *)getArray:(NSString *)aKey;

- (NSDictionary *)getDict:(NSString *)aKey;
- (NSMutableDictionary *)getMutableDictionary;



/**
 * 构造Uri参数JSON格式字符串
 */
- (NSString *)toJSONString;

- (NSString *)dictToURLParameter:(NSDictionary *)dict;

@end
