//
//  ESTabBarController.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "ESTabBarController.h"
#import <DarkStarUIComponents/DarkStarUIComponents.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "ESTabBarView.h"
#import "DSAwesomeKitTool.h"
@interface ESTabBarController ()<UITabBarControllerDelegate,HomeTabBarViewDelegate>

@property (nonatomic, strong) ESTabBarView * tabbarView;

@property (nonatomic, strong) DSUIButton * giftBtn;

@property (nonatomic, assign) CGFloat initBottomValue;
@end

@implementation ESTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.tabBar.hidden = YES;
    self.delegate = self;

    _tabbarVc = [[NSMutableArray alloc] initWithObjects:
                 [self initSubVC],
                 [self initSubVC],
                 [self initSubVC],
                 [self initSubVC],
                 [self initSubVC],
                 nil];
    
    NSMutableArray * controllers = [NSMutableArray new];
    for (UIViewController * vc in _tabbarVc) {
        [controllers addObject:vc];
    }
    self.viewControllers = controllers;
    self.tabbarView = [[ESTabBarView alloc] initWithFrame:CGRectMake(0, DSCommonMethods.screenHeight - DSCommonMethods.tabBarHeight, DSCommonMethods.screenWidth, DSCommonMethods.tabBarHeight)];
    self.tabbarView.delegate = self;

    [self.view addSubview:self.tabbarView];
    
    [self initBtn];
    
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    //监听是否重新进入程序程序
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self endBtnAnim];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self isCurrentNavInRootVc]) {
        [self startBtnAnim];
    }
}

- (void)initBtn{
    self.giftBtn = [[DSUIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    [self.giftBtn setBackgroundImage:[DSAwesomeKitTool imageNamed:@"tabbar_btn_bg"] forState:UIControlStateNormal];
    [self.giftBtn setTitle:@"福袋" forState:UIControlStateNormal];
    [self.giftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.giftBtn setImage:[DSAwesomeKitTool imageNamed:@"tabbar_gift"] forState:UIControlStateNormal];
    self.giftBtn.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    self.giftBtn.imagePosition = DSUIButtonImagePositionTop;
    self.giftBtn.spacingBetweenImageAndTitle = 3;
    [self.view addSubview:self.giftBtn];
    self.giftBtn.centerX = self.view.width / 2.0;

    self.initBottomValue = DSCommonMethods.screenHeight - DSCommonMethods.tabBarHeight + 20;
    self.giftBtn.bottom = self.initBottomValue;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftClick)];
    [self.giftBtn addGestureRecognizer:tap];
    
    [self startBtnAnim];
}

- (UIViewController *)initSubVC {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = kRandomColor;
    return vc;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    [self.tabbarView selectIndex:selectedIndex];
}

#pragma mark 通知
- (void)applicationWillResignActive{
    [self endBtnAnim];
}

- (void)applicationDidBecomeActive{
    UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]){
        if (rootVC.viewControllers.count == 1) {
            [self startBtnAnim];
        }
    }
}



#pragma mark HomeTabBarViewDelegate
- (void)homeTabBarViewClick:(NSInteger)index{
    self.selectedIndex = index;
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([tabBarController.viewControllers indexOfObject:viewController] == 2) {
        return NO;
    }
    return YES;
}

#pragma mark 全屏旋转相关
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark 相关方法
- (void)startBtnAnim{
    if (self.giftBtn.layer.animationKeys != nil) {
        return;
    }
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.giftBtn.bottom = self.initBottomValue + 20;
    } completion:nil];
}

- (void)endBtnAnim{
    if (self.giftBtn.layer.animationKeys == nil) {
        return;
    }
    [self.giftBtn.layer removeAllAnimations];
    self.giftBtn.bottom = self.initBottomValue;
}

- (void)giftClick{
    NSLog(@"点击GIF");
}

- (BOOL)isCurrentNavInRootVc{
    UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]){
        if (rootVC.viewControllers.count == 1) {
            return YES;
        }
    }
    return NO;
}

@end
