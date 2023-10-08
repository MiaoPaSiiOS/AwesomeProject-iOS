//
//  SDMajletViewCollectionViewFlowLayout.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/11.
//

#import "SDMajletViewCollectionViewFlowLayout.h"
#import "SDMajletViewSectionDecorationReusableView.h"
@interface SDMajletViewCollectionViewFlowLayout()
//保存所有自定义的section背景的布局属性
@property(nonatomic, strong) NSMutableDictionary <NSNumber *,UICollectionViewLayoutAttributes*>*cardDecorationViewAttrs;

@end

@implementation SDMajletViewCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

//初始化时进行一些注册操作
- (void)setup {
    self.cardDecorationViewAttrs = [NSMutableDictionary dictionary];
    //注册DecorationView
    [self registerClass:SDMajletViewSectionDecorationReusableView.class forDecorationViewOfKind:@"SectionCardDecorationViewKind"];
}
#pragma mark - 初始化
-(void)prepareLayout {
    [super prepareLayout];
    // 如果collectionView当前没有分区，则直接退出
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }
    
    // 不存在cardDecorationDelegate就退出
    if (!self.decorationDelegate) {
        return;
    }

    // 删除旧的装饰视图的布局数据
    [self.cardDecorationViewAttrs removeAllObjects];
    
    //分别计算每个section的装饰视图的布局属性
    for (NSInteger section = 0; section < numberOfSections; section++) {
        //获取该section下第一个，以及最后一个item的布局属性
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes *firstItem;
        UICollectionViewLayoutAttributes *lastItem;
        if (numberOfItems != 0) {
            firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];
        }
        
        if (!(numberOfItems > 0 && firstItem && lastItem)) {
            continue;
        }
        //获取该section的内边距
        UIEdgeInsets sectionInset = self.sectionInset;
        UIEdgeInsets contentInset = self.collectionView.contentInset;
        if ([self.decorationDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [self.decorationDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        //计算得到该section实际的位置
        CGRect sectionFrame = CGRectZero;
        sectionFrame.origin.x = MIN(firstItem.frame.origin.x, lastItem.frame.origin.x);
        sectionFrame.origin.y = MIN(firstItem.frame.origin.y, lastItem.frame.origin.y);
        sectionFrame.size.width = MAX(CGRectGetMaxX(firstItem.frame), CGRectGetMaxX(lastItem.frame))-sectionFrame.origin.x;
        sectionFrame.size.height = MAX(CGRectGetMaxY(firstItem.frame), CGRectGetMaxY(lastItem.frame))-sectionFrame.origin.y;
        /*
         (lldb) po firstItem.frame
         (origin = (x = 15, y = 15), size = (width = 384, height = 50))

         (lldb) po lastItem.frame
         (origin = (x = 15, y = 235), size = (width = 384, height = 50))

         (lldb) po sectionFrame
         (origin = (x = 15, y = 15), size = (width = 384, height = 50))

         (lldb)
         */
        //计算得到该section实际的尺寸
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y = sectionInset.top;
            sectionFrame.size.width += sectionInset.left + sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height - contentInset.top - contentInset.bottom;
        } else {
            sectionFrame.origin.x = sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            sectionFrame.size.width = self.collectionView.frame.size.width - contentInset.left - contentInset.right;
            sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
        }


        // 计算卡片装饰图的属性
        UIEdgeInsets cardDecorationInset = [self.decorationDelegate collectionView:self.collectionView layout:self decorationInsetForSectionAt:section];
        //计算得到cardDecoration该实际的尺寸
        CGRect cardDecorationFrame = sectionFrame;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            cardDecorationFrame.origin.x = sectionFrame.origin.x + cardDecorationInset.left;
            cardDecorationFrame.origin.y = cardDecorationInset.top;
        } else {
            cardDecorationFrame.origin.x = cardDecorationInset.left;
            cardDecorationFrame.origin.y = sectionFrame.origin.y + cardDecorationInset.top;
        }
        cardDecorationFrame.size.width = sectionFrame.size.width - (cardDecorationInset.left + cardDecorationInset.right);
        cardDecorationFrame.size.height = sectionFrame.size.height - (cardDecorationInset.top + cardDecorationInset.bottom);
        
        //根据上面的结果计算卡片装饰图的布局属性
        SDMajletViewSectionCardDecorationCollectionViewLayoutAttributes *cardAttr = [SDMajletViewSectionCardDecorationCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"SectionCardDecorationViewKind" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        cardAttr.frame = cardDecorationFrame;
       
        // zIndex用于设置front-to-back层级；值越大，优先布局在上层；cell的zIndex为0
        cardAttr.zIndex = -1;
        //通过代理方法获取该section卡片装饰图使用的颜色
        UIColor *backgroundColor = [self.decorationDelegate collectionView:self.collectionView layout:self decorationColorForSectionAt:section];
        cardAttr.backgroundColor = backgroundColor;

        //将该section的卡片装饰图的布局属性保存起来
        self.cardDecorationViewAttrs[[NSNumber numberWithInteger:section]] = cardAttr;


    }
}

//返回rect范围下父类的所有元素的布局属性以及子类自定义装饰视图的布局属性
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //获取cell的布局
    NSMutableArray *attributesMuArr = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    for (UICollectionViewLayoutAttributes *attributes in self.cardDecorationViewAttrs.allValues) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesMuArr addObject:attributes];
        }
    }
    return attributesMuArr.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if ([elementKind isEqualToString:@"SectionCardDecorationViewKind"]) {
        return self.cardDecorationViewAttrs[[NSNumber numberWithInteger:section]];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}
@end
