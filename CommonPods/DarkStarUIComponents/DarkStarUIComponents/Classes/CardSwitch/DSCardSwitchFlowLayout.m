//
//  DSCardSwitchFlowLayout.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/16.
//

#import "DSCardSwitchFlowLayout.h"
@interface DSCardSwitchFlowLayout()
@property(nonatomic, assign) CGFloat k;
@property(nonatomic, assign) CGFloat b;
@property(nonatomic, assign) CGPoint lastOffset;
@end

@implementation DSCardSwitchFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dragMiniDistance = 30.f;//最小滚动距离
        self.lastOffset = CGPointZero;
    }
    return self;
}
#pragma mark 数据处理 
- (CGFloat)cardWidthScale {
    if ([self.delegate respondsToSelector:@selector(cardMaxWidthScaleInCardSwitchFlowLayout:)]) {
        return [self.delegate cardMaxWidthScaleInCardSwitchFlowLayout:self];
    } else {
        return 0.8f;
    }
}

- (CGFloat)cardHeightScale {
    if ([self.delegate respondsToSelector:@selector(cardMaxHeightScaleInCardSwitchFlowLayout:)]) {
        return [self.delegate cardMaxHeightScaleInCardSwitchFlowLayout:self];
    } else {
        return 0.8f;
    }
}

- (CGFloat)cardItemSpacing {
    if ([self.delegate respondsToSelector:@selector(cardItemSpacingInCardSwitchFlowLayout:)]) {
        return [self.delegate cardItemSpacingInCardSwitchFlowLayout:self];
    } else {
        return 0;
    }
}


//卡片宽度
- (CGFloat)cellMaxWidth {
    return self.collectionView.bounds.size.width * [self cardWidthScale];
}
//卡片高度
- (CGFloat)cellMaxHeight {
    return self.collectionView.bounds.size.height * [self cardHeightScale];
}

//设置左右缩进
- (CGFloat)insetX {
    CGFloat insetX = (self.collectionView.bounds.size.width - [self cellMaxWidth])/2.0f;
    return insetX;
}

- (CGFloat)insetY {
    CGFloat insetY = (self.collectionView.bounds.size.height - [self cellMaxHeight])/2.0f;
    return insetY;
}


#pragma mark - 函数计算 y = kx + b
// 获取斜率k
CGFloat calculateSlope(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    if (x2 == x1) {
        return 0;
    }
    return (y2 - y1) / (x2 - x1);
}
// 获取截距b
CGFloat calculateConstant(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    if (x2 == x1) {
        return 0;
    }
    return (y1*(x2 - x1) - x1*(y2 - y1)) / (x2 - x1);
}

#pragma mark - 初始化
- (void)prepareLayout {
    [super prepareLayout];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;//快速减速（降低视图滚动速度）
    self.collectionView.pagingEnabled = NO;//要禁用原有分页效果
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake([self insetY], [self insetX], [self insetY], [self insetX]);
    self.itemSize = CGSizeMake([self cellMaxWidth], [self cellMaxHeight]);
    self.minimumLineSpacing = [self cardItemSpacing];
    
    CGPoint pointA = CGPointMake(0.25, 1.0);
    CGPoint pointB = CGPointMake(1.0, [self cardWidthScale]);
    CGFloat x1 = pointA.x; CGFloat y1 = pointA.y;
    CGFloat x2 = pointB.x; CGFloat y2 = pointB.y;
    self.k = calculateSlope(x1, y1, x2, y2);
    self.b = calculateConstant(x1, y1, x2, y2);
}

/**
 * 决定cell的布局属性「设置缩放动画」
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1.获取该范围内的布局数组
    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];
    // 2.计算出整体中心点的 x 坐标
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
    //最大移动距离，计算范围是移动出屏幕前的距离
    CGFloat maxApart = (self.collectionView.bounds.size.width + [self cellMaxWidth])/2.0f;

    // 3.根据当前的滚动，对每个 cell 进行相应的缩放
    for (UICollectionViewLayoutAttributes *attributes in attributesArr) {
        //获取cell中心和屏幕中心的距离
        CGFloat apart = fabs(attributes.center.x - centerX);
        //移动进度 -1~0~1
        CGFloat progress = apart/maxApart;
//        //在屏幕外的cell不处理
//        if (fabs(progress) > 1) {continue;}
//        //根据余弦函数，弧度在 -π/4 到 π/4,即 scale在 √2/2~1~√2/2 间变化
//        CGFloat scaleValue = fabs(cos(progress * M_PI/4));
//        //缩放大小
//        attributes.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        
        /*
         实现思路 1 ：
         ComplexLineLayout.png
         */
        CGFloat scaleValue = 0;
        CGFloat maxScaleValue = 1.f;
        CGFloat minScaleValue = [self cardWidthScale];
        if (progress <= 0.25f) {
            scaleValue = maxScaleValue;
        } else if (progress <= 1.f) {
            scaleValue = self.k * progress + self.b;
        } else {
            scaleValue = minScaleValue;
        }
        //缩放大小
        attributes.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        //更新中间位
        if (apart <= [self cellMaxWidth]/2.0f) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardFlowLayout:didScrollToIndexPath:)]) {
                [self.delegate cardFlowLayout:self didScrollToIndexPath:attributes.indexPath];
            }
        }
    }
    return attributesArr;
}

#pragma mark -
#pragma mark 配置方法
//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
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
