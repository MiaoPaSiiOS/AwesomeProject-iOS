//
//  DisplayDragEditTagViewController.m
//  DarkStarAwesomeKit
//
//  Created by zhuyuhui on 2023/10/7.
//

#import "DisplayDragEditTagViewController.h"
#import <MJExtension/MJExtension.h>
#import "SDMajletView.h"
#import "SDMajletModel.h"
#import "SDMajletUtil.h"

@interface DisplayDragEditTagViewController ()
@property(nonatomic, strong) SDMajletView *collectionView;
@property(nonatomic, strong) UIButton *rightBtn;
@end

@implementation DisplayDragEditTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用";
    [self requestListInfo];
}
 
- (void)dsInitSubviews {
    [super dsInitSubviews];
    [self.appBar.navigationBar addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(16);
        make.width.mas_offset(32);
        make.centerY.mas_offset(0);
    }];
    
    [self.dsView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
}

- (void)requestListInfo {
    [SDMajletUtil fetchApplicationListHandler:^(NSArray<SDMajletModel *> *models) {
        //我的应用
        [self.collectionView.dataArray removeAllObjects];
        [self.collectionView.dataArray addObject:[SDMajletUtil createMyApplyModel]];
        for (SDMajletModel *group in models) {
            [self.collectionView.dataArray addObject:group];
        }
        [self.collectionView reloadCollection];
    }];
//    [PNCGifWaitView showWaitViewInView:self.nrView style:BlueWaitStyle];
//    [REApplicationUtil fetchApplicationListHandler:^(KLResponse * _Nonnull result, NSArray<REApplicationModel *> * _Nonnull models) {
//        NSLog(@"%@",result.responseObject);
//        [PNCGifWaitView hideWaitViewInView:self.nrView];
//        if (result.success) {
//            //我的应用
//            [self.collectionView.dataArray removeAllObjects];
//            [self.collectionView.dataArray addObject:[REApplicationUtil createMyApplyModel]];
//            for (REApplicationModel *group in models) {
//                [self.collectionView.dataArray addObject:group];
//            }
//            [self.collectionView reloadCollection];
//        } else {
//            [self re_showError:@"获取信息失败"];
//        }
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Event
- (void)handleEditState:(BOOL)isEdit {
    [self reloadDataWithEdit:isEdit];
}

- (void)handleDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.collectionView.dataArray.count) {
        SDMajletModel *group = self.collectionView.dataArray[indexPath.section];
        if (indexPath.item < group.childApplications.count) {
            SDMajletModel *itemModel = group.childApplications[indexPath.row];
            NSLog(@"%@",itemModel);
        }
    }
}

-(void)reloadDataWithEdit:(BOOL)isEdit{
    self.title = isEdit ? @"管理应用":@"应用";
    self.rightBtn.hidden = !isEdit;
    _collectionView.editing = isEdit;
    
    for (int i = 0; i< _collectionView.dataArray.count; i++) {
        SDMajletModel *group = _collectionView.dataArray[i];
        group.edit = isEdit;
    }
    [_collectionView reloadCollection];
    
    //保存数据
    SDMajletModel *group = self.collectionView.dataArray.firstObject;
    if ([group mj_JSONObject]) {
        NSMutableDictionary *jsonObj = [NSMutableDictionary dictionaryWithDictionary:[group mj_JSONObject]];
        jsonObj[@"edit"] = @(NO);
        [SDMajletUtil saveMyApplicationInfo:jsonObj];
    }
}

- (void)rightAction:(UIButton *)sender {
    [self reloadDataWithEdit:NO];
}
#pragma mark - 懒加载
- (SDMajletView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 0, DSDeviceInfo.screenWidth, DSDeviceInfo.screenHeight - DSDeviceInfo.naviBarHeight)];
        kWeakSelf;
        _collectionView.block = ^(BOOL isEdit) {
            kStrongSelf;
            [strongSelf reloadDataWithEdit:isEdit];
        };
        _collectionView.didSelectItemAtIndexPath = ^(NSIndexPath *indexPath) {
            kStrongSelf;
            [strongSelf handleDidSelectItemAtIndexPath:indexPath];
        };

    }
    return _collectionView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightBtn.backgroundColor = [DSHelper colorWithHexString:@"0xE00514"];
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn ds_setEnlargeEdge:15];
        _rightBtn.hidden = YES;
    }
    return _rightBtn;
}

@end
