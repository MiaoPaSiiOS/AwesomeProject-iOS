//
//  DSWaterFallLayout.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/18.
//
/*
 瀑布流效果
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DSWaterFallLayout;
 
@protocol DSWaterFallLayoutDataSource<NSObject>
 
@required
/**
  * 每个item的高度
  */
- (CGFloat)DSWaterFallLayout:(DSWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;
 
@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInDSWaterFallLayout:(DSWaterFallLayout *)waterFallLayout;
 
/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInDSWaterFallLayout:(DSWaterFallLayout *)waterFallLayout;
 
/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInDSWaterFallLayout:(DSWaterFallLayout *)waterFallLayout;
 
/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetsInDSWaterFallLayout:(DSWaterFallLayout *)waterFallLayout;
 
@end
@interface DSWaterFallLayout : UICollectionViewLayout
/**
 * 代理
 */
@property (nonatomic, weak) id<DSWaterFallLayoutDataSource> delegate;

@end

NS_ASSUME_NONNULL_END
