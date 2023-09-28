
#import "CLDecorationViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SectionCardDecorationCollectionViewLayout.h"
#import "SectionCardModel.h"
#import "CardCollectionView.h"

@interface CLDecorationViewController ()<SectionCardDecorationCollectionViewLayoutDelegate>
@property(nonatomic, strong) SectionCardDecorationCollectionViewLayout *cardLayout;
@property(nonatomic, strong) NSMutableArray <SectionCardModel *>*dataSource;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) BOOL hasMore;

@end

@implementation CLDecorationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新品";
    [self nrInitSubviews];
    
    self.page = 1;
    self.hasMore = YES;
    self.dataSource = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self.recylerView.mj_header beginRefreshing];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)nrInitSubviews {
    self.cardLayout = [[SectionCardDecorationCollectionViewLayout alloc] init];
    self.cardLayout.decorationDelegate = self;
//    self.cardLayout.minimumLineSpacing = 5;
//    self.cardLayout.minimumInteritemSpacing = 0;
    [self createTableView:CardCollectionView.class withFrame:self.view.bounds layout:self.cardLayout];
    [self.recylerView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    self.enableHeaderRefresh = YES;
}

- (void)headerRefreshAction {
    self.page = 1;
    [self fetchData];
}

- (void)footerRefreshAction {
    self.page ++;
    [self fetchData];
}

#pragma mark - Net
- (void)fetchData {
    __weak __typeof(self)weakSelf = self;
    [self fetchFeedListWithPage:self.page completion:^(BOOL success, NSArray *wareInfoList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.page == 1) {
            [strongSelf.dataSource removeAllObjects];
        }
        if (success) {
            if (!wareInfoList || wareInfoList.count == 0) {
                if (strongSelf.page == 1) {//空页面
//                    [AUToast toastWithMessage:@"没有数据~~~"];
                } else {//没有更多
                }
                strongSelf.hasMore = NO;
            } else {
                [strongSelf.dataSource addObjectsFromArray:wareInfoList];
                strongSelf.hasMore = YES;
            }
            [strongSelf.recylerView reloadData];
            [strongSelf stopRefresh];
            if (strongSelf.hasMore) {
                self.enableFooterRefresh = YES;
            } else {
                [strongSelf.recylerView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (strongSelf.page == 1) {//请求失败UI
//                [AUToast toastWithMessage:@"数据请求失败~~~"];
                [strongSelf stopRefresh];
            } else {
                //没有更多
                [strongSelf.recylerView.mj_footer endRefreshingWithNoMoreData];
                strongSelf.page --;
            }
        }
    }];
}


#pragma mark - Net
- (void)fetchFeedListWithPage:(NSInteger)page
            completion:(void(^)(BOOL success, NSArray *wareInfoList))completeHandle {
    NSArray *backgroundUrls = [self backgroundUrls];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *sections = [NSMutableArray array];
            int sectionNUM = [self getRandomNumber:3 to:10];
            for (int i = 0; i < sectionNUM; i++) {
                SectionCardModel *section = [[SectionCardModel alloc] init];
//                section.backgroundColor = [DSHelper randomColor];
                section.backgroundUrl = backgroundUrls[i % backgroundUrls.count];
                NSMutableArray *warfs = [NSMutableArray array];
                for (int i = 0; i < 5; i++) {
                    [warfs addObject:@""];
                }
                section.warfs = warfs.copy;
                [sections addObject:section];
            }
            if (page > 10) {
                sections = @[].mutableCopy;
            }
            if (!sections || sections.count == 0) {
                if (completeHandle) {
                    completeHandle(NO, nil);
                }
            } else {
                if (completeHandle) {
                    completeHandle(YES, sections);
                }
            }
        });
    });
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
- (int)getRandomNumber:(int)from to:(int)to{
  return (int)(from + (arc4random() % (to - from + 1)));
}

- (NSArray *)backgroundUrls {
    return @[
        @"https://t7.baidu.com/it/u=2604797219,1573897854&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2942499027,2479446682&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3165657288,4248157545&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3240224891,3518615655&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2501476447,3743798074&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2610975262,3538281461&fm=193&f=GIF",
    ];
}


#pragma mark -
#pragma mark - SectionCardDecorationCollectionViewLayoutDelegate
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SectionCardDecorationCollectionViewLayout *)collectionViewLayout armbandDecorationDisplayedForSectionAt:(NSInteger)section {
    return YES;
}

- (nonnull NSString *)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SectionCardDecorationCollectionViewLayout *)collectionViewLayout armbandDecorationImageForSectionAt:(NSInteger)section {
    return @"armband_1";
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SectionCardDecorationCollectionViewLayout *)collectionViewLayout armbandDecorationTopOffsetForSectionAt:(NSInteger)section {
    return 18;
}

- (SectionCardModel *)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout *)collectionViewLayout decorationColorForSectionAt:(NSInteger)section {
    SectionCardModel *sectionM = self.dataSource[section];
    return sectionM;
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SectionCardDecorationCollectionViewLayout *)collectionViewLayout decorationDisplayedForSectionAt:(NSInteger)section {
    return YES;
}

- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SectionCardDecorationCollectionViewLayout *)collectionViewLayout decorationInsetForSectionAt:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 10;
        default:
            break;
    }
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.mj_w-15-15, [self getRandomNumber:44 to:100]);
}


#pragma mark -
#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SectionCardModel *sectionM = self.dataSource[section];
    return sectionM.warfs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    return cell;
}


@end
