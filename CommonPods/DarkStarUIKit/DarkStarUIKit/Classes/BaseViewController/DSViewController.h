//
//  DSViewController.h
//  DSViewController
//
//  Created by zhuyuhui on 2021/11/11.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "DSNavigationBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface DSViewController : UIViewController
/// 自定义导航条
@property(nonatomic, strong, readonly) DSNavigationBar *appBar;

/// 是否显示返回按钮
@property(nonatomic, assign) BOOL dsBackBtnHidden;
/// 是否可以侧滑返回
@property(nonatomic, assign) BOOL dsInteractivePopDisabled;
/// 标题元素的属性(字体大小，字体颜色，logo图片偏移量)
@property(nonatomic, strong) DSNavItem *topItem;
/// 内容视图【层级在自定义导航条下边】
@property(nonatomic, strong) UIView *dsView;

@property(nonatomic, strong) NSDictionary *extParmers;
/**
 *  init时调用，初始化一些基础数据，属性，可重载
 */
- (void)dsSetUp;
- (void)dsInitSubviews;
/*!
 *  @brief  默认返回前一页面,子类可以重写该方法
 */
- (void)backToPrev;
/*!
 *  @brief  判断UIStatusBarStyle ADD BY THEO 2017-11-21
 */
@property (nonatomic, assign) BOOL isLightContentStyle;
/*!
 *  @brief  设置UIStatusBarStyle ADD BY THEO 2017-11-21
 */
- (void)statusBarIsLightContentStyle:(BOOL)boolValue;

@end

NS_ASSUME_NONNULL_END
