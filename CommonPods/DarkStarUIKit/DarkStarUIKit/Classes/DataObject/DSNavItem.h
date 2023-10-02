//
//  DSNavItem.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "DSItem.h"

@interface DSNavItem : DSItem
/// 标题.
@property (nonatomic, copy) NSString *title;

/// 图片.
@property (nonatomic, strong) UIImage *img;

/// 标题颜色, 默认[UIColor WhiteColor].
@property (nonatomic, strong) UIColor *titleColor;

/// 标题字体, 默认[UIFont systemFontOfSize:20.f].
@property (nonatomic, strong) UIFont *titleFont;

/// logo 图片的摆放位置(偏移量)
@property (nonatomic, assign) CGFloat imgOffset;


/// ds_
/// @param nTitle nTitle 标题.
/// @param nImg 图片.
- (instancetype)initWithTitle:(NSString *)nTitle img:(UIImage *)nImg;


/// ds_
/// @param nTitle 标题.
- (instancetype)initWithTitle:(NSString *)nTitle;


/// ds_
/// @param nImg 图片.
- (instancetype)initWithImg:(UIImage *)nImg;

@end
