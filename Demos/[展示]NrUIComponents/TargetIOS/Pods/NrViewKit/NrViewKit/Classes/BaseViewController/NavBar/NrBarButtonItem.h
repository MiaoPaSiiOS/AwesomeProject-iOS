//
//  NrBarButtonItem.h
//  NrViewController
//
//  Created by zhuyuhui on 2022/7/4.
//

#import "NrBarItem.h"
/**
 *    @brief    Bar按钮样式.
 */
typedef NS_ENUM(NSInteger, NrBarButtonItemStyle){
    /*!
     *  @brief  普通方形带边框按钮
     */
    NrBarButtonItemStyleBordered,
    /*!
     *  @brief  返回按钮样式
     */
    NrBarButtonItemStyleBack,
    /*!
     *  @brief  自定义视图按钮
     */
    NrBarButtonItemStyleCustom,
};

/**
 *    @brief    Bar按钮数据项.
 */
@interface NrBarButtonItem : NrBarItem
/**
 *    @brief    动作.
 */
@property (nonatomic) SEL action;

/**
 *    @brief    动作源对象.
 */
@property (nonatomic, weak) id target;

/**
 *    @brief    按钮样式.
 */
@property (nonatomic, assign) NrBarButtonItemStyle style;

/**
 *    @brief    自定义视图.
 */
@property (nonatomic, strong) UIView *customView;

/**
 *    @brief    Bar按钮数据项.
 *
 *    @param     nTitle      按钮标题.
 *    @param     nTarget     按钮动作源对象.
 *    @param     nAction     按钮动作.
 *
 *    @return    Bordered按钮.
 */
- (instancetype)initWithTitle:(NSString *)nTitle target:(id)nTarget action:(SEL)nAction;

/**
 *    @brief    Bar按钮数据项.
 *
 *    @param     nTarget     按钮动作源对象.
 *    @param     nAction     按钮动作.
 *
 *    @return    Back按钮.
 */
- (instancetype)initBackWithTarget:(id)nTarget action:(SEL)nAction;

/**
 *    @brief    Bar按钮数据项.
 *
 *    @param     nCustomView     自定义按钮视图.
 *
 *    @return    Custom按钮.
 */
- (instancetype)initWithCustomView:(UIView *)nCustomView;

/**
 *    @brief    默认border图片, 默认nil.
 *
 *    @return    UIImage数组, (borderImage,borderImageHighlight).
 */
- (NSArray *)borderImages;

/**
 *    @brief    默认back按钮图片, 默认nil.
 *
 *    @return    UIImage数组, (borderImage,borderImageHighlight).
 */
- (NSArray *)backImages;

@end

