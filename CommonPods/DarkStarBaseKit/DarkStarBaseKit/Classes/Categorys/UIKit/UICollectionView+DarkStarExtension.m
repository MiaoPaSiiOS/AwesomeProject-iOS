//
//  UICollectionView+DarkStarExtension.m
//  AmenJDappKit
//
//  Created by zhuyuhui on 2022/2/12.
//

#import "UICollectionView+DarkStarExtension.h"
#import <objc/runtime.h>
#import "UIView+DarkStarFrame.h"

static const NSString *kCollectionHeaderViewKey = @"lt_collectionHeaderView";
static const NSString *kCollectionFooterViewKey = @"lt_collectionFooterView";

static const NSString *kCollectionHeaderViewOffsetKey = @"lt_collectionHeaderViewOffset";
static const NSString *kCollectionFooterViewOffsetKey = @"lt_collectionFooterViewOffset";

@implementation UICollectionView (DarkStarExtension)
#pragma mark - < 页眉 >

/**
 设置页眉 - set方法
 */
- (void)setLt_collectionHeaderView:(UIView *)lt_collectionHeaderView
{
    UIView *headerView = self.lt_collectionHeaderView;
    if (headerView != lt_collectionHeaderView) {
        // 获取内边距
        UIEdgeInsets contentInset = self.contentInset;
        
        // 移除之前的lt_collectionHeaderView
        contentInset.top -= headerView.frame.size.height;
        [headerView removeFromSuperview];
        
        // 设置内边距
        contentInset.top += lt_collectionHeaderView.height;
        self.contentInset = contentInset;
        
        // 添加lt_collectionHeaderView
//        [self insertSubview:lt_collectionHeaderView atIndex:0];
        [self addSubview:lt_collectionHeaderView];
        
        objc_setAssociatedObject(self, &(kCollectionHeaderViewKey), lt_collectionHeaderView, OBJC_ASSOCIATION_ASSIGN);
    }
}

/**
 获取页眉 - get方法
 */
- (UIView *)lt_collectionHeaderView
{
    return objc_getAssociatedObject(self, &(kCollectionHeaderViewKey));
}

#pragma mark - < 页脚 >

/**
 设置页脚 - set方法
 */
- (void)setLt_collectionFooterView:(UIView *)lt_collectionFooterView
{
    UIView *footerView = self.lt_collectionFooterView;
    
    if (footerView != lt_collectionFooterView) {
        // 获取内边距
        UIEdgeInsets contentInset = self.contentInset;
        
        // 移除之前的
        contentInset.bottom -= footerView.height;
        [footerView removeFromSuperview];
        
        // 设置内边距
        contentInset.bottom += lt_collectionFooterView.height;
        self.contentInset= contentInset;
        
        // 添加页脚
        [self addSubview:lt_collectionFooterView];
        
        objc_setAssociatedObject(self, &(kCollectionFooterViewKey), lt_collectionFooterView, OBJC_ASSOCIATION_ASSIGN);
    }
}

/**
 获取页脚 - get方法
 */
- (UIView *)lt_collectionFooterView
{
    return objc_getAssociatedObject(self, &(kCollectionFooterViewKey));
}

#pragma mark - < 页眉偏移量 >

- (void)setLt_collectionHeaderViewOffset:(CGFloat)lt_collectionHeaderViewOffset
{
    objc_setAssociatedObject(self, &(kCollectionHeaderViewOffsetKey), @(lt_collectionHeaderViewOffset), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsLayout];
}

- (CGFloat)lt_collectionHeaderViewOffset
{
    NSNumber *number = objc_getAssociatedObject(self, &(kCollectionHeaderViewOffsetKey));
    return number.floatValue;
}

#pragma mark - < 页脚偏移量 >

- (void)setLt_collectionFooterViewOffset:(CGFloat)lt_collectionFooterViewOffset
{
    objc_setAssociatedObject(self, &(kCollectionFooterViewOffsetKey), @(lt_collectionFooterViewOffset), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsLayout];
}

- (CGFloat)lt_collectionFooterViewOffset
{
    NSNumber *number = objc_getAssociatedObject(self, &(kCollectionFooterViewOffsetKey));
    return number.floatValue;
}

#pragma mark - < 交换方法 >

/**
 加载过程中, 交换方法
 */
+ (void)load
{
    Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method lt_layoutSubviews = class_getInstanceMethod(self, @selector(lt_layoutSubviews));
    method_exchangeImplementations(layoutSubviews, lt_layoutSubviews);
}

/**
 加载过程中, 交换方法
 */
- (void)lt_layoutSubviews
{
    [self lt_layoutSubviews];
    UIView *lt_collectionHeaderView = self.lt_collectionHeaderView;
    lt_collectionHeaderView.top = -lt_collectionHeaderView.height - self.lt_collectionHeaderViewOffset;
    self.lt_collectionFooterView.top = self.contentSize.height + self.lt_collectionFooterViewOffset;
}
@end
