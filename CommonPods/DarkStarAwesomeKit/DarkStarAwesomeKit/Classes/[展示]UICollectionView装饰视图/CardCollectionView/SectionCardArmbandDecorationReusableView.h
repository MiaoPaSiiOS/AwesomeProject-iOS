
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// section卡片袖标的布局属性
@interface SectionCardArmbandDecorationCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property(nonatomic, copy) NSString *imageName;

@end
/// section卡片袖标装饰图
@interface SectionCardArmbandDecorationReusableView : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END
