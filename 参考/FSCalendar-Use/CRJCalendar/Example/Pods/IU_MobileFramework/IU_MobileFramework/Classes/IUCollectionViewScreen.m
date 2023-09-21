//
//  IUCollectionViewScreen.m
//  CRJKit
//
//  Created by zhuyuhui on 2020/9/15.
//

#import "IUCollectionViewScreen.h"
@interface IUCollectionViewScreen ()
@property(nonatomic, strong) IUdZNEmptyView *dZNEmptyView;
@end

@implementation IUCollectionViewScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)iuInitSubviews {
    [super iuInitSubviews];
    if (!_recylerView) {
        UICollectionView *recylerView = [self preferredRecylerView];
        [recylerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.iuView addSubview:recylerView];
        [recylerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appBar.mas_bottom);
            make.left.right.bottom.equalTo(recylerView.superview);
        }];
        self.recylerView = recylerView;
    }
}

#pragma mark - IUCollectionViewScreenProtocol
- (UICollectionView *)preferredRecylerView {
    UICollectionView *recylerView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self preferredRecylerViewLayout]];
    recylerView.backgroundColor = [UIColor clearColor];
    recylerView.delegate = self;
    recylerView.dataSource = self;
    recylerView.emptyDataSetSource = self;
    recylerView.emptyDataSetDelegate = self;
    if (@available(iOS 11.0, *)) {
        recylerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    return recylerView;
}

- (UICollectionViewLayout *)preferredRecylerViewLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return layout;
}

- (void)showDZNEmptyView {
    if (self.dZNEmptyView) {
        [self hideDZNEmptyView];
    }
    [self.iuView addSubview:self.dZNEmptyView];
    [self.dZNEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appBar.mas_bottom);
        make.left.right.bottom.equalTo(self.dZNEmptyView.superview);
    }];
}

- (void)hideDZNEmptyView {
    if (self.dZNEmptyView) {
        [self.dZNEmptyView removeFromSuperview];
        self.dZNEmptyView = nil;
    }
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    return cell;
}

///空置页
#pragma mark - DZNEmptyDataSetSource
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"empty_placeholder"];
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"Please Allow Photo Access";
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
//
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
//                                 NSParagraphStyleAttributeName: paragraph};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};

    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - getter setter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(IUdZNEmptyView *)dZNEmptyView {
    if (!_dZNEmptyView) {
        IUdZNEmptyView *emptView = [[IUdZNEmptyView alloc] initWithFrame:self.view.bounds];
        emptView.backgroundColor = [UIColor clearColor];
        emptView.recylerView.emptyDataSetSource = self;
        emptView.recylerView.emptyDataSetDelegate = self;
        _dZNEmptyView = emptView;
    }
    return _dZNEmptyView;
}

@end
