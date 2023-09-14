//
//  NSArray+RE.h
//  CommonLib
//
//  Created by sean on 2016/3/11.
//  Copyright © 2016年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSArray (RE)

- (BOOL)isMutable;
- (NSArray *)getArray:(NSUInteger)index;
- (NSDictionary *)getDict:(NSUInteger)index;
- (NSMutableArray *)getMutableArray;
- (id)getObject:(NSUInteger)index;

- (int)getInt:(NSUInteger)index;
- (NSString *)getString:(NSUInteger)index;

- (double)getDouble:(NSUInteger)index;
- (double)getDouble:(NSUInteger)index min:(double)min;
- (void)appendProperty:(NSDictionary *)property key:(NSString *)key;

@end
