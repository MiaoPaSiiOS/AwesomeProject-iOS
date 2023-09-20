

#import <UIKit/UIKit.h>
#import "SectionCardModel.h"

NS_ASSUME_NONNULL_BEGIN
/// Section卡片装饰图的布局属性
@interface SectionCardDecorationCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
/// 背景色
//@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) SectionCardModel *sectionCardModel;
@end

/// Section卡片装饰视图
@interface SectionCardDecorationReusableView : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END
