//
//  NSArray+RE.m
//  CommonLib
//
//  Created by sean on 2016/3/11.
//  Copyright © 2016年 ihome. All rights reserved.
//


#import "NSArray+RE.h"
#import "NSMutableDictionary+RE.h"
#import "RETools.h"
@implementation NSArray (RE)

- (NSMutableArray *)getMutableArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self)
    {
        id newObj;
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

        [array addObject:newObj];
    }

    return array;
}

- (NSDictionary *)getDict:(NSUInteger)index
{
    id item = [self getObject:index];

    if ([item isKindOfClass:[NSDictionary class]])
    {
        return item;
    }

    return [NSDictionary dictionary];
}

- (NSArray *)getArray:(NSUInteger)index
{
    id item = [self getObject:index];

    if ([item isKindOfClass:[NSArray class]])
    {
        return item;
    }

    return [NSArray array];
}

- (id)getObject:(NSUInteger)index
{
    if (index >= [self count])
    {
        return nil;
    }

    return [self objectAtIndex:index];
}

- (int)getInt:(NSUInteger)index
{
    id value = [self getObject:index];
    if ([RETools iSNull:value])
    {
        return 0;
    }

    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]])
    {
        return [value intValue];
    }

    return 0;
}

- (NSString *)getString:(NSUInteger)index
{
    id value = [self getObject:index];

    if (nil == value)
    {
        return @"";
    }
    else
    {
        return [value toString];
    }
}

- (BOOL)isMutable
{
    static Class mutableArrayClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *mutableArray = @[ @1, @2 ].mutableCopy;
        mutableArrayClass = [mutableArray class];
    });

    return [self isKindOfClass:mutableArrayClass];
}


- (double)getDouble:(NSUInteger)index
{
    id value = [self getObject:index];
    if ([RETools iSNull:value])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]])
    {
        return [value doubleValue];
    }
    
    return 0;
}
- (double)getDouble:(NSUInteger)index min:(double)min
{
    double value = [self getDouble:index];
    value = MAX(value, min);
    
    return value;
}
- (void)appendProperty:(NSDictionary *)property key:(NSString *)key
{
    for (NSMutableDictionary *item in self)
    {
        if ([item isKindOfClass:[NSDictionary class]] && [item isMutable])
        {
            if ([item hasKey:key])
            {
                [item append:property];
            }
        }
        else if ([item isKindOfClass:[NSArray class]] && [item isMutable])
        {
            NSMutableArray *subItems = (NSMutableArray *)item;
            [subItems appendProperty:property key:key];
        }
    }
}

@end
