//
//  SDMajletViewCollectionViewFlowLayout.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/11.
//

#import <UIKit/UIKit.h>
#import "SDMajletViewSectionDecorationReusableView.h"
NS_ASSUME_NONNULL_BEGIN
@class SDMajletViewCollectionViewFlowLayout;
@protocol SDMajletViewCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>


/// 指定section卡片装饰图间距
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SDMajletViewCollectionViewFlowLayout*)collectionViewLayout decorationInsetForSectionAt:(NSInteger)section;

/// 指定section卡片装饰图颜色，默认为白色
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(SDMajletViewCollectionViewFlowLayout*)collectionViewLayout decorationColorForSectionAt:(NSInteger)section;

@end

/// 卡片式背景CollectionViewLayout
@interface SDMajletViewCollectionViewFlowLayout : UICollectionViewFlowLayout
@property(nonatomic, assign) id <SDMajletViewCollectionViewFlowLayoutDelegate>decorationDelegate;
@end

NS_ASSUME_NONNULL_END
