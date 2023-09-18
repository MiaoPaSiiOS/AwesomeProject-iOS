//
//  DisplayHWCacheViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/17.
//

#import "DisplayHWCacheViewScreen.h"
#import <Masonry/Masonry.h>
#import "DisplayHWDownloadingViewScreen.h"
@interface DisplayHWCacheViewScreen ()
@property(nonatomic, strong) UIButton *downloadingBtn;
@property(nonatomic, assign) NSInteger downloadingCount;
@end

@implementation DisplayHWCacheViewScreen
- (void)listDidAppear {
    // 获取缓存
    [self getCacheData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建控件
    [self creatControl];
    
    // 添加通知
    [self addNotification];
}


- (void)creatControl
{
    // 正在缓存按钮
    UIButton *downloadingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    downloadingBtn.hidden = YES;
    downloadingBtn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    downloadingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadingBtn addTarget:self action:@selector(downloadingBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dsView addSubview:downloadingBtn];
    _downloadingBtn = downloadingBtn;
}

- (void)downloadingBtnOnClick
{
//    [self.navigationController pushViewController:[[DisplayHWDownloadingViewScreen alloc] init] animated:YES];
}

- (void)addNotification
{
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];
}

- (void)getCacheData
{
    // 获取已缓存数据
    self.dataSource = [[[HWDataBaseManager shareManager] getAllDownloadedData] mutableCopy];
    [self reloadTableView];
    
    // 获取所有未下载完成的数据
    _downloadingCount = [[HWDataBaseManager shareManager] getAllUnDownloadedData].count;
    [self reloadCacheView];
}

// 刷新正在缓存提示视图
- (void)reloadCacheView
{
    _downloadingBtn.hidden = _downloadingCount == 0;
    [_downloadingBtn setTitle:[NSString stringWithFormat:@"%ld个文件正在缓存", _downloadingCount] forState:UIControlStateNormal];
//    [self.recylerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(_downloadingCount == 0? 0:self.downloadingBtn.height);
//    }];
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;
    
    if (downloadModel.state == HWDownloadStateFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self insertModel:downloadModel];
            self.downloadingCount--;
            [self reloadCacheView];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



// 返回列表视图
// 如果列表是 VC，就返回 VC.view
// 如果列表是 View，就返回 View 自己
- (UIView *)listView {
    return self.view;
}
@end
