//
//  NrTableViewController.h
//  NrViewController
//
//  Created by zhuyuhui on 2021/11/11.
//

#import "NrViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NrTableViewController : NrViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong, nullable) UITableView *recylerView;

// 创建table view
- (void)createTableViewWithStyle:(UITableViewStyle)style;
- (void)createTableViewWithFrame:(CGRect)frame
                           style:(UITableViewStyle)style;
- (void)createTableView:(Class)viewClass
              withFrame:(CGRect)frame style:(UITableViewStyle)style;
// 默认全为YES
@property (nonatomic, assign) BOOL enableHeaderRefresh;
@property (nonatomic, assign) BOOL enableFooterRefresh;
@property (nonatomic, assign) BOOL enableRefresh;

// 刷新时执行的方法
- (void)footerRefreshAction;
- (void)headerRefreshAction;
// 开始刷新
- (void)startRefresh;
// 停止刷新
- (void)stopRefresh;
// 是否正在刷新，返回YES时表示有头部或底部正在刷新
- (BOOL)isRefreshing;
@end

NS_ASSUME_NONNULL_END
