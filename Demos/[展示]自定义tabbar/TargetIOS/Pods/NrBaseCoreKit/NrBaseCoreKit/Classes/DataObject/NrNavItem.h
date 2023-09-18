//
//  NrNavItem.h
//  TmallUIKit
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "NrNItem.h"

@interface NrNavItem : NrNItem
/**
 *    @brief    标题.
 */
@property (nonatomic, copy) NSString *title;

/**
 *    @brief    图片.
 */
@property (nonatomic, strong) UIImage *img;

/**
 *    @brief    标题颜色, 默认[UIColor WhiteColor].
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *    @brief    标题字体, 默认[UIFont systemFontOfSize:21.f].
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *    @brief    logo 图片的摆放位置(偏移量)
 */
@property (nonatomic, assign) CGFloat imgOffset;

/**
 *    @brief    PNCNavItem初始化.
 *
 *    @param     nTitle     标题.
 *    @param     nImg     图片.
 *
 *    @return    PNCNavItem实例.
 */
- (instancetype)initWithTitle:(NSString *)nTitle img:(UIImage *)nImg;

/**
 *    @brief    PNCNavItem初始化.
 *
 *    @param     nTitle     标题.
 *
 *    @return    PNCNavItem实例.
 */
- (instancetype)initWithTitle:(NSString *)nTitle;

/**
 *    @brief    PNCNavItem初始化.
 *
 *    @param     nImg     图片.
 *
 *    @return    NrNavItem实例.
 */
- (instancetype)initWithImg:(UIImage *)nImg;

@end
