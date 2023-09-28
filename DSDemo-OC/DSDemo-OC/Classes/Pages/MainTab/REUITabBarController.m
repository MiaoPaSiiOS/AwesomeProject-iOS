//
//  REUITabBarController.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/3.
//

#import "REUITabBarController.h"
#import "REUITabBar.h"
#import "REUINavigationController.h"
/// tababr item tag
typedef NS_ENUM(NSUInteger,MHTabBarItemTagType) {
    MHTabBarItemTagTypeMainFrame = 0,       /// 首页
    MHTabBarItemTagTypeNotify,              /// 通知
    MHTabBarItemTagTypeData,                /// 消息
    MHTabBarItemTagTypeProfile,             /// 我的
};

#define MH_NormalItemColor [DSHelper colorWithHexString:@"0x333333"]
#define MH_SelectedItemColor [DSHelper colorWithHexString:@"0xE00514"]


@interface REUITabBarController ()<UITabBarControllerDelegate>
@property(nonatomic, strong) REUITabBar *centerTabBar;
@end

@implementation REUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self initWithTabbar];
    [self initControllers];
    [self configAppearance];
}

- (void)enterHomeWithIndex:(NSNumber*)idx{
    if (!idx) {
        return;
    }
    NSInteger index = idx.integerValue;
    if (index < 0 || index > (self.viewControllers.count - 1))
    {
        return;
    }
    [self setSelectedIndex:index];
    
    UIViewController *selectedVC = self.selectedViewController;
    if ([selectedVC isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)selectedVC popToRootViewControllerAnimated:YES];
    }
}



#pragma mark - 初始化tabBar
- (void)initWithTabbar{
    self.centerTabBar = [[REUITabBar alloc] init];
    //利用kvc 将自己的tabbar赋值给系统的tabbar
    [self setValue:self.centerTabBar forKeyPath:@"tabBar"];
}

#pragma mark - 初始化所有的子视图控制器
- (void)initControllers{
    NSArray *dataSource = @[
        @{
            @"title" : @"首页",
            @"imageName" : @"tab_home_default",
            @"selectedImageName" : @"tab_home_selected",
            @"itemTag" : @(MHTabBarItemTagTypeMainFrame),
            @"className":@"REHomeViewController",
        },
        @{
            @"title" : @"通知",
            @"imageName" : @"tab_notify_default",
            @"selectedImageName" : @"tab_notify_selected",
            @"itemTag" : @(MHTabBarItemTagTypeNotify),
            @"className":@"RENewsViewController",
        },
        @{
            @"title" : @"数据",
            @"imageName" : @"tab_data_default",
            @"selectedImageName" : @"tab_data_selected",
            @"itemTag" : @(MHTabBarItemTagTypeData),
            @"className":@"REStrollViewController",
        },
        @{
            @"title" : @"数据",
            @"imageName" : @"tab_data_default",
            @"selectedImageName" : @"tab_data_selected",
            @"itemTag" : @(MHTabBarItemTagTypeData),
            @"className":@"REShopCartViewController",
        },
        @{
            @"title" : @"我的",
            @"imageName" : @"tab_my_default",
            @"selectedImageName" : @"tab_my_selected",
            @"itemTag" : @(MHTabBarItemTagTypeProfile),
            @"className":@"REMineViewController",
        },
    ];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < dataSource.count; i++) {
        NSDictionary *vcInfo = dataSource[i];
        NSString *className = vcInfo[@"className"];
        if([DSHelper safeString:(className)].length && NSClassFromString(className)){
            UIViewController *viewController = [[NSClassFromString(className) alloc] init];
            UINavigationController *scene = ({
                [self _configViewController:viewController
                                  imageName:[vcInfo objectForKey:@"imageName"]
                          selectedImageName:[vcInfo objectForKey:@"selectedImageName"]
                                      title:[vcInfo objectForKey:@"title"]
                                    itemTag:[[vcInfo objectForKey:@"itemTag"] integerValue]];
                [[REUINavigationController alloc] initWithRootViewController:viewController];
            });
            [viewControllers addObject:scene];
        }
    }

    /// 添加到tabBarController的子视图
    self.viewControllers = viewControllers.copy;
    
    [REGlobal sharedInstance].tab_homeIndex     = @(0);
    [REGlobal sharedInstance].tab_noticeIndex   = @(1);
    [REGlobal sharedInstance].tab_dataIndex     = @(2);
    [REGlobal sharedInstance].tab_mineIndex     = @(3);
}



#pragma mark - 配置ViewController
- (void)_configViewController:(UIViewController *)viewController imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title itemTag:(MHTabBarItemTagType)tagType {
    
    viewController.title = [NSString stringWithFormat:@"%@",title];
    viewController.tabBarItem.tag = tagType;
    viewController.tabBarItem.title = title;

    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;

    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    

    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:MH_NormalItemColor};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:MH_SelectedItemColor};
    [viewController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

}

- (void)configAppearance{
    /*!
     tabbar设置
     设置ShadowImage或者BackgroundImage后，UITabBarController中的子控制器的View的frame将不会占满全屏！！！
     */
    [self.centerTabBar setShadowImage:[UIImage ds_imageWithColor:[DSHelper colorWithHexString:@"0xEEEEEE"]]];
    [self.centerTabBar setBackgroundImage:[UIImage ds_imageWithColor:[DSHelper colorWithHexString:@"0xFFFFFF"]]];
    if (@available(iOS 13.0, *)) {
        self.centerTabBar.tintColor = MH_SelectedItemColor;
        self.centerTabBar.unselectedItemTintColor = MH_NormalItemColor;
    } else {

    }
    
    

}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

#pragma mark - 旋转设置
//是否自动旋转
-(BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

//支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

//默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
