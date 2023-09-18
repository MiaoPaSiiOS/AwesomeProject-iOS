//
//  NrGridViewLayout.h
//  SftwUIComponents
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NrGridViewLayout;
@protocol NrGridViewLayoutDelegate <NSObject>
/// section head footer size
- (CGSize)NrGridViewLayout:(NrGridViewLayout *)layout sizeForSupplementaryElementOfKind:(NSString *)kind section:(NSInteger)section;
/// 标签的宽度
- (CGFloat)NrGridViewLayout:(NrGridViewLayout *)layout widthForItemAt:(NSIndexPath *)indexPath;
@end

@interface NrGridViewLayout : UICollectionViewLayout
/// 标签的高度 default 25
@property(nonatomic, assign) CGFloat itemHeight;
/// 元素间距 default 10
@property(nonatomic, assign) CGFloat minimumLineSpacing;
/// 行间距 default 10
@property(nonatomic, assign) CGFloat minimumInteritemSpacing;
/// SectionInset default UIEdgeInsetsMake(0, 0, 0, 0)
@property(nonatomic, assign) UIEdgeInsets sectionInset;
/// insets default UIEdgeInsetsMake(20, 20, 20, 20);
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property(nonatomic, weak) id <NrGridViewLayoutDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
