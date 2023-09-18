//
//  NrNavigationBar.h
//  NrViewController
//
//  Created by zhuyuhui on 2022/6/16.
//

#import "NrDataView.h"
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>
#import "NrBarButtonItem.h"
#import "NrBarButton.h"
#import "NrBarItem.h"
@interface NrNavigationBar : NrDataView
@property (nonatomic, strong) UILabel *topTitleView;
/**
 *    @brief    左导航按钮数据项.
 */
@property (nonatomic, strong) NrBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) NrBarButton *leftBarButton;
/**
 *    @brief    右导航按钮数据项.
 */
@property (nonatomic, strong) NrBarButtonItem *rightBarButtonItem;
/**
 *    @brief    标题数据项.
 */
@property (nonatomic, strong) NrNavItem *topItem;


/**
 *    @brief    背景图片.
 */
@property (nonatomic, strong) UIImage *bgImg;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIView *navigationBar;
@end
