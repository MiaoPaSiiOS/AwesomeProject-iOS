//
//  FeedappViewController.m
//  AmenHome
//
//  Created by zhuyuhui on 2021/6/15.
//

#import "FeedappViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <SDWebImage/SDWebImage.h>
#import "FeedappChildWeiboViewScreen.h"
#import "FeedappChildTwitterViewScreen.h"
#import "FeedappChildQQViewScreen.h"

@interface FeedappViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@end

@implementation FeedappViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Feed";
    // Do any additional setup after loading the view.
}


- (void)dsInitSubviews {
    [super dsInitSubviews];
    //JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    [self.nrView addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    //JXCategoryListContainerView
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    self.listContainerView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.nrView addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.mas_offset(44);
    }];
    // 关联到 categoryView
    self.categoryView.listContainer = self.listContainerView;

    
    self.categoryView.titles = @[@"微博",@"Twitter",@"QQ"];
    
}

#pragma mark - JXCategoryViewDelegate

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        FeedappChildWeiboViewScreen *child = [[FeedappChildWeiboViewScreen alloc] init];
        return child;
    } else if (index == 1) {
        FeedappChildTwitterViewScreen *child = [[FeedappChildTwitterViewScreen alloc] init];
        return child;
    } else {
        FeedappChildQQViewScreen *child = [[FeedappChildQQViewScreen alloc] init];
        return child;
    }
    return nil;
}

@end
