//
//  NSMutableDictionary+REm
//  IHome4Phone
//
//  Created by sean on 2016/3/30.
//  Copyright © 2016年 ihome. All rights reserved.
//

#import "RETools.h"
#import "NSMutableDictionary+RE.h"

@implementation NSMutableDictionary (RE)

/**
 * 把某个键名对应的元素同步到另一个键上
 */
- (void)syncDataFromKey:(NSString *)fromKey toKey:(NSString *)toKey
{
    if (nil == fromKey || nil == toKey)
    {
        return;
    }

    if (![self hasKey:fromKey])
    {
        [self remove:toKey];
    }
    else
    {
        [self setObject:[self objectForKey:fromKey] forKey:toKey];
    }
}

/**
 * 删除一个指定键名的元素
 */
- (void)remove:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self removeObjectForKey:key];
}

/**
 * 设定一个字符串键值对
 */
- (void)setString:(NSString *)value forKey:(NSString *)key
{
    if (nil == key || nil == value)
    {
        if (nil != key && nil == value)
        {
            [self removeObjectForKey:key];
        }

        return;
    }

    [self setObject:value forKey:key];
}

/**
 * 设定布尔键值对
 */
- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

/**
 * 设定一个整型键值对
 */
- (void)setInt:(int)value forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setNumber:(NSNumber *)value forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:value forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)setFrame:(CGRect)frame forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:[NSValue valueWithCGRect:frame] forKey:key];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets forKey:(NSString *)key
{
    if (nil == key)
    {
        return;
    }

    [self setObject:[NSValue valueWithUIEdgeInsets:edgeInsets] forKey:key];
}

/**
 * 判断两个 DataItem 对象是否相等
 */
- (BOOL)equals:(id)obj
{
    if (![obj isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }

    NSDictionary *compareObj = obj;
    if ([self count] != [compareObj count])
    {
        return NO;
    }

    NSArray *keys = [NSArray arrayWithArray:[self allKeys]];
    for (NSString *key in keys)
    {
        id valueMe = [self getObject:key];
        id valueObj = [compareObj getObject:key];

        if (valueMe == nil || valueObj == nil)
        {
            return NO;
        }

        if (valueMe == valueObj)
        {
            continue;
        }

        if (![valueObj isKindOfClass:[valueMe class]] &&
            ![valueMe isKindOfClass:[valueObj class]])
        {
            return NO;
        }

        if ([valueMe isKindOfClass:[NSString class]])
        {
            if ([valueMe isEqualToString:valueObj])
            {
                continue;
            }
        }
        else if ([valueMe isKindOfClass:[NSNumber class]])
        {
            if ([valueMe compare:valueObj] == NSOrderedSame)
            {
                continue;
            }
        }
        else if ([valueMe isKindOfClass:[NSArray class]])
        {
            if ([valueMe equals:valueObj])
            {
                continue;
            }
        }
        else if ([valueMe isKindOfClass:[NSDictionary class]])
        {
            if ([valueMe equals:valueObj])
            {
                continue;
            }
        }
//        else if ([valueMe isKindOfClass:[DataResult class]])
//        {
//            if ([valueMe equals:valueObj])
//            {
//                continue;
//            }
//        }

        return NO;
    }

    return YES;
}

/**
 * 从另一个 DataItem 追加数据到本对象
 */
- (void)append:(NSDictionary *)item
{
    if (nil == item || self == item ||
        ![item isKindOfClass:[NSDictionary class]] || item.count <= 0)
    {
        return;
    }

    NSArray *keys = [NSArray arrayWithArray:[item allKeys]];
    for (NSString *key in keys)
    {
        if (![RETools stringIsEmpty:key])
        {
            [self setObject:[item getObject:key] forKey:key];
        }
    }
}

/**
 * 从另一个 DataItem 追加覆盖数据到本对象(非空不覆盖)
 */
- (void)appendNotNullData:(NSDictionary *)item
{
    if (nil == item || self == item ||
        ![item isKindOfClass:[NSDictionary class]] || item.count <= 0)
    {
        return;
    }

    NSArray *keys = [NSArray arrayWithArray:[item allKeys]];
    for (NSString *key in keys)
    {
        if (![RETools stringIsEmpty:key])
        {
            id obj = [item getObject:key];
            if ([RETools iSNotNull:obj]) {
                [self setObject:[item getObject:key] forKey:key];
            }
        }
    }
}

- (NSMutableDictionary *)getMutableDict:(NSString *)aKey
{
    id item = [self getObject:aKey];

    if ([RETools iSNull:item])
    {
        return [NSMutableDictionary dictionaryWithCapacity:0];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        if ([item isMutable])
        {
            return item;
        }

        NSMutableDictionary *mutable =
            [NSMutableDictionary dictionaryWithDictionary:item];
        [self setObject:mutable forKey:aKey];

        return [self getObject:aKey];
    }
    else
    {
        return [NSMutableDictionary dictionaryWithCapacity:0];
    }
}

- (NSMutableArray *)getMutableArray:(NSString *)aKey
{
    id item = [self getObject:aKey];

    if ([RETools iSNull:item])
    {
        return [NSMutableArray arrayWithCapacity:0];
    }
    else if ([item isKindOfClass:[NSArray class]])
    {
        if ([item isMutable])
        {
            return item;
        }

        NSMutableArray *mutable = [NSMutableArray arrayWithArray:item];
        [self setObject:mutable forKey:aKey];

        return mutable;
    }
    else
    {
        return [NSMutableArray arrayWithCapacity:0];
    }
}

@end
