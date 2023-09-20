
#import "SectionCardDecorationCollectionViewLayout.h"

@interface SectionCardDecorationCollectionViewLayout()
//保存所有自定义的section背景的布局属性
@property(nonatomic, strong) NSMutableDictionary <NSNumber *,UICollectionViewLayoutAttributes*>*cardDecorationViewAttrs;
@property(nonatomic, strong) NSMutableDictionary <NSNumber *,UICollectionViewLayoutAttributes*>*armbandDecorationViewAttrs;
@end

@implementation SectionCardDecorationCollectionViewLayout
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
    self.armbandDecorationViewAttrs = [NSMutableDictionary dictionary];
    //注册DecorationView
    [self registerClass:SectionCardDecorationReusableView.class forDecorationViewOfKind:@"SectionCardDecorationViewKind"];
    [self registerClass:SectionCardArmbandDecorationReusableView.class forDecorationViewOfKind:@"SectionCardArmbandDecorationViewKind"];
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
    [self.armbandDecorationViewAttrs removeAllObjects];
    
    //分别计算每个section的装饰视图的布局属性
    for (NSInteger section = 0; section < numberOfSections; section++) {
        //获取该section下第一个，以及最后一个item的布局属性
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];;
        if (!(numberOfItems > 0 && firstItem && lastItem)) {
            continue;
        }
        //获取该section的内边距
        UIEdgeInsets sectionInset = self.sectionInset;
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
            sectionFrame.size.height = self.collectionView.frame.size.height;
        } else {
            sectionFrame.origin.x = sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            sectionFrame.size.width = self.collectionView.frame.size.width;
            sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
        }

        // 想判断卡片是否可见
        BOOL cardDisplayed = [self.decorationDelegate collectionView:self.collectionView layout:self armbandDecorationDisplayedForSectionAt:section];
        if (!cardDisplayed) {
            continue;
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
        SectionCardDecorationCollectionViewLayoutAttributes *cardAttr = [SectionCardDecorationCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"SectionCardDecorationViewKind" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        cardAttr.frame = cardDecorationFrame;
       
        // zIndex用于设置front-to-back层级；值越大，优先布局在上层；cell的zIndex为0
        cardAttr.zIndex = -1;
        //通过代理方法获取该section卡片装饰图使用的颜色
        SectionCardModel *sectionCardModel = [self.decorationDelegate collectionView:self.collectionView layout:self decorationColorForSectionAt:section];
        cardAttr.sectionCardModel = sectionCardModel;

        //将该section的卡片装饰图的布局属性保存起来
        self.cardDecorationViewAttrs[[NSNumber numberWithInteger:section]] = cardAttr;


        
        // 先判断袖标是否可见
        BOOL armbandDisplayed = [self.decorationDelegate collectionView:self.collectionView layout:self armbandDecorationDisplayedForSectionAt:section];
        if (!armbandDisplayed) {
            continue;
        }

        // 如果袖标图片名称为nil，就跳过
        NSString *armbandImageName = [self.decorationDelegate collectionView:self.collectionView layout:self armbandDecorationImageForSectionAt:section];
        if (!armbandImageName) {
            continue;
        }
        
        // 计算袖标装饰图的属性
        UIEdgeInsets armbandDecorationInset = cardDecorationInset;
        armbandDecorationInset.left = 1;
        armbandDecorationInset.top = 18;
        if ([self.decorationDelegate respondsToSelector:@selector(collectionView:layout:armbandDecorationTopOffsetForSectionAt:)]) {
            armbandDecorationInset.top = [self.decorationDelegate collectionView:self.collectionView layout:self armbandDecorationTopOffsetForSectionAt:section];
        }
        //计算得到armbandDecoration该实际的尺寸
        CGRect armbandDecorationFrame = sectionFrame;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            armbandDecorationFrame.origin.x = sectionFrame.origin.x + armbandDecorationInset.left;
            armbandDecorationFrame.origin.y = armbandDecorationInset.top;
        } else {
            armbandDecorationFrame.origin.x = armbandDecorationInset.left;
            armbandDecorationFrame.origin.y = sectionFrame.origin.y + armbandDecorationInset.top;
        }
        armbandDecorationFrame.size.width = 80;
        armbandDecorationFrame.size.height = 53;
        

        // 根据上面的结果计算袖标装饰视图的布局属性
        SectionCardArmbandDecorationCollectionViewLayoutAttributes *armbandAttr = [SectionCardArmbandDecorationCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"SectionCardArmbandDecorationViewKind" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        armbandAttr.frame = armbandDecorationFrame;
        armbandAttr.zIndex = 1;
        armbandAttr.imageName = armbandImageName;
        //将该section的袖标装饰视图的布局属性保存起来
        self.armbandDecorationViewAttrs[[NSNumber numberWithInteger:section]] = armbandAttr;

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
    
    for (UICollectionViewLayoutAttributes *attributes in self.armbandDecorationViewAttrs.allValues) {
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
    } else if ([elementKind isEqualToString:@"SectionCardArmbandDecorationViewKind"]) {
        return self.armbandDecorationViewAttrs[[NSNumber numberWithInteger:section]];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}
@end
