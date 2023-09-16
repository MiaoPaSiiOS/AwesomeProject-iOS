

#import <DarkStarBaseKit/DarkStarBaseKit.h>
@class DSBarButtonItem;
@interface DSBarButton : DSDataView
/**
 *    @brief    导航按钮数据项.
 */
@property (nonatomic, strong) DSBarButtonItem *item;

/**
 *    @brief    标题内填充.
 */
@property (nonatomic, assign) UIEdgeInsets textInset;
/**
 *    @brief    图片内填充.
 */
@property (nonatomic, assign) UIEdgeInsets imageInset;

/**
 *    @brief    按钮
 */
@property (nonatomic,strong) UIButton *barButton;

/**
 *    @brief    PNCBarButton初始化.
 *
 *    @param     item     数据项.
 *
 *    @return    PNCBarButton实例.
 */
- (instancetype)initWithItem:(DSBarButtonItem *)item;

@end
