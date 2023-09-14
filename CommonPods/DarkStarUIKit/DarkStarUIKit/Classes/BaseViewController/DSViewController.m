//
//  DSViewController.m
//  DSViewController
//
//  Created by zhuyuhui on 2021/11/11.
//

#import "DSViewController.h"
@interface DSViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DSViewController

- (instancetype)init {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        [self dsSetUp];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self dsSetUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super initWithCoder:aDecoder]) {
        [self dsSetUp];
    }
    return self;
}

- (void)dsSetUp {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navShowBack = YES;
    self.hideNavBar = NO;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self dsInitSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (!self.topItem){ //设置默认
        DSNavItem *item = [[DSNavItem alloc] initWithTitle:self.title];
        item.img = self.navLogoImg;
        item.titleColor = [UIColor blackColor];
        item.titleFont = [UIFont boldSystemFontOfSize:17];
        item.title = self.title;
        self.appBar.topItem = item;
    } else {
        self.appBar.topItem = self.topItem;
    }
    [self showBackBarButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navShowBack && self.navigationController) {
        NSArray *array = self.navigationController.viewControllers;
        //堆栈里 navigationController大于1时启动侧滑返回
        if ([array count] > 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled=YES;
        }
    }else{
        //无返回键时禁止侧滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    }
}

#pragma mark - Init
- (void)dsInitSubviews {
    [self.view addSubview:self.nrView];
    [self.view addSubview:self.appBar];
    [self.nrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNaviBarHeight);
        make.bottom.left.right.mas_offset(0);
    }];
    [self.appBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(kNaviBarHeight);
    }];
}

- (void)showBackBarButton {
    if (self.navShowBack && self.navigationController) {
        NSArray *array = self.navigationController.viewControllers;
        if ([array count] > 0) {
            id rootVC = [self.navigationController.viewControllers objectAtIndex:0];
            id topVC = self.navigationController.topViewController;
            if (self != rootVC && self == topVC && !self.appBar.leftBarButtonItem) {
                self.appBar.leftBarButtonItem = [[DSBarButtonItem alloc] initBackWithTarget:self action:@selector(backToPrev)];
            }
        }
    }
}

#pragma mark - 点击事件
- (void)backToPrev {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Useful Method
- (void)setTopItem:(DSNavItem *)topItem {
    _topItem = topItem;
    self.appBar.topItem = _topItem;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (self.appBar) {
        self.appBar.topItem.title = title;
        [self.appBar setNeedsLayout];
    }
}

#pragma mark - Lazy Init
- (DSNavigationBar *)appBar {
    if (!_appBar) {
        _appBar = [[DSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNaviBarHeight)];
        _appBar.background.backgroundColor = [UIColor whiteColor];
    }
    return  _appBar;
}

- (UIView *)nrView {
    if (!_nrView) {
        _nrView = [[UIView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, kScreenWidth, kScreenHeight - kNaviBarHeight)];
        _nrView.backgroundColor = kHexColor(0xF3F4F6);
    }
    return _nrView;
}

#pragma mark - UIStatusBarStyle //ADD BY THEO 2017-11-21
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (!self.isLightContentStyle) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)statusBarIsLightContentStyle:(BOOL)boolValue{
    if (self.isLightContentStyle == boolValue) {
        return;
    }
    self.isLightContentStyle=boolValue;
    [self setNeedsStatusBarAppearanceUpdate];
}


@end

