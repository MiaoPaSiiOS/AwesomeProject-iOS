//
//  DSNavigationBar.h
//  DSViewController
//
//  Created by zhuyuhui on 2022/6/16.
//

#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSBarButtonItem.h"
#import "DSBarButton.h"
#import "DSBarItem.h"
@interface DSNavigationBar : DSDataView
@property (nonatomic, strong) UILabel *topTitleView;
/**
 *    @brief    左导航按钮数据项.
 */
@property (nonatomic, strong) DSBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) DSBarButton *leftBarButton;
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
@end
