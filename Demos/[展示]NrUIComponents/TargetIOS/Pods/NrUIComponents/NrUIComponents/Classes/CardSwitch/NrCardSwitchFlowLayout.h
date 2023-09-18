//
//  NrCardSwitchFlowLayout.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NrCardSwitchFlowLayout;
@protocol NrCardSwitchFlowLayoutDataSource<NSObject>

@optional
/// 居中卡片宽度与据屏幕宽度比例
/// @param cardFlowLayout cardFlowLayout description
- (CGFloat)cardMaxWidthScaleInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout;

/// 居中卡片高度与据屏幕宽度比例
/// @param cardFlowLayout cardFlowLayout description
- (CGFloat)cardMaxHeightScaleInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout;

/// 相邻卡片间距
/// @param cardFlowLayout cardFlowLayout description
- (CGFloat)cardItemSpacingInCardSwitchFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout;

/// 更新中间位
/// @param cardFlowLayout cardFlowLayout description
/// @param indexPath indexPath description
- (void)cardFlowLayout:(NrCardSwitchFlowLayout *)cardFlowLayout didScrollToIndexPath:(NSIndexPath*)indexPath;

@end

@interface NrCardSwitchFlowLayout : UICollectionViewFlowLayout
/// 代理
@property (nonatomic, weak) id<NrCardSwitchFlowLayoutDataSource> delegate;
/**
 * 最小滚动距离 default 30.f
 * @note 数值太大且滑动距离过小时会有明显的移动顿挫感
 */
@property(nonatomic, assign) CGFloat dragMiniDistance;
@end

NS_ASSUME_NONNULL_END
