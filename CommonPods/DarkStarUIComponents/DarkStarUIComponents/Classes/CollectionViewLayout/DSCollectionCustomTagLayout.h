//
//  DSCollectionCustomTagLayout.h
//  BankOfCommunications
//
//  Created by zhuyuhui on 2022/5/26.
//  Copyright © 2022 P&C Information. All rights reserved.
//
/*
 Tag标签宽度不固定
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// NSTextAlignment    textAlignment
typedef enum : NSUInteger {
    NrTagContentAlignmentLeft,
    NrTagContentAlignmentRight,
} NrTagContentAlignment;


@class DSCollectionCustomTagLayout;
@protocol DSCollectionCustomTagLayoutDelegate <NSObject>
/// section head footer size
- (CGSize)DSCollectionCustomTagLayout:(DSCollectionCustomTagLayout *)layout sizeForSupplementaryElementOfKind:(NSString *)kind section:(NSInteger)section;
/// 标签的宽度
- (CGFloat)DSCollectionCustomTagLayout:(DSCollectionCustomTagLayout *)layout tagWidthForItemAt:(NSIndexPath *)indexPath;
@end

@interface DSCollectionCustomTagLayout : UICollectionViewLayout
/// 标签的高度
@property(nonatomic, assign) CGFloat itemHeight;
/// 元素间距
@property(nonatomic, assign) CGFloat minimumLineSpacing;
/// 行间距
@property(nonatomic, assign) CGFloat minimumInteritemSpacing;
/// SectionInset
@property(nonatomic, assign) UIEdgeInsets sectionInset;
/// 排列方式 默认左排列
@property(nonatomic, assign) NrTagContentAlignment contentAlignment;

@property(nonatomic, weak) id <DSCollectionCustomTagLayoutDelegate>delegate;
@end
NS_ASSUME_NONNULL_END

