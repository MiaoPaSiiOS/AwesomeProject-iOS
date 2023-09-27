//
//  DisplayHWBaseCacheViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/17.
//

#import "DisplayHWBaseCacheViewScreen.h"
#import <Masonry/Masonry.h>
#import "HWHomeCell.h"
#import "DisplayHWPlayViewScreen.h"
#import "DSAwesomeKitTool.h"

@interface DisplayHWBaseCacheViewScreen ()
@property (nonatomic, strong) UIButton *navRightBtn;  // 导航右侧删除按钮
@property (nonatomic, strong) UIView *tabbarView;     // 底部工具栏
@property (nonatomic, strong) UIButton *allSelbtn;    // 全选按钮
@property (nonatomic, strong) UIButton *deleteBtn;    // 底部工具栏删除按钮
@property (nonatomic, readwrite) BOOL navEditing;     // 是否是编辑删除状态
@property(nonatomic, strong) NSMutableArray *checked;
@end

@implementation DisplayHWBaseCacheViewScreen
- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checked = [NSMutableArray array];
}

- (void)dsInitSubviews {
    [super dsInitSubviews];
    self.appBar.hidden = YES;
    [self.dsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];

    // 导航右侧按钮
    UIButton *navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    navRightBtn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    navRightBtn.layer.cornerRadius = 20;
    navRightBtn.layer.masksToBounds = YES;
    [navRightBtn setImage:[DSAwesomeKitTool imageNamed:@"nav_deleteBtn"] forState:UIControlStateNormal];
    [navRightBtn setImage:[DSAwesomeKitTool imageNamed:@"nav_deleteBtn"] forState:UIControlStateHighlighted];
    [navRightBtn setImage:[DSAwesomeKitTool imageNamed:@"nav_cancelBtn"] forState:UIControlStateSelected];
    [navRightBtn addTarget:self action:@selector(navBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn = navRightBtn;
    [self.dsView addSubview:self.navRightBtn];
    [self.navRightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.mas_offset(-10);
    }];

    //底部操作按钮
    [self.dsView addSubview:self.tabbarView];
    self.tabbarView.layer.borderColor = [UIColor redColor].CGColor;
    self.tabbarView.layer.borderWidth = 3;
    
    [self.recylerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.navRightBtn.mas_bottom);
        make.bottom.equalTo(self.tabbarView.mas_top);
    }];
    

    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isNavEditing) [self navBtnOnClick:_navRightBtn];
}


- (BOOL)isNavEditing {
    return _navRightBtn.selected;
}

- (CGFloat)tabbarViewHeight {
    return _tabbarView.height;
}

#pragma mark -
//是否全选
- (BOOL)checkIsAllSelect {
    BOOL result = YES;
    if (self.checked.count == self.dataSource.count) {
        for (int i = 0; i < self.dataSource.count; i++) {
            HWDownloadModel *model1 = self.checked[i];
            HWDownloadModel *model1_1 = self.dataSource[i];
            if (![model1.url isEqualToString:model1_1.url]) {
                result = NO;
                break;
            }
        }
    } else {
        result = NO;
    }
    return result;
}

//筛选判断:已选中的数据不在数据源中时要删除
- (void)removeCheckedModelsIfNotInDataSource {
    NSMutableArray *tmp = [NSMutableArray array];
    for (HWDownloadModel *model in self.checked) {
        if (![self.dataSource containsObject:model]) {
            [tmp addObject:model];
        }
    }
    [self.checked removeObjectsInArray:tmp];
}

// 刷新界面元素
- (void)reloadTableView {
    [self removeCheckedModelsIfNotInDataSource];
    
    //全选按钮
    if (self.dataSource.count && [self checkIsAllSelect]) {
        _allSelbtn.selected = YES;
    } else {
        _allSelbtn.selected = NO;
    }

    //删除按钮
    [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", self.checked.count] forState:UIControlStateNormal];
    if (self.checked.count == 0) {
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    //刷新列表
    [self.recylerView reloadData];
}

#pragma mark - 刷新 & 插入 & 删除 & 更新
- (void)reloadRowWithModel:(HWDownloadModel *)model index:(NSInteger)index {
    self.dataSource[index] = model;
    [self reloadTableView];
}

- (void)insertModel:(HWDownloadModel *)model {
    int index = 0;
    [self.dataSource insertObject:model atIndex:index];
    [self reloadTableView];
}

- (void)deleteRowAtIndex:(NSInteger)index {
    [self.dataSource removeObjectAtIndex:index];
    [self reloadTableView];
}

- (void)updateViewWithModel:(HWDownloadModel *)model index:(NSInteger)index {
    HWHomeCell *cell = [self.recylerView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell updateViewWithModel:model];
    [self reloadTableView];
}

#pragma mark - 编辑 & 取消编辑
- (void)navBtnOnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self reloadTableView];
    [UIView animateWithDuration:0.25 animations:^{
        self.tabbarView.top = self.isNavEditing ?  self.dsView.height - DSCommonMethods.tabBarHeight : self.dsView.height;
    }];
}

#pragma mark - 底部操作按钮点击
- (void)tabbarBtnOnClick:(UIButton *)btn {
    if (btn == _allSelbtn) {
        //全选
        _allSelbtn.selected = !_allSelbtn.selected;
        [self.checked removeAllObjects];
        if (_allSelbtn.selected) [self.checked addObjectsFromArray:self.dataSource];
        [self reloadTableView];

    } else {
        //删除
        for (HWDownloadModel *model in self.checked) {
            [[HWDownloadManager shareManager] deleteTaskAndCache:model];
        }
        [self.dataSource removeObjectsInArray:self.checked];
        [self.checked removeAllObjects];
        [self reloadTableView];
    }
}

// 取消全选
- (void)cancelAllSelect
{
    [self.checked removeAllObjects];
    [self reloadTableView];
}

//点击cell选中按钮
- (void)cellClickCheckBtn:(HWDownloadModel *)model {
    if ([self.checked containsObject:model]) {
        [self.checked removeObject:model];
    } else {
        [self.checked addObject:model];
    }
    [self reloadTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWHomeCell *cell = [HWHomeCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.hsEditing = self.isNavEditing;
    cell.hsSelected = [self.checked containsObject:cell.model];
    kWeakSelf
    [cell setClickCheckBoxBtn:^(HWDownloadModel *model) {
        kStrongSelf
        [strongSelf cellClickCheckBtn:model];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_navEditing) {
        NSArray *indexPaths = self.recylerView.indexPathsForSelectedRows;
        if (indexPaths.count > 0) [_deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", indexPaths.count] forState:UIControlStateNormal];
        if (indexPaths.count == self.dataSource.count) [_allSelbtn setTitle:@"取消全选" forState:UIControlStateNormal];
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HWDownloadModel *model = self.dataSource[indexPath.row];
        if (model.state == HWDownloadStateFinish) {
            DisplayHWPlayViewScreen *vc = [[DisplayHWPlayViewScreen alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray<HWDownloadModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)tabbarView {
    if (!_tabbarView) {
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, DSCommonMethods.screenHeight, DSCommonMethods.screenWidth, DSCommonMethods.tabBarHeight)];
        _tabbarView.backgroundColor = [DSCommonMethods colorWithHexString:@"0xfafafa"];
        
        UIButton *btn_last = nil;
        NSArray *titleArray = @[@"全选", @"删除"];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tabbarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_tabbarView addSubview:btn];
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"spUnseleted"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"spSeleted"] forState:UIControlStateSelected];
                _allSelbtn = btn;
            } else if (i == 1) {
                _deleteBtn = btn;
            }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.height.mas_equalTo(49);
                make.left.equalTo(btn_last ? btn_last.mas_right:btn.superview).offset(5);
            }];
            btn_last = btn;
        }
        
        // 线
        for (int i = 0; i < 2; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(DSCommonMethods.screenWidth * 0.5, 10, 0.5, 29)];
            if (i == 1) line.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, 0.5);
            line.backgroundColor = [DSCommonMethods colorWithHexString:@"0xe5e5e5"];
            [_tabbarView addSubview:line];
        }
    }
    return _tabbarView;
}

@end
