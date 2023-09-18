//
//  HWHomeCell.h
//  HWProject
//
//  Created by wangqibin on 2018/4/23.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NrHWDownloadManager/NrHWDownloadManager.h>
@interface HWHomeCell : UITableViewCell

@property(nonatomic, strong) HWDownloadModel *model;

@property(nonatomic, assign) BOOL hsEditing;

@property(nonatomic, assign) BOOL hsSelected;

@property(nonatomic, copy) void (^clickCheckBoxBtn)(HWDownloadModel *model);

+ (instancetype)cellWithTableView:(UITableView *)tabelView;



// 更新视图
- (void)updateViewWithModel:(HWDownloadModel *)model;

@end
