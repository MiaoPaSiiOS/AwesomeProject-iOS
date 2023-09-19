//
//  DSGridView.m
//  CRJCollectionGridView
//
//  Created by zhuyuhui on 2020/9/7.
//

#import "DSGridView.h"
#import <Masonry/Masonry.h>

@interface DSGridView () <UICollectionViewDelegate, UICollectionViewDataSource,DSGridViewLayoutDelegate>
@end

@implementation DSGridView

#pragma mark - Init
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.horizontalCellCount = 3;
        
        // Init UICollectionViewFlowLayout.
        self.flowLayout = [[DSGridViewLayout alloc] init];
        self.flowLayout.delegate = self;
        // Init UICollectionView.
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator   = NO;
        self.collectionView.backgroundColor                = [UIColor clearColor];
        self.collectionView.delegate                       = self;
        self.collectionView.dataSource                     = self;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}

#pragma mark - Reload data.
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - DSGridViewLayoutDelegate
- (CGSize)DSGridViewLayout:(DSGridViewLayout *)layout sizeForSupplementaryElementOfKind:(NSString *)kind section:(NSInteger)section {
    return CGSizeZero;
}

- (CGFloat)DSGridViewLayout:(DSGridViewLayout *)layout widthForItemAt:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(DSGridView:widthForItemAt:)]) {
        return [self.dataSource DSGridView:self widthForItemAt:indexPath];
    }
    CGFloat width = self.collectionView.frame.size.width;
    width -= layout.contentEdgeInsets.left + layout.contentEdgeInsets.right;
    width -= layout.sectionInset.left + layout.sectionInset.right;
    width -= layout.minimumInteritemSpacing * (self.horizontalCellCount - 1);
    CGFloat orignalItemWidth = width / self.horizontalCellCount;
    return orignalItemWidth;
}


#pragma mark - UICollectionView's delegate & data source.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInDSGridView:)]) {
        return [self.dataSource numberOfSectionsInDSGridView:self];
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(DSGridView:numberOfItemsInSection:)]) {
        return [self.dataSource DSGridView:self numberOfItemsInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(DSGridView:cellForItemAtIndexPath:)]) {
        return [self.dataSource DSGridView:self cellForItemAtIndexPath:indexPath];
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DSGridView:didSelectItemAtIndexPath:)]) {
        [self.delegate DSGridView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (CGSize)contentSize {
    CGSize size = [_flowLayout collectionViewContentSize];
    size.width  += _flowLayout.contentEdgeInsets.left + _flowLayout.contentEdgeInsets.right;
    size.height += _flowLayout.contentEdgeInsets.top  + _flowLayout.contentEdgeInsets.bottom;
    return size;
}

- (void)resetSize {
    CGRect newFrame = self.frame;
    newFrame.size   = [self contentSize];
    self.frame      = newFrame;
}

@end
