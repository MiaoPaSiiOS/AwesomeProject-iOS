//
//  IUScreenProtocol.h
//
//  Created by yuhui on 2021/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// IUBaseScreen
@protocol IUBaseScreenProtocol <NSObject>
#pragma mark - init
- (void)iuSetUp;
- (void)iuInitSubviews;
- (void)iuSetUpNavigationItems;
- (void)iuSetUpToolbarItems;
#pragma mark - 点击事件
- (void)iuClickBackButton;

#pragma mark - 常用值设置
- (CGFloat)getAppBarHeight;
- (CGFloat)getNavigationBarHeight;
- (UIImage *)getBackButtonImage;

#pragma mark - 页面加载
/**
 * 展示页面加载视图。
 */
- (void)startLoading;

/**
 * 停止加载视图显示。
 */
- (void)stopLoading;
@end

/// TableViewScreen
@protocol IUTableViewScreenProtocol <NSObject,UITableViewDelegate, UITableViewDataSource>
- (UITableView *)preferredRecylerView;
- (UITableViewStyle)preferredRecylerViewStyle;
@property(nonatomic, assign) int page;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSMutableArray *dataSource;
- (void)showDZNEmptyView;
- (void)hideDZNEmptyView;
@end

/// CollectionViewScreen
@protocol IUCollectionViewScreenProtocol <NSObject,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
- (UICollectionView *)preferredRecylerView;
- (UICollectionViewLayout *)preferredRecylerViewLayout;
@property(nonatomic, assign) int page;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSMutableArray *dataSource;
- (void)showDZNEmptyView;
- (void)hideDZNEmptyView;
@end







NS_ASSUME_NONNULL_END
