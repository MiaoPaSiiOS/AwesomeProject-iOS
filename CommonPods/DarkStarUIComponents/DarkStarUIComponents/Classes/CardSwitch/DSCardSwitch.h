//
//  DSCardSwitch.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/2/16.
//
/*
 iOS利用余弦函数实现卡片浏览工具
 */
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>


NS_ASSUME_NONNULL_BEGIN
@class DSCardSwitch;

@protocol DSCardSwitchDataSource <NSObject>
@required
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end


@protocol DSCardSwitchDelegate <NSObject>

@optional
/// 点击卡片代理方法
/// @param index index description
- (void)cardSwitchDidClickAtIndex:(NSInteger)index;

/// 滚动卡片代理方法
/// @param index index description
- (void)cardSwitchDidScrollToIndex:(NSInteger)index;
@end

@interface DSCardSwitch : UIView

@property(nonatomic, strong, readonly) UICollectionView *collectionView;
/**
 代理
 */
@property(nonatomic, weak) id<DSCardSwitchDelegate>delegate;
@property(nonatomic, weak) id<DSCardSwitchDataSource>dataSource;

/**
 当前选中位置
 */
@property(nonatomic, assign, readwrite) NSInteger selectedIndex;
/// 数据源
@property(nonatomic, strong) NSArray *models;
/// 居中卡片宽度与据屏幕宽度比例
@property(nonatomic, assign) CGFloat cardWidthScale;
/// 居中卡片高度与据屏幕宽度比例
@property(nonatomic, assign) CGFloat cardHeightScale;
/// 相邻卡片间距
@property(nonatomic, assign) CGFloat cardItemSpacing;

/**
 手动滚动到某个卡片位置
 */
- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
