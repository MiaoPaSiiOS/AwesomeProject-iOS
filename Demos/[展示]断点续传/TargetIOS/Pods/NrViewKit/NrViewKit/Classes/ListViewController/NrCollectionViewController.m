//
//  NrCollectionViewController.m
//  NrViewController
//
//  Created by zhuyuhui on 2021/11/11.
//

#import "NrCollectionViewController.h"

@interface NrCollectionViewController ()

@end

@implementation NrCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)nrInitSubviews {
    [super nrInitSubviews];
    [self createTableView];
    self.enableFooterRefresh = NO;
    self.enableHeaderRefresh = NO;
}

- (void)createTableView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self createTableViewWithFrame:self.nrView.bounds layout:layout];
}

- (void)createTableViewWithFrame:(CGRect)frame layout:(UICollectionViewLayout *)layout {
    [self createTableView:UICollectionView.class withFrame:frame layout:layout];
}

- (void)createTableView:(Class)viewClass withFrame:(CGRect)frame layout:(UICollectionViewLayout *)layout{
    [self.recylerView removeFromSuperview];
    self.recylerView = nil;
    self.recylerView = [self preferredRecylerView:viewClass withFrame:frame collectionViewLayout:layout];
    [self setEnableFooterRefresh:self.enableFooterRefresh];
    [self setEnableHeaderRefresh:self.enableHeaderRefresh];
    [self.nrView addSubview:self.recylerView];
    [self.recylerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
}

#pragma mark - 刷新
- (void)setEnableHeaderRefresh:(BOOL)enableHeaderRefresh {
    _enableHeaderRefresh = enableHeaderRefresh;
    if (enableHeaderRefresh) {
        kWeakSelf
        self.recylerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            kStrongSelf
            [strongSelf headerRefreshAction];
        }];
    } else {
        self.recylerView.mj_header = nil;
    }
}

- (void)setEnableFooterRefresh:(BOOL)enableFooterRefresh {
    _enableFooterRefresh = enableFooterRefresh;
    if (enableFooterRefresh) {
        kWeakSelf
        self.recylerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            kStrongSelf
            [strongSelf footerRefreshAction];
        }];
    } else {
        self.recylerView.mj_footer = nil;
    }
}

- (void)setEnableRefresh:(BOOL)enableRefresh {
    _enableRefresh = enableRefresh;
    self.enableHeaderRefresh = enableRefresh;
    self.enableFooterRefresh = enableRefresh;
}

- (void)footerRefreshAction {
    
}

- (void)headerRefreshAction {
    
}

- (void)startRefresh {
    [self.recylerView.mj_header beginRefreshing];
}

- (void)stopRefresh {
    [self.recylerView.mj_header endRefreshing];
    [self.recylerView.mj_footer endRefreshing];
}

- (BOOL)isRefreshing {
    if ([self.recylerView.mj_header isRefreshing]) {
        return YES;
    }
    if ([self.recylerView.mj_footer isRefreshing]) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (UICollectionView *)preferredRecylerView:(Class)viewClass withFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionView *recylerView = [[viewClass alloc] initWithFrame:frame collectionViewLayout:layout];
    recylerView.backgroundColor = [UIColor clearColor];
    recylerView.showsVerticalScrollIndicator = NO;
    recylerView.showsHorizontalScrollIndicator = NO;
    recylerView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    recylerView.delegate = self;
    recylerView.dataSource = self;
    [recylerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    return recylerView;
}


- (UICollectionViewLayout *)preferredRecylerViewLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return layout;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end
