//
//  NrPagingEnabledFlowLayout.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/17.
//

#import "NrPagingEnabledFlowLayout.h"

@interface NrPagingEnabledFlowLayout()
@property(nonatomic, assign) CGPoint lastOffset;

@end

@implementation NrPagingEnabledFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dragMiniDistance = 30.f;//最小滚动距离
        self.lastOffset = CGPointZero;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;//快速减速（降低视图滚动速度）
    self.collectionView.pagingEnabled = NO;//要禁用原有分页效果
}

// 这个方法的返回值，决定了 CollectionView 中止滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {

    /*
     NSInteger numberOfItems = 5;
     
     self.collectionView.contentSize.width = 1860;
     self.itemSize.width = 364;
     self.minimumLineSpacing = 5;
     self.sectionInset.left = 10;
     self.sectionInset.right = 10;
     */
    
    //可滚动范围
    CGFloat offsetMax = self.collectionView.contentSize.width - self.sectionInset.right - self.itemSize.width - self.minimumLineSpacing - (self.collectionView.frame.size.width - self.sectionInset.right - self.itemSize.width - self.minimumLineSpacing);;
    CGFloat offsetMin = 0;
    // 修改以前记录的位置，若是小于最小的contentsize或者最大的contentsize则重置值
    if (self.lastOffset.x < offsetMin) {
        self.lastOffset = CGPointSetX(self.lastOffset, offsetMin);
    } else if (self.lastOffset.x > offsetMax){
        self.lastOffset = CGPointSetX(self.lastOffset, offsetMax);
    }
    // 目标位移点距离当前点距离的绝对值
    CGFloat offsetForCurrentPointX = fabs(proposedContentOffset.x - self.lastOffset.x);

    // 判断当前滑动方向，向左 true, 向右 fasle
    BOOL direction = (proposedContentOffset.x - self.lastOffset.x) > 0;

    CGPoint newProposedContentOffset = CGPointZero;
    
    if ((offsetForCurrentPointX > self.dragMiniDistance) &&
        (self.lastOffset.x >= offsetMin) &&
        (self.lastOffset.x <= offsetMax)) {
        
        NSInteger pageFactor = 1;// 滑过的cell数量，这里设置为1，每次只会划过一个Cell
        CGFloat pageOffsetX = 0;
        // 判断当前滑动方向，向左 true, 向右 fasle
        if (direction) {
            if (self.lastOffset.x == offsetMin) {
                pageOffsetX = [self firstCellOffsetX];
            } else {
                pageOffsetX = self.itemSize.width + self.minimumLineSpacing;
            }
        } else {
            if (self.lastOffset.x == offsetMax) {
                pageOffsetX = [self lastCellOffsetX];
            } else {
                pageOffsetX = self.itemSize.width + self.minimumLineSpacing;
            }
        }
        pageOffsetX = pageOffsetX * (CGFloat)(pageFactor);
        newProposedContentOffset = CGPointMake(self.lastOffset.x + (direction ? pageOffsetX : -pageOffsetX), proposedContentOffset.y);
        if (newProposedContentOffset.x < offsetMin) {//newProposedContentOffset.x可能为负数
            newProposedContentOffset = CGPointSetX(newProposedContentOffset, offsetMin);
        }
    } else {
        // 滚动距离小于翻页步距，则不进行翻页
        newProposedContentOffset = CGPointMake(self.lastOffset.x, self.lastOffset.y);
    }
    
    self.lastOffset = CGPointSetX(self.lastOffset, newProposedContentOffset.x);
//    NSLog(@"self.lastOffset=%@",NSStringFromCGPoint(self.lastOffset));
    return newProposedContentOffset;
}


- (CGFloat)firstCellOffsetX {
    return self.sectionInset.left + self.itemSize.width - (self.collectionView.frame.size.width - self.itemSize.width - self.minimumLineSpacing * 2) / 2;
}

- (CGFloat)lastCellOffsetX {
    return self.sectionInset.right + self.itemSize.width - ((self.collectionView.frame.size.width - self.itemSize.width - self.minimumLineSpacing * 2) / 2);
}


CG_INLINE CGPoint CGPointSetX(CGPoint point, CGFloat x) {
    return CGPointMake(x, point.y);
}

@end

