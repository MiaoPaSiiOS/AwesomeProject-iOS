//
//  IUCollectionViewScreen.h
//  CRJKit
//
//  Created by zhuyuhui on 2020/9/15.
//

#import "IUBaseScreen.h"
#import "IUdZNEmptyView.h"
NS_ASSUME_NONNULL_BEGIN

@interface IUCollectionViewScreen : IUBaseScreen<IUCollectionViewScreenProtocol,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic, strong) UICollectionView *recylerView;
@property(nonatomic, assign) int page;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

NS_ASSUME_NONNULL_END
