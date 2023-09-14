
#import "DSBarItem.h"
/**
 *    @brief    Bar按钮样式.
 */
typedef NS_ENUM(NSInteger, DSBarButtonItemStyle){
    /*!
     *  @brief  普通方形带边框按钮
     */
    DSBarButtonItemStyleBordered,
    /*!
     *  @brief  返回按钮样式
     */
    DSBarButtonItemStyleBack,
    /*!
     *  @brief  自定义视图按钮
     */
    DSBarButtonItemStyleCustom,
};

/**
 *    @brief    Bar按钮数据项.
 */
@interface DSBarButtonItem : DSBarItem
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
@property (nonatomic, assign) DSBarButtonItemStyle style;

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

