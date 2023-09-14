//
//  NrCardSwitch.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/16.
//

#import "NrCardSwitch.h"
#import "NrCardSwitchFlowLayout.h"

@interface NrCardSwitch ()<UICollectionViewDelegate,UICollectionViewDataSource,NrCardSwitchFlowLayoutDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NrCardSwitchFlowLayout *flowLayout;

@end

@implementation NrCardSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}


- (void)initialization
{
    _cardWidthScale = 0.8;// 居中卡片宽度与据屏幕宽度比例
    _cardHeightScale = 0.8;// 居中卡片高度与据屏幕宽度比例
    _cardItemSpacing = 0;// 相邻卡片间距
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    self.flowLayout = [[NrCardSwitchFlowLayout alloc] init];
    self.flowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.userInteractionEnabled = true;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"default-cell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
}

#pragma mark -
#pragma mark - properties
- (void)setModels:(NSArray *)models {
    _models = models;
    [self.collectionView reloadData];
}

- (void)setCardWidthScale:(CGFloat)cardWidthScale {
    _cardWidthScale = cardWidthScale;
    [self.collectionView reloadData];
}

- (void)setCardHeightScale:(CGFloat)cardHeightScale {
    _cardHeightScale = cardHeightScale;
    [self.collectionView reloadData];
}

- (void)setCardItemSpacing:(CGFloat)cardItemSpacing {
    _cardItemSpacing = cardItemSpacing;
    [self.collectionView reloadData];
}
#pragma mark -
#pragma mark CollectionDelegate
//滚动到中间
- (void)scrollToCenterAnimated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self scrollToCenterAnimated:YES];
    [self performClickDelegateMethod];
}

#pragma mark -
#pragma mark -NrCardSwitchFlowLayout
- (CGFloat)cardMaxWidthScaleInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout {
    return self.cardWidthScale;
}

- (CGFloat)cardMaxHeightScaleInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout {
    return self.cardHeightScale;
}

- (CGFloat)cardItemSpacingInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout {
    return self.cardItemSpacing;
}

- (void)cardFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout didScrollToIndexPath:(NSIndexPath *)indexPath {
    [self updateSelectedIndex:indexPath];
}

- (void)updateSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.row != _selectedIndex) {
        _selectedIndex = indexPath.row;
        [self performScrollDelegateMethod];
    }
}

#pragma mark -
#pragma mark CollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    UICollectionViewCell* cardCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"default-cell" forIndexPath:indexPath];
    return cardCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollView.contentOffset.x %f",scrollView.contentOffset.x);
}
#pragma mark -
#pragma mark 功能方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [self scrollToCenterAnimated:animated];
}

- (void)performClickDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidClickAtIndex:)]) {
        [_delegate cardSwitchDidClickAtIndex:_selectedIndex];
    }
}

- (void)performScrollDelegateMethod {
    if ([_delegate respondsToSelector:@selector(cardSwitchDidScrollToIndex:)]) {
        [_delegate cardSwitchDidScrollToIndex:_selectedIndex];
    }
}

@end
