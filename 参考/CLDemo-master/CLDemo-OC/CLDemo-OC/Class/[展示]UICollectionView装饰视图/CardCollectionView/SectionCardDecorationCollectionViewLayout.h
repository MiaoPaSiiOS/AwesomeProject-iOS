

#import <UIKit/UIKit.h>
#import "SectionCardDecorationReusableView.h"
#import "SectionCardArmbandDecorationReusableView.h"
NS_ASSUME_NONNULL_BEGIN
@class SectionCardDecorationCollectionViewLayout;
@protocol SectionCardDecorationCollectionViewLayoutDelegate <UICollectionViewDelegateFlowLayout>
/// 指定section是否显示卡片装饰图，默认值为false
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout decorationDisplayedForSectionAt:(NSInteger)section;

/// 指定section卡片装饰图颜色，默认为白色
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (SectionCardModel *)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout decorationColorForSectionAt:(NSInteger)section;

/// 指定section卡片装饰图间距
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout decorationInsetForSectionAt:(NSInteger)section;

/// 指定section卡片装饰图是否显示袖标，默认值为false
/// - Note: 若卡片装饰图不显示，袖标就算是true，也不显示
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout armbandDecorationDisplayedForSectionAt:(NSInteger)section;

/// 指定section的袖标图标本地图片名字，默认为nil
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (NSString *)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout armbandDecorationImageForSectionAt:(NSInteger)section;


/// 指定section的袖标距离卡片的TopOffsetp
/// - Note: 值为nil时，使用默认值18
/// @param collectionView collectionView description
/// @param collectionViewLayout collectionViewLayout description
/// @param section section description
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SectionCardDecorationCollectionViewLayout*)collectionViewLayout armbandDecorationTopOffsetForSectionAt:(NSInteger)section;
@end

/// 卡片式背景CollectionViewLayout
@interface SectionCardDecorationCollectionViewLayout : UICollectionViewFlowLayout
@property(nonatomic, assign) id <SectionCardDecorationCollectionViewLayoutDelegate>decorationDelegate;
@end

NS_ASSUME_NONNULL_END
