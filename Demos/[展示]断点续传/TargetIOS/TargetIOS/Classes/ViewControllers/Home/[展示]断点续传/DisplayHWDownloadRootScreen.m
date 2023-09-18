//
//  DisplayHWDownloadRootScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/18.
//

#import "DisplayHWDownloadRootScreen.h"
#import <JXCategoryView/JXCategoryView.h>
#import "DisplayHWHomeViewScreen.h"
#import "DisplayHWDownloadingViewScreen.h"
#import "DisplayHWCacheViewScreen.h"
#import "DisplayHWSettingViewScreen.h"

@interface DisplayHWDownloadRootScreen ()<JXCategoryListContainerViewDelegate>
@property(nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) NSArray *titles;
@end

@implementation DisplayHWDownloadRootScreen
// 一次性代码
- (void)projectOnceCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *onceKey = @"HWProjectOnceKey";
    if (![defaults boolForKey:onceKey]) {
        // 初始化下载最大并发数为1，不允许蜂窝网络下载
        [defaults setInteger:1 forKey:HWDownloadMaxConcurrentCountKey];
        [defaults setBool:NO forKey:HWDownloadAllowsCellularAccessKey];
        [defaults setBool:YES forKey:onceKey];
        [defaults synchronize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self projectOnceCode];
    self.titles = @[@"文件列表", @"下载中", @"缓存"];
    // Do any additional setup after loading the view.
    CGFloat totalItemWidth = self.view.bounds.size.width - 30*2;
    self.myCategoryView = [[JXCategoryTitleView alloc] init];
    self.myCategoryView.layer.cornerRadius = 15;
    self.myCategoryView.layer.masksToBounds = YES;
    self.myCategoryView.layer.borderColor = [UIColor blueColor].CGColor;
    self.myCategoryView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.cellWidth = totalItemWidth/self.titles.count;
    self.myCategoryView.titleColor = [UIColor blueColor];
    self.myCategoryView.titleSelectedColor = [UIColor whiteColor];
    self.myCategoryView.titleLabelMaskEnabled = YES;

    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 30;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = [UIColor blueColor];
    self.myCategoryView.indicators = @[backgroundView];
    [self.nrView addSubview:self.myCategoryView];
    
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.scrollView.scrollEnabled = NO;
    [self.nrView addSubview:self.listContainerView];
    // 关联到 categoryView
    self.myCategoryView.listContainer = self.listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat totalItemWidth = self.nrView.width - 30*2;
    self.myCategoryView.frame = CGRectMake(30, 10, totalItemWidth, 30);
    self.listContainerView.frame = CGRectMake(0, 50, self.nrView.width, self.nrView.height - 50);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NrBarButtonItem *rightBarButtonItem = [[NrBarButtonItem alloc] initWithTitle:@"设置" target:self action:@selector(showDisplayOfCommonFunctions)];
    rightBarButtonItem.titleColor = [UIColor blackColor];
    self.appBar.rightBarButtonItem = rightBarButtonItem;
}

- (void)showDisplayOfCommonFunctions {
    DisplayHWSettingViewScreen *screen = [[DisplayHWSettingViewScreen alloc] init];
    [self.navigationController pushViewController:screen animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return [[DisplayHWHomeViewScreen alloc] init];
    }
    else if (index == 1) {
        return [[DisplayHWDownloadingViewScreen alloc] init];
    }
    else {
        return [[DisplayHWCacheViewScreen alloc] init];
    }    
}

@end
