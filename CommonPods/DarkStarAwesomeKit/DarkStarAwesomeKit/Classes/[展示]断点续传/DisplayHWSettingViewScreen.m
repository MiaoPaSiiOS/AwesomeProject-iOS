//
//  DisplayHWSettingViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/17.
//

#import "DisplayHWSettingViewScreen.h"
#import <DarkStarDownloadManagerKit/DarkStarDownloadManagerKit.h>
#import <DarkStarUIComponents/DarkStarUIComponents.h>
@interface DisplayHWSettingViewScreen ()
@property(nonatomic, assign) NSInteger downloadMaxConcurrentCount;
@property(nonatomic, assign) BOOL downloadAllowsCellularAccess;//是否允许蜂窝网络下载key
@end

@implementation DisplayHWSettingViewScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recylerView.backgroundColor = [UIColor groupTableViewBackgroundColor];    
    self.downloadMaxConcurrentCount = [[NSUserDefaults standardUserDefaults] integerForKey:HWDownloadMaxConcurrentCountKey];
    self.downloadAllowsCellularAccess = [[NSUserDefaults standardUserDefaults] boolForKey:HWDownloadAllowsCellularAccessKey];

    
    self.title = @"设置";
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DSBarButtonItem *rightBarButtonItem = [[DSBarButtonItem alloc] initWithTitle:@"清空缓存" target:self action:@selector(clearBtnOnClick)];
    rightBarButtonItem.titleColor = [UIColor blackColor];
    self.appBar.rightBarButtonItem = rightBarButtonItem;
}

- (void)clearBtnOnClick
{
    [HWToolBox showAlertWithTitle:@"是否清空所有缓存？" sureMessage:@"确认" cancelMessage:@"取消" warningMessage:nil style:UIAlertControllerStyleAlert target:self sureHandler:^(UIAlertAction *action) {
        // 清空缓存
        [self clearLocalCache];
    } cancelHandler:nil warningHandler:nil];
}

- (void)clearLocalCache
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSArray *array = [[HWDataBaseManager shareManager] getAllCacheData];
        for (HWDownloadModel *model in array) {
            [[HWDownloadManager shareManager] deleteTaskAndCache:model];
        }
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self DownloadMaxConcurrentCountCellAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        return [self DownloadAllowsCellularAccessCellAtIndexPath:indexPath];
    }
    else {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            [datas addObject:[NSString stringWithFormat:@"%d",i]];
        }
        kWeakSelf
        DSSingleChoiceDialog *dialogView = [[DSSingleChoiceDialog alloc] init];
        dialogView.info = @"选择同时下载文件数";
        dialogView.showDatas = datas;
        dialogView.selectedItem = [NSString stringWithFormat:@"%ld",(long)self.downloadMaxConcurrentCount];
        [dialogView setDidSelectedIndex:^(DSSingleChoiceDialog * _Nonnull dialog, NSInteger selectedIndex) {
            kStrongSelf
            strongSelf.downloadMaxConcurrentCount = [datas[selectedIndex] integerValue];
            [strongSelf.recylerView reloadData];
            
            // 保存
            [[NSUserDefaults standardUserDefaults] setInteger:strongSelf.downloadMaxConcurrentCount
                                                       forKey:HWDownloadMaxConcurrentCountKey];
            // 通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HWDownloadMaxConcurrentCountChangeNotification
                                                                object:[NSNumber numberWithInteger:strongSelf.downloadMaxConcurrentCount]];
        }];
        [dialogView showInView:self.navigationController.view];

    }
    else if (indexPath.section == 1) {
        NSMutableArray *datas = [NSMutableArray array];
        [datas addObject:@"允许使用流量下载"];
        [datas addObject:@"仅WIFi网络下载"];
        kWeakSelf
        DSSingleChoiceDialog *dialogView = [[DSSingleChoiceDialog alloc] init];
        dialogView.info = @"传输网络设置";
        dialogView.showDatas = datas;
        dialogView.selectedItem = [NSString stringWithFormat:@"%ld",(long)self.downloadMaxConcurrentCount];
        [dialogView setDidSelectedIndex:^(DSSingleChoiceDialog * _Nonnull dialog, NSInteger selectedIndex) {
            kStrongSelf
            strongSelf.downloadAllowsCellularAccess = selectedIndex == 0 ? YES:NO;
            [strongSelf.recylerView reloadData];
            
            // 保存
            [[NSUserDefaults standardUserDefaults] setBool:strongSelf.downloadAllowsCellularAccess
                                                    forKey:HWDownloadAllowsCellularAccessKey];

            // 通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HWDownloadAllowsCellularAccessChangeNotification
                                                                object:[NSNumber numberWithBool:strongSelf.downloadAllowsCellularAccess]];

        }];
        [dialogView showInView:self.navigationController.view];
    }
}





#pragma mark - header
- (UIView *)viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, 30)];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = [UIColor blackColor];
    [header addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.centerY.mas_offset(0);
    }];
    if (section == 0) {
        titleLab.text = @"下载设置";
    } else if (section == 1) {
        titleLab.text = @"传输设置";
    } else {
        titleLab.text = @"";
    }
    return header;
}


#pragma mark - cell
/// 同时下载文件数Cell
- (UITableViewCell *)DownloadMaxConcurrentCountCellAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HWDownloadMaxConcurrentCount";
    UITableViewCell *cell = [self.recylerView dequeueReusableCellWithIdentifier:identifier];
    UILabel *titleLab = [cell.contentView viewWithTag:1000];
    UILabel *subtitleLab = [cell.contentView viewWithTag:1001];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        titleLab = [[UILabel alloc] init];
        titleLab.tag = 1000;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(12);
            make.centerY.mas_offset(0);
        }];
        
        subtitleLab = [[UILabel alloc] init];
        subtitleLab.tag = 1001;
        subtitleLab.font = [UIFont systemFontOfSize:12];
        subtitleLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [cell.contentView addSubview:subtitleLab];
        [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-12);
            make.centerY.mas_offset(0);
        }];
    }
    titleLab.text = @"同时下载文件数";
    subtitleLab.text = [NSString stringWithFormat:@"%ld个 >",(long)self.downloadMaxConcurrentCount];
    return cell;
}

/// 是否允许蜂窝网络下载改变Cell
- (UITableViewCell *)DownloadAllowsCellularAccessCellAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HWDownloadAllowsCellularAccess";
    UITableViewCell *cell = [self.recylerView dequeueReusableCellWithIdentifier:identifier];
    UILabel *titleLab = [cell.contentView viewWithTag:1000];
    UILabel *subtitleLab = [cell.contentView viewWithTag:1001];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        titleLab = [[UILabel alloc] init];
        titleLab.tag = 1000;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(12);
            make.centerY.mas_offset(0);
        }];
        
        subtitleLab = [[UILabel alloc] init];
        subtitleLab.tag = 1001;
        subtitleLab.font = [UIFont systemFontOfSize:12];
        subtitleLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [cell.contentView addSubview:subtitleLab];
        [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-12);
            make.centerY.mas_offset(0);
        }];
    }
    titleLab.text = @"同时下载文件数";
    subtitleLab.text = [NSString stringWithFormat:@"%@",self.downloadAllowsCellularAccess ? @"允许使用流量下载":@"仅WiFi网络下载"];
    return cell;
}





@end
