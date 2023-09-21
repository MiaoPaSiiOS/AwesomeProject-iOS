//
//  UICollectionView+DarkStarExtension.h
//  AmenJDappKit
//
//  Created by zhuyuhui on 2022/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (DarkStarExtension)
/** 页眉视图 */
@property (nonatomic) UIView *lt_collectionHeaderView;
/** 页脚视图 */
@property (nonatomic) UIView *lt_collectionFooterView;
/** 页眉向上偏移量 */
@property (nonatomic, assign) CGFloat lt_collectionHeaderViewOffset;
/** 页脚向下偏移量 */
@property (nonatomic, assign) CGFloat lt_collectionFooterViewOffset;
@end

NS_ASSUME_NONNULL_END
