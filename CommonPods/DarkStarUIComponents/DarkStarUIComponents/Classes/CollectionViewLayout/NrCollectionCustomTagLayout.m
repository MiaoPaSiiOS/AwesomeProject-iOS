//
//  NrCollectionCustomTagLayout.m
//  BankOfCommunications
//
//  Created by zhuyuhui on 2022/5/26.
//  Copyright © 2022 P&C Information. All rights reserved.
//

#import "NrCollectionCustomTagLayout.h"

@interface NrCollectionCustomTagLayout()
// 可见区域
@property(nonatomic, strong) NSMutableArray *visibleLayoutAttributes;
@property(nonatomic, strong) NSMutableArray *headerFooterLayoutAttributes;
// 内容高度
@property(nonatomic, assign) CGFloat contentHeight;
@end
 
@implementation NrCollectionCustomTagLayout
#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemHeight = 25;
        self.contentAlignment = NrTagContentAlignmentLeft;
        
        self.visibleLayoutAttributes = [NSMutableArray array];
        self.headerFooterLayoutAttributes = [NSMutableArray array];
        self.contentHeight = 0;
    }
    return self;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新

- (void)prepareLayout {
    [super prepareLayout];
    if (!self.collectionView || !self.delegate) {
        return;
    }
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    NSInteger sections = self.collectionView.numberOfSections;
    self.contentHeight = 0;
    [self.visibleLayoutAttributes removeAllObjects];
    [self.headerFooterLayoutAttributes removeAllObjects];

    for (NSInteger section = 0; section < sections; section++) {
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionIndexPath];
        //head
        CGSize sectionHeadSize = [self.delegate NrCollectionCustomTagLayout:self sizeForSupplementaryElementOfKind:UICollectionElementKindSectionHeader section:section];
        CGFloat sectionOriginY = self.contentHeight;
        CGRect sectionHeaderFrame = CGRectMake(0, sectionOriginY, sectionHeadSize.width, sectionHeadSize.height);
        headerAttribute.frame = sectionHeaderFrame;
        [self.headerFooterLayoutAttributes addObject:headerAttribute];
        
        self.contentHeight += sectionHeadSize.height + self.sectionInset.top;
        
        
        // 处理tag
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        CGRect frame = CGRectMake(0, self.contentHeight, 0, 0);
        CGFloat contentWidthInRow = 0;
        NSMutableArray <NSIndexPath *>*indexPathsInRow = [NSMutableArray array];
        
        
        for (NSInteger item = 0; item < rows; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat tagWidth = [self.delegate NrCollectionCustomTagLayout:self tagWidthForItemAt:indexPath];
                                    
            if (self.contentAlignment == NrTagContentAlignmentLeft) {
                // 判断是否会超出
                CGFloat spaceArea = CGRectGetMaxX(frame) + self.minimumInteritemSpacing + tagWidth + self.sectionInset.right;
                if (spaceArea > collectionViewW) {// 需要换行
                    [indexPathsInRow removeAllObjects];
                    frame = CGRectMake(self.sectionInset.left, CGRectGetMaxY(frame) + self.minimumLineSpacing, tagWidth, self.itemHeight);
                    contentWidthInRow = CGRectGetMaxX(frame);
                } else {
                    if (contentWidthInRow == 0) {
                        frame = CGRectMake(self.sectionInset.left, frame.origin.y, tagWidth, self.itemHeight);
                    } else {
                        frame = CGRectMake(CGRectGetMaxX(frame) + self.minimumInteritemSpacing, frame.origin.y, tagWidth, self.itemHeight);
                    }
                    contentWidthInRow = CGRectGetMaxX(frame);
                }
            } else {
                // 判断是否会超出
                CGFloat spaceArea = CGRectGetMinX(frame) - self.minimumInteritemSpacing - tagWidth - self.sectionInset.left;
                if (spaceArea < 0) {// 需要换行
                    [indexPathsInRow removeAllObjects];
                    frame = CGRectMake(collectionViewW - self.sectionInset.right - tagWidth, CGRectGetMaxY(frame) + self.minimumLineSpacing, tagWidth, self.itemHeight);
                    contentWidthInRow = CGRectGetMinX(frame);
                } else {
                    if (contentWidthInRow == 0) {
                        frame = CGRectMake(collectionViewW - self.sectionInset.right - tagWidth, frame.origin.y, tagWidth, self.itemHeight);
                    } else {
                        frame = CGRectMake(CGRectGetMinX(frame) - self.minimumInteritemSpacing - tagWidth, frame.origin.y, tagWidth, self.itemHeight);
                    }
                    contentWidthInRow = CGRectGetMinX(frame);
                }
            }
            
            [indexPathsInRow addObject:indexPath];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = frame;
            
            //移除之前的
            for (UICollectionViewLayoutAttributes *attr in self.visibleLayoutAttributes) {
                if (attr.indexPath == indexPath) {
                    [self.visibleLayoutAttributes removeObject:attr];
                }
            }
            [self.visibleLayoutAttributes addObject:attributes];
        }
        
        if (indexPathsInRow.count) {// 最后一行重设frame
            contentWidthInRow = 0;
            [indexPathsInRow removeAllObjects];
        }
        
        self.contentHeight = CGRectGetMaxY(frame);

        
        
        //footer
        CGSize sectionFooterSize = [self.delegate NrCollectionCustomTagLayout:self sizeForSupplementaryElementOfKind:UICollectionElementKindSectionFooter section:section];
        CGFloat sectionFooterOriginY = self.contentHeight;
        CGRect sectionFooterFrame = CGRectMake(0, sectionFooterOriginY, sectionFooterSize.width, sectionFooterSize.height);
        UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionIndexPath];
        footerAttribute.frame = sectionFooterFrame;
        [self.headerFooterLayoutAttributes addObject:footerAttribute];
        
        self.contentHeight += self.sectionInset.bottom + sectionFooterSize.height;
    }
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize {
     CGFloat width = self.collectionView.frame.size.width;
     return CGSizeMake(width, self.contentHeight);
}

#pragma mark - 处理所有的Item的layoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *mutArray = [NSMutableArray array];
    [mutArray addObjectsFromArray:self.visibleLayoutAttributes];
    [mutArray addObjectsFromArray:self.headerFooterLayoutAttributes];
     return mutArray;
}

#pragma mark - 处理单个的Item的layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attr in self.visibleLayoutAttributes) {
        if (attr.indexPath == indexPath) {
            return attr;
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attr in self.headerFooterLayoutAttributes) {
        if (attr.indexPath == indexPath && [attr.representedElementKind isEqualToString:elementKind]) {
            return attr;
        }
    }
    return nil;
}


@end
