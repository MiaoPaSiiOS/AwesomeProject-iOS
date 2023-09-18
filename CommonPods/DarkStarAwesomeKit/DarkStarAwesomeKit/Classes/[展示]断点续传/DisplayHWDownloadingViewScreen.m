//
//  DisplayHWDownloadingViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/17.
//

#import "DisplayHWDownloadingViewScreen.h"

@interface DisplayHWDownloadingViewScreen ()

@end

@implementation DisplayHWDownloadingViewScreen

- (void)listDidAppear {
    // 获取缓存
    [self getCacheData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加通知
    [self addNotification];

}

- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

- (void)getCacheData
{
    // 获取所有未下载完成的数据
    self.dataSource = [[[HWDataBaseManager shareManager] getAllDownloadingData] mutableCopy];
    [self reloadTableView];
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.url isEqualToString:downloadModel.url]) {
                // 更新cell进度
                [self updateViewWithModel:downloadModel index:idx];
                
                *stop = YES;
            }
        }];
    });
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.url isEqualToString:downloadModel.url]) {
                if (downloadModel.state == HWDownloadStateFinish) {
                    // 下载完成，移除cell
                    [self deleteRowAtIndex:idx];
                    
                    // 没有正在下载的数据，则返回
                    if (self.dataSource.count == 0) [self.navigationController popViewControllerAnimated:YES];
                    
                }else {
                    // 刷新列表
                    [self reloadRowWithModel:downloadModel index:idx];
                }
                
                *stop = YES;
            }
        }];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
