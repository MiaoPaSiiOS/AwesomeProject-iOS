//
//  NrWaterFallLayout.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/18.
//
/*
 瀑布流效果
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NrWaterFallLayout;
 
@protocol NrWaterFallLayoutDataSource<NSObject>
 
@required
/**
  * 每个item的高度
  */
- (CGFloat)NrWaterFallLayout:(NrWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;
 
@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInNrWaterFallLayout:(NrWaterFallLayout *)waterFallLayout;
 
/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInNrWaterFallLayout:(NrWaterFallLayout *)waterFallLayout;
 
/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInNrWaterFallLayout:(NrWaterFallLayout *)waterFallLayout;
 
/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetsInNrWaterFallLayout:(NrWaterFallLayout *)waterFallLayout;
 
@end
@interface NrWaterFallLayout : UICollectionViewLayout
/**
 * 代理
 */
@property (nonatomic, weak) id<NrWaterFallLayoutDataSource> delegate;

@end

NS_ASSUME_NONNULL_END
