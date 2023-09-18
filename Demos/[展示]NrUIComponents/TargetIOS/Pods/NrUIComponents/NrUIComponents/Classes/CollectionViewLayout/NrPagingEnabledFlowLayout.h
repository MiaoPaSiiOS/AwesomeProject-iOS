//
//  NrPagingEnabledFlowLayout.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/17.
//
/*
 实现分页滑动效果
 */
#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface NrPagingEnabledFlowLayout : UICollectionViewFlowLayout
/**
 * 最小滚动距离 default 30.f
 * @note 数值太大且滑动距离过小时会有明显的移动顿挫感
 */
@property(nonatomic, assign) CGFloat dragMiniDistance;
@end

NS_ASSUME_NONNULL_END
