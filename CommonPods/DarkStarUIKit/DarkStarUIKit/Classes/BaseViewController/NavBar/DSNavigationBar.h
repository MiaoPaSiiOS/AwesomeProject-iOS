//
//  DSNavigationBar.h
//  DSViewController
//
//  Created by zhuyuhui on 2022/6/16.
//

#import "DSDataView.h"
#import "DSBarButtonItem.h"
#import "DSBarButton.h"
#import "DSBarItem.h"
#import "DSNavItem.h"
@interface DSNavigationBar : DSDataView
/**
 *    @brief    左导航按钮数据项.
 */
@property (nonatomic, strong) DSBarButtonItem *leftBarButtonItem;
/**
 *    @brief    右导航按钮数据项.
 */
@property (nonatomic, strong) DSBarButtonItem *rightBarButtonItem;
/**
 *    @brief    标题数据项.
 */
@property (nonatomic, strong) DSNavItem *topItem;

/**
 *    @brief    背景图片.
 */
@property (nonatomic, strong) UIImage *bgImg;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UILabel *topTitleView;
@property (nonatomic, strong) DSBarButton *leftBarButton;
@end
