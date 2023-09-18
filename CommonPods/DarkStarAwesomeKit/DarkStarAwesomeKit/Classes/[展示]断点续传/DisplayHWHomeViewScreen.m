//
//  DisplayHWHomeViewScreen.m
//  NrBTHelp
//
//  Created by zhuyuhui on 2022/8/16.
//

#import "DisplayHWHomeViewScreen.h"
#import <DarkStarDownloadManagerKit/DarkStarDownloadManagerKit.h>
#import <YYModel/YYModel.h>
#import <Masonry/Masonry.h>
#import "HWHomeCell.h"
#import "DisplayHWPlayViewScreen.h"
#import "DSAwesomeKitTool.h"
@interface DisplayHWHomeViewScreen ()
@property (nonatomic, strong) NSMutableArray<HWDownloadModel *> *dataSource;
@end

@implementation DisplayHWHomeViewScreen

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件列表";
    
    // 开启网络监听
    [[HWNetworkReachabilityManager shareManager] monitorNetworkStatus];

    // 添加通知
    [self addNotification];
}

- (void)dsInitSubviews {
    [super dsInitSubviews];
    self.appBar.hidden = YES;
    [self.dsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.mas_offset(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取网络数据
    [self getInfo];

    // 获取缓存
    [self getCacheData];
}

- (void)getInfo {
    NSString *pathForResource = [[DSAwesomeKitTool AssetsBundle] pathForResource:@"testData" ofType:@"plist"];
    // 模拟网络数据
    NSArray *testData = [NSArray arrayWithContentsOfFile:pathForResource];

    // 转模型
    self.dataSource = [NSArray yy_modelArrayWithClass:HWDownloadModel.class json:testData].mutableCopy;
    
}

- (void)getCacheData {
    // 获取已缓存数据
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllCacheData];

    // 这里是把本地缓存数据更新到网络请求的数据中，实际开发还是尽可能避免这样在两个地方取数据再整合
    for (int i = 0; i < self.dataSource.count; i++) {
        HWDownloadModel *model = self.dataSource[i];
        for (HWDownloadModel *downloadModel in cacheData) {
            if ([model.url isEqualToString:downloadModel.url]) {
                self.dataSource[i] = downloadModel;
                break;
            }
        }
    }
    
    [self.recylerView reloadData];
}

- (void)addNotification {
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWHomeCell *cell = [HWHomeCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWDownloadModel *model = self.dataSource[indexPath.row];

    if (model.state == HWDownloadStateFinish) {
        DisplayHWPlayViewScreen *vc = [[DisplayHWPlayViewScreen alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification {
    HWDownloadModel *downloadModel = notification.object;

    [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                HWHomeCell *cell = [self.recylerView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [cell updateViewWithModel:downloadModel];
            });
            
            *stop = YES;
        }
    }];
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification {
    HWDownloadModel *downloadModel = notification.object;

    [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 更新数据源
            self.dataSource[idx] = downloadModel;
            
            // 主线程刷新cell
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recylerView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });

            *stop = YES;
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray<HWDownloadModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - 销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
