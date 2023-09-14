//
//  NSDictionary+REm
//  RE
//
//  Created by 闫志强 on 2017/4/5.
//  Copyright © 2017年 RE. All rights reserved.
//

#import "NSDictionary+RE.h"
#import "RETools.h"
#import "NSString+RE.h"
#import "NSArray+RE.h"

@implementation NSDictionary (RE)

- (BOOL)hasKey:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return NO;
    }
    id value = [self objectForCaseInsensitiveKey:aKey];
    return ![RETools iSNull:value];
}


- (NSString *)dictToURLParameter:(NSDictionary *)dict
{
    if (nil == dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return @"";
    }
    
    NSArray *keys = dict.allKeys;
    NSMutableArray *pairs = @[].mutableCopy;
    for (id key in keys)
    {
        if ([RETools iSNull:key])
        {
            continue;
        }
        
        id value = dict[key];
        if ([RETools iSNull:value])
        {
            continue;
        }
        
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    return [pairs componentsJoinedByString:@"&"];
}


- (id)objectForCaseInsensitiveKey:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return nil;
    }
    
    __block id returnObj = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *tempKey = key;
        if ([tempKey compare:aKey options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            returnObj = obj;
            *stop = YES;
        }
    }];
    
    return returnObj;
}

/**
 * 获取对象
 */
- (id)getObject:(NSString *)aKey
{
    return [self objectForCaseInsensitiveKey:aKey];
}



- (NSString *)getString:(NSString *)aKey
{
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return @"";
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        if ([value compare:[NSNumber numberWithBool:NO]] == NSOrderedSame)
        {
            return @"0";
        }
        else if ([value compare:[NSNumber numberWithBool:YES]] == NSOrderedSame)
        {
            return @"1";
        }
        
        return [value description];
    }
    
    if ([value isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    if ([value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *valueDic = value;
        
        return [valueDic toJSONString];
    }
    
    if ([value respondsToSelector:@selector(description)])
    {
        id tmpValue = [value description];
        if ([tmpValue isKindOfClass:[NSString class]])
        {
            return tmpValue;
        }
    }
    
    return @"";
}

- (NSString *)getString:(NSString *)aKey1 or:(NSString *)aKey2
{
    NSString *value = [self getString:aKey1];
    if ([RETools stringIsEmpty:value])
    {
        value = [self getString:aKey2];
    }
    
    return value;
}

- (NSString *)getString:(NSString *)aKey1
                     or:(NSString *)aKey2
                     or:(NSString *)aKey3
{
    NSString *value = [self getString:aKey1 or:aKey2];
    if ([RETools stringIsEmpty:value])
    {
        value = [self getString:aKey3];
    }
    
    return value;
}

- (NSString *)getString:(NSString *)aKey defaultStr:(NSString *)aDefault
{
    NSString *value = [self getString:aKey];
    if ([RETools stringIsEmpty:value])
    {
        return aDefault;
    }
    else
    {
        return value;
    }
}


/**
 * 获取布尔值
 */
- (BOOL)getBool:(NSString *)aKey
{
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return NO;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        value = [value lowercaseString];
        if ([value isEqualToString:@"y"] || [value isEqualToString:@"on"] ||
            [value isEqualToString:@"yes"] || [value isEqualToString:@"true"])
        {
            return YES;
        }
        
        int intValue = [value intValue];
        if (intValue != 0)
        {
            return YES;
        }
    }
    
    return NO;
}

- (int)getInt:(NSString *)aKey
{
    return [self getInt:aKey defaultStr:0];
}

- (int)getInt:(NSString *)aKey defaultStr:(int)aDefault
{
    if ([RETools iSNull:aKey])
    {
        return aDefault;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return aDefault;
    }
    
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]])
    {
        return [value intValue];
    }
    
    return aDefault;
}

- (long)getLong:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return 0;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value longValue];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    
    return 0;
}

- (long long)getSuperLong:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return 0;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]])
    {
        return [value longLongValue];
    }
    
    return 0;
}

- (double)getDouble:(NSString *)aKey
{
    return [self getDouble:aKey defaultStr:0.0];
}

- (double)getDouble:(NSString *)aKey defaultStr:(double)aDefault
{
    if ([RETools iSNull:aKey])
    {
        return aDefault;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return aDefault;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value doubleValue];
    }
    
    return aDefault;
}

- (double)getDouble:(NSString *)aKey min:(double)min
{
    double value = [self getDouble:aKey];
    value = MAX(value, min);
    
    return value;
}

- (double)getDouble:(NSString *)aKey1 orKey:(NSString *)aKey2
{
    if ([self hasKey:aKey1])
    {
        return [self getDouble:aKey1];
    }
    else if ([self hasKey:aKey2])
    {
        return [self getDouble:aKey2];
    }
    else
    {
        return 0;
    }
}

- (double)getDouble:(NSString *)aKey1
              orKey:(NSString *)aKey2
              orKey:(NSString *)aKey3
{
    if ([self hasKey:aKey1])
    {
        return [self getDouble:aKey1];
    }
    else if ([self hasKey:aKey2])
    {
        return [self getDouble:aKey2];
    }
    else if ([self hasKey:aKey3])
    {
        return [self getDouble:aKey3];
    }
    else
    {
        return 0;
    }
}

- (NSNumber *)getNumber:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return @(0);
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return @(0);
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return [value toNumber];
    }
    
    return @(0);
}

- (CGRect)getFrame:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return CGRectZero;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return CGRectZero;
    }
    
    if ([value isKindOfClass:[NSValue class]])
    {
        return [value CGRectValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return CGRectFromString(value);
    }
    
    return CGRectZero;
}

- (UIEdgeInsets)getEdgeInsets:(NSString *)aKey
{
    if ([RETools iSNull:aKey])
    {
        return UIEdgeInsetsZero;
    }
    
    id value = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:value])
    {
        return UIEdgeInsetsZero;
    }
    
    if ([value isKindOfClass:[NSValue class]])
    {
        return [value UIEdgeInsetsValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return UIEdgeInsetsFromString(value);
    }
    
    return UIEdgeInsetsZero;
}

- (NSAttributedString *)getAttrString:(NSString *)aKey
{
    NSAttributedString *attrString = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:attrString] ||
        ![attrString isKindOfClass:[NSAttributedString class]])
    {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    else
    {
        return attrString;
    }
}

- (NSArray *)getArray:(NSString *)aKey
{
    id array = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:array] || ![array isKindOfClass:[NSArray class]])
    {
        return [NSArray array];
    }
    else
    {
        return array;
    }
}

- (NSDictionary *)getDict:(NSString *)aKey
{
    id dict = [self objectForCaseInsensitiveKey:aKey];
    if ([RETools iSNull:dict] || ![dict isKindOfClass:[NSDictionary class]])
    {
        return [NSDictionary dictionary];
    }
    else
    {
        return dict;
    }
}

- (NSMutableDictionary *)getMutableDictionary
{
    NSMutableDictionary *dict =
    [NSMutableDictionary dictionaryWithCapacity:[self count]];
    
    NSArray *keys = [NSArray arrayWithArray:[self allKeys]];
    for (NSString *key in keys)
    {
        id obj = [self objectForKey:key];
        id newObj = nil;
        if ([obj isKindOfClass:[NSArray class]])
        {
            newObj = [obj getMutableArray];
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            newObj = [obj getMutableDictionary];
        }
        else
        {
            newObj = obj;
        }
        
        [dict setObject:newObj forKey:key];
    }
    
    return dict;
}

/**
 * 判断是否为空
 */
- (BOOL)isEmpty
{
    return [self count] < 1;
}

#pragma mark - 转换

/**
 将字典的key和vale的值都转成UTF8格式
 
 @return 转过之后的字典
 */
- (NSDictionary *)dicEncodingAllCharacter
{
    NSMutableDictionary *dic =
    [NSMutableDictionary dictionaryWithCapacity:[self count]];
    
    if ([self isEmpty])
    {
        return dic.copy;
    }
    
    NSArray *keys = [NSArray arrayWithArray:[self allKeys]];
    for (NSString *key in keys)
    {
        NSString *value = self[key];
        
        if (![value isKindOfClass:[NSString class]])
        {
            if (![value respondsToSelector:@selector(description)])
            {
                continue;
            }
            
            NSString *tmpValue = [value description];
            if (![tmpValue isKindOfClass:[NSString class]])
            {
                continue;
            }
            
            value = [NSString stringWithString:tmpValue];
        }
        [dic setString:[value urlEncodingAllCharacter]
                forKey:[key urlEncodingAllCharacter]];
    }
    
    return dic.copy;
}

/**
 * 构造Uri参数JSON格式字符串
 */
- (NSString *)toJSONString
{
    @try
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization  //
                            dataWithJSONObject:self
                            options:kNilOptions
                            error:&error];
        
        if (nil == error)
        {
            NSString *string = [[NSString alloc]  //
                                initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
            
            return [RETools forceString:string];
        }
        else
        {
            return @"";
        }
    }
    @catch (NSException *exception)
    {
        return @"";
    }
}


- (BOOL)isMutable
{
    static Class mutableDictionaryClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *mutableDict =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:@"a", @"b", nil];
        
        mutableDictionaryClass = [mutableDict class];
    });
    
    return [self isKindOfClass:mutableDictionaryClass];
}


@end
