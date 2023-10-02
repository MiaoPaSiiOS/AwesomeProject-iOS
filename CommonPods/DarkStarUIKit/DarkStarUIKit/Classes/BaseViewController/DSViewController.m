//
//  DSViewController.m
//  DSViewController
//
//  Created by zhuyuhui on 2021/11/11.
//

#import "DSViewController.h"
@interface DSViewController ()
@property(nonatomic, strong, readwrite) DSNavigationBar *appBar;
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
    self.dsBackBtnHidden = NO;
    self.dsInteractivePopDisabled = NO;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = self.dsInteractivePopDisabled;
    [self dsInitSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.topItem){ //设置默认
        DSNavItem *item = [[DSNavItem alloc] initWithTitle:self.title];
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
}

#pragma mark - Init
- (void)dsInitSubviews {
    [self.view addSubview:self.dsView];
    [self.view addSubview:self.appBar];
    [self.dsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.mas_offset(DSDeviceInfo.naviBarHeight);
    }];
    [self.appBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(DSDeviceInfo.naviBarHeight);
    }];
}

- (void)showBackBarButton {
    if (!self.dsBackBtnHidden && self.navigationController) {
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

- (void)setDsInteractivePopDisabled:(BOOL)dsInteractivePopDisabled {
    _dsInteractivePopDisabled = dsInteractivePopDisabled;
    self.fd_interactivePopDisabled = dsInteractivePopDisabled;
}

#pragma mark - Lazy Init
- (DSNavigationBar *)appBar {
    if (!_appBar) {
        _appBar = [[DSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, DSDeviceInfo.screenWidth, DSDeviceInfo.naviBarHeight)];
        _appBar.background.backgroundColor = [UIColor whiteColor];
    }
    return  _appBar;
}

- (UIView *)dsView {
    if (!_dsView) {
        _dsView = [[UIView alloc] initWithFrame:CGRectMake(0, DSDeviceInfo.naviBarHeight, DSDeviceInfo.screenWidth, DSDeviceInfo.screenHeight - DSDeviceInfo.naviBarHeight)];
        _dsView.backgroundColor = [DSHelper colorWithHexString:@"0xF3F4F6"];
    }
    return _dsView;
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

