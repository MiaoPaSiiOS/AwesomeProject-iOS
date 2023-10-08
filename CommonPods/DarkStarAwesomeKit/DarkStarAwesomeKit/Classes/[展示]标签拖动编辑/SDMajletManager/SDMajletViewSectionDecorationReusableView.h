//
//  SDMajletViewSectionDecorationReusableView.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Section卡片装饰图的布局属性
@interface SDMajletViewSectionCardDecorationCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
/// 背景色
@property(nonatomic, strong) UIColor *backgroundColor;
//@property(nonatomic, strong) SectionCardModel *sectionCardModel;
@end

/// Section卡片装饰视图
@interface SDMajletViewSectionDecorationReusableView : UICollectionReusableView

@end
NS_ASSUME_NONNULL_END
