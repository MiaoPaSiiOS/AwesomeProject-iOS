//
//  NrGridView.h
//  CRJCollectionGridView
//
//  Created by zhuyuhui on 2020/9/7.
//

#import <UIKit/UIKit.h>
#import "NrGridViewLayout.h"
@class NrGridView;

@protocol NrGridViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInNrGridView:(NrGridView *)gridView;
- (NSInteger)NrGridView:(NrGridView *)gridView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)NrGridView:(NrGridView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)NrGridView:(NrGridView *)gridView widthForItemAt:(NSIndexPath *)indexPath;
@end


@protocol NrGridViewDelegate <NSObject>
@optional
- (void)NrGridView:(NrGridView *)gridView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface NrGridView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NrGridViewLayout *flowLayout;

/**
 *  The cell's count at the horizontal direction, default is 3.
 */
@property (nonatomic) NSUInteger horizontalCellCount;

// 代理
@property (nonatomic, weak) id<NrGridViewDataSource> dataSource;
@property (nonatomic, weak) id<NrGridViewDelegate>   delegate;

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




