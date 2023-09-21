//
//  NSArray+IUIndexPath.h
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IUIndexPath)

- (NSMutableArray <NSIndexPath *> *)indexPathsFirstRowFrom:(NSInteger)from section:(NSInteger)section;
- (NSMutableArray <NSIndexPath *> *)indexPathsInSection:(NSInteger)section;

@end


@interface NSIndexPath (IUIndexPath)

+ (NSMutableArray <NSIndexPath *> *)indexPathsWithRange:(NSRange)range section:(NSInteger)section;
+ (NSMutableArray <NSIndexPath *> *)indexPathsWithArray:(NSArray *)array section:(NSInteger)section;

@end
