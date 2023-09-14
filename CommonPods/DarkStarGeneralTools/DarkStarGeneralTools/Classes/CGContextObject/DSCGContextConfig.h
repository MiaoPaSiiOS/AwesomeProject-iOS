//
//  DSCGContextConfig.h
//  DSCGContext_Example
//
//  Created by zhuyuhui on 2020/9/4.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSRGBColor.h"

/**
 *  Get the CGFloat's array.
 *
 *  @param count Array's count.
 *
 *  @return CGFloat's array.
 */
NS_INLINE CGFloat * IUCGFloatArrayWithCount(NSUInteger count) {
    
    return (CGFloat *)malloc(count * sizeof(CGFloat));
}
@interface DSCGContextConfig : NSObject

/**
 *  线头样式
 */
@property (nonatomic)          CGLineCap      lineCap;

/**
 *  Junction types for stroked lines.
 */
@property (nonatomic)          CGLineJoin     lineJoin;

/**
 *  线条宽度
 */
@property (nonatomic)          CGFloat        lineWidth;

#pragma mark - stroke & fill color

/**
 *  线条颜色
 */
@property (nonatomic, strong)  DSRGBColor      *strokeColor;

/**
 *  填充颜色
 */
@property (nonatomic, strong)  DSRGBColor      *fillColor;

#pragma mark - line dash pattern

/**
 *  Line dash pattern [Example]
 *
 *  - one type -
 *
 *  CGFloat lengths[] = {10, 10};
 *
 *  self.lengths      = lengths;
 *  self.phase        = 0;
 *  self.count        = 2;
 *
 *  - default -
 *
 *  self.lengths      = nil;
 *  self.phase        = 0;
 *  self.count        = 0;
 */

/**
 *  表示在第一个虚线绘制的时候跳过多少个点
 */
@property (nonatomic) CGFloat   phase;

/**
 *  指明虚线是如何交替绘制「 注：lengths的值｛5,2｝表示先绘制5个点，再跳过2个点，如此反复」
 */
@property (nonatomic) CGFloat  *lengths;

/**
 *  count的值等于lengths数组的长度
 */
@property (nonatomic) size_t    count;

@end

