//
//  IUBaseScreen.m
//  IU_MobileFramework
//
//  Created by zhuyuhui on 2021/6/10.
//

#import "IUBaseScreen.h"
@interface IUBaseScreen ()
@property(nonatomic, strong) IUHUD *hud;
@end

@implementation IUBaseScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iuSetUp];
    [self iuInitSubviews];
    //data
    self.appBar.titleLabel.text = self.title;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self iuSetUpNavigationItems];
    [self iuSetUpToolbarItems];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.iuView.frame = self.view.bounds;
    self.appBar.frame = CGRectMake(0, 0, self.view.width, [self getAppBarHeight]);
}

#pragma mark - IUBaseScreenProtocol
#pragma mark - init
- (void)iuSetUp {
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)iuInitSubviews {
    self.iuView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.iuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.iuView];
    [self.iuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iuView.superview);
    }];
    
    self.appBar = [[IUAppBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [self getAppBarHeight])];
    self.appBar.backgroundColor = [UIColor whiteColor];
    self.appBar.titleLabel.font = [UIFont systemFontOfSize:17];
    self.appBar.titleLabel.textColor = [UIColor blackColor];
    self.appBar.divideLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view insertSubview:self.appBar aboveSubview:self.iuView];
}

- (void)iuSetUpNavigationItems {
    if (self.navigationController.viewControllers.count > 1) {
        NSMutableArray *leftItems = [NSMutableArray array];
        [leftItems addObject:self.backButton];
        self.appBar.leftBarButtonItems = leftItems;
    }
}

- (void)iuSetUpToolbarItems {
    
}
#pragma mark - 点击事件
- (void)iuClickBackButton {
    /// 判断 是Push还是Present进来的，
    if (self.presentingViewController) {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 常用值设置
- (CGFloat)getAppBarHeight {
    BOOL IsPortrait = IUDeviceInfo.isPortrait;//是否是竖屏
    CGFloat safeAreaTop = 0;
    if (IsPortrait) {
        if (IUDeviceInfo.isFringeScreen) {
            safeAreaTop = IUDeviceInfo.fringeScreenTopSafeHeight;
        } else {
            safeAreaTop = 20;
        }
    } else {
        safeAreaTop = 0;
    }
    CGFloat appBarH = safeAreaTop + [self getNavigationBarHeight];
    return appBarH;

}

- (CGFloat)getNavigationBarHeight {
    return 44;
}

- (UIImage *)getBackButtonImage {
    return [IUMobileFrameworkTool imageFromBundle:@"navigation_back"];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.appBar.titleLabel.text = title;
}


#pragma mark - 页面加载
/**
 * 展示页面加载视图。
 */
- (void)startLoading {
    [GCDQueue executeInMainQueue:^{
        if (self.hud) {
            [self.hud hideAnimated:YES];
        }
        self.hud = [IUHUD showText:@"加载中..." inView:self.view];
    }];
}

/**
 * 停止加载视图显示。
 */
- (void)stopLoading {
    [GCDQueue executeInMainQueue:^{
        if (self.hud) {
            [self.hud hideAnimated:YES];
        }
    }];
}



#pragma mark - getter setter
- (UIButton *)backButton{
    if (!_backButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:[self getBackButtonImage] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(iuClickBackButton) forControlEvents:UIControlEventTouchUpInside];
        _backButton = btn;
    }
    return _backButton;
}



#pragma mark - Orientation
//是否跟随屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}
//支持旋转的方向有哪些
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskAll);
}
//控制 vc present进来的横竖屏和进入方向 ，支持的旋转方向必须包含改返回值的方向 （详细的说明见下文）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

@end
