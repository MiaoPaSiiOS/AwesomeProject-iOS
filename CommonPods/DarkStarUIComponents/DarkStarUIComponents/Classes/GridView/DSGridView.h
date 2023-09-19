//
//  DSGridView.h
//  CRJCollectionGridView
//
//  Created by zhuyuhui on 2020/9/7.
//

#import <UIKit/UIKit.h>
#import "DSGridViewLayout.h"
@class DSGridView;

@protocol DSGridViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInDSGridView:(DSGridView *)gridView;
- (NSInteger)DSGridView:(DSGridView *)gridView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)DSGridView:(DSGridView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)DSGridView:(DSGridView *)gridView widthForItemAt:(NSIndexPath *)indexPath;
@end


@protocol DSGridViewDelegate <NSObject>
@optional
- (void)DSGridView:(DSGridView *)gridView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DSGridView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DSGridViewLayout *flowLayout;

/**
 *  The cell's count at the horizontal direction, default is 3.
 */
@property (nonatomic) NSUInteger horizontalCellCount;

// 代理
@property (nonatomic, weak) id<DSGridViewDataSource> dataSource;
@property (nonatomic, weak) id<DSGridViewDelegate>   delegate;

/**
 *  Reset the view's size.
 */
- (void)resetSize;

/**
 *  Get the CollectionView's content size.
 */
@property (nonatomic, readonly) CGSize contentSize;

/**
 *  Reloads just the items at the specified index paths.
 *
 *  @param indexPaths An array of NSIndexPath objects identifying the items you want to update.
 */
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 *  Reload data.
 */
- (void)reloadData;
@end




