//
//  NrBarItem.h
//  NrViewController
//
//  Created by zhuyuhui on 2022/7/4.
//
#import <NrBaseCoreKit/NrBaseCoreKit.h>
/*!
 *  @brief  绘制边界的种类
 */
typedef NS_OPTIONS(NSUInteger, NrEdgeStroke){
    /*!
     *  @brief  无边界
     */
    NrEdgeStrokeNone       = 0,
    /*!
     *  @brief  左边界
     */
    NrEdgeStrokeLeft  = 1 << 0,
    /*!
     *  @brief  上边界
     */
    NrEdgeStrokeTop  = 1 << 1,
    /*!
     *  @brief  右边界
     */
    NrEdgeStrokeRight  = 1 << 2,
    /*!
     *  @brief  下边界
     */
    NrEdgeStrokeBottom  = 1 << 3,
};
@interface NrBarItem : NrNItem
/**
 *    @brief    Item是否可用.
 */
@property (nonatomic, assign) BOOL enabled;

/**
 *    @brief    Item标题.
 */
@property (nonatomic, copy) NSString *title;

/**
 *    @brief    Item前景图片.
 */
@property (nonatomic, strong) UIImage *img;

/**
 *    @brief    Item前景高亮图片, 默认等于img.
 */
@property (nonatomic, strong) UIImage *imgH;

/**
 *    @brief    Item背景图片.
 */
@property (nonatomic, strong) UIImage *imgBg;

/**
 *    @brief    Item背景高亮图片, 默认等于imgBg.
 */
@property (nonatomic, strong) UIImage *imgBgH;

/**
 *    @brief    标题颜色, 默认[UIColor WhiteColor].
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *    @brief    标题高亮颜色, 默认[UIColor WhiteColor].
 */
@property (nonatomic, strong) UIColor *titleColorH;

/**
 *    @brief    标题字体, 默认[UIFont systemFontOfSize:17.f].
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *    @brief    内填充, 默认UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 *    @brief    描边，默认 NrEdgeStrokeNone
 */
@property (nonatomic, assign) NrEdgeStroke edgeStroke;

/**
 *    @brief    描边颜色，默认darkTextColor
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 *    @brief    描边宽度，默认0
 */
@property (nonatomic, assign) CGFloat strokeWidth;

/**
 *    @brief    图片内填充，默认0
 */
@property (nonatomic, assign) UIEdgeInsets inset;

@end

