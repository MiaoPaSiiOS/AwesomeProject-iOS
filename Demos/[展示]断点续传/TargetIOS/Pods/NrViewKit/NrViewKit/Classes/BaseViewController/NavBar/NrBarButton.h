//
//  NrBarButton.h
//  NrViewController
//
//  Created by zhuyuhui on 2022/7/4.
//

#import <NrBaseCoreKit/NrBaseCoreKit.h>
@class NrBarButtonItem;
@interface NrBarButton : NrDataView
/**
 *    @brief    导航按钮数据项.
 */
@property (nonatomic, strong) NrBarButtonItem *item;

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
- (instancetype)initWithItem:(NrBarButtonItem *)item;

@end
