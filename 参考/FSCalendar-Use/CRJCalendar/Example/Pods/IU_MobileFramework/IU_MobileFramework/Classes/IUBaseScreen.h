//
//  IUBaseScreen.h
//  IU_MobileFramework
//
//  Created by zhuyuhui on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import "FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h"
#import "IU_HUD/IU_HUD.h"
#import "IU_GCD/IU_GCD.h"
#import "IU_Categories/IU_Categories.h"
#import "IU_GeneralTools/IU_GeneralTools.h"
#import "IUScreenProtocol.h"

#import "IUAppBar.h"
#import "IUMobileFrameworkTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface IUBaseScreen : UIViewController<IUBaseScreenProtocol>
/// 自定义导航条
@property (nonatomic, strong) IUAppBar *appBar;
/// 内容视图【子视图应加入该视图】
@property (nonatomic, strong) UIView *iuView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

@end

NS_ASSUME_NONNULL_END
