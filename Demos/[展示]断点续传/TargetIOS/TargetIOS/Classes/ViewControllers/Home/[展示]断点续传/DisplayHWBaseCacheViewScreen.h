//
//  DisplayHWBaseCacheViewScreen.h
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/17.
//

#import <NrViewKit/NrViewKit.h>
#import <NrHWDownloadManager/NrHWDownloadManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface DisplayHWBaseCacheViewScreen : NrTableViewController
@property (nonatomic, strong) NSMutableArray<HWDownloadModel *> *dataSource;  // 数据源
@property (nonatomic, assign, readonly, getter=isNavEditing) BOOL navEditing; // 是否是编辑删除状态
@property (nonatomic, assign, readonly) CGFloat tabbarViewHeight;             // 底部工具栏视图高度

// 刷新列表
- (void)reloadTableView;

// 刷新一个cell
- (void)reloadRowWithModel:(HWDownloadModel *)model index:(NSInteger)index;

// 增加一条数据
- (void)insertModel:(HWDownloadModel *)model;

// 移除一条数据
- (void)deleteRowAtIndex:(NSInteger)index;

// 更新数据
- (void)updateViewWithModel:(HWDownloadModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
