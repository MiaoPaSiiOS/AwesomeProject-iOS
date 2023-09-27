//
//  QMCameraSettingViewController.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/10/2.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMCameraSettingViewController.h"
#import "QMSettingModel.h"
#import "QMSettingTableViewCell.h"
#import "AECResouce.h"
#import "Constants.h"

@interface QMCameraSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<QMSettingModel *> *> *settingModels;
@end

@implementation QMCameraSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupDatas];
}

- (void)setupUI
{
    // Background
    self.view.backgroundColor = [DSCommonMethods colorWithHexString:@"0xF7F8F8"];
    
    // topBar
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectZero];
    topBar.frame = CGRectMake(0, SafeAreaInsetsConstantForDeviceWithNotch.top, DSCommonMethods.screenWidth, DSCommonMethods.naviBarContentHeight);
    topBar.backgroundColor = [DSCommonMethods colorWithHexString:@"0xebedee"];
    [self.view addSubview:topBar];
    
    // title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"设置";
    title.font = [UIFont systemFontOfSize:18];
    [topBar addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    // Back
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn setImage:[AECResouce imageNamed:@"qm_setting_back_btn"] forState:UIControlStateNormal];
    [topBar addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(15);
        make.left.mas_offset(10);
    }];

    
    // UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.rowHeight = 55;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [DSCommonMethods colorWithHexString:@"0xebedee"];
    
    [tableView registerNib:[AECResouce nibWithNibName:@"QMSettingTableViewCell"] forCellReuseIdentifier:@"QMSettingTableViewCell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topBar.mas_bottom).mas_equalTo(0);
    }];
}

- (void)setupDatas
{
    _settingModels = [QMSettingModel buildSettingModels];
}

#pragma mark - Event
- (void)backBtnTapped:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _settingModels.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settingModels[@(section)].count;;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    QMSettingModel *model = _settingModels[@(indexPath.section)][indexPath.row];
    QMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMSettingTableViewCell"];
    [cell setSettingModelType:model.settingType];
    cell.label.text = model.name;
    cell.switcher.on = model.switchOn;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"拍摄";
    }else {
        return @"其它";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    ((UITableViewHeaderFooterView *)view).textLabel.textColor = [DSCommonMethods colorWithHexString:@"0xbac1c5"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
