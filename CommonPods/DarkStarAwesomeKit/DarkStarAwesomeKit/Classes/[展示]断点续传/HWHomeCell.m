//
//  HWHomeCell.m
//  HWProject
//
//  Created by wangqibin on 2018/4/23.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import "HWHomeCell.h"
#import <Masonry/Masonry.h>
#import "HWDownloadButton.h"
#import "DSAwesomeKitTool.h"
@interface HWHomeCell ()
@property(nonatomic, strong) UIButton *checkBtn;             // 选中按钮
@property(nonatomic, strong) UIView *background;             // 底图
@property(nonatomic, strong) UILabel *titleLabel;            // 标题
@property(nonatomic, strong) UILabel *speedLabel;            // 进度标签
@property(nonatomic, strong) UILabel *fileSizeLabel;         // 文件大小标签
@property(nonatomic, strong) HWDownloadButton *downloadBtn;  // 下载按钮
@end

@implementation HWHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tabelView
{
    static NSString *identifier = @"HWHomeCellIdentifier";
    HWHomeCell *cell = [tabelView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HWHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupDefaultSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupDefaultSubViews {
    self.checkBtn = [[UIButton alloc] init];
    [self.checkBtn setImage:[DSAwesomeKitTool imageNamed:@"spUnseleted"] forState:UIControlStateNormal];
    [self.checkBtn setImage:[DSAwesomeKitTool imageNamed:@"spSeleted"] forState:UIControlStateSelected];
    [self.checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkBtn];
    // 底图
    self.background = [[UIView alloc] init];
    self.background.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.background];
    
    // 下载按钮
    self.downloadBtn = [[HWDownloadButton alloc] init];
    self.downloadBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.downloadBtn.layer.borderWidth = 1;
    self.downloadBtn.layer.cornerRadius = 25;
    [self.downloadBtn addTarget:self action:@selector(downBtnOnClick:)];
    [self.background addSubview:self.downloadBtn];

    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.background addSubview:self.titleLabel];
    
    // 进度标签
    self.speedLabel = [[UILabel alloc] init];
    self.speedLabel.font = [UIFont systemFontOfSize:14.f];
    self.speedLabel.textColor = [UIColor blackColor];
    self.speedLabel.textAlignment = NSTextAlignmentRight;
    [self.background addSubview:self.speedLabel];
    
    
    // 文件大小标签
    self.fileSizeLabel = [[UILabel alloc] init];
    self.fileSizeLabel.font = [UIFont systemFontOfSize:14.f];
    self.fileSizeLabel.textColor = [UIColor blackColor];
    self.fileSizeLabel.textAlignment = NSTextAlignmentRight;
    [self.background addSubview:self.fileSizeLabel];
}

- (void)setupConstraints {
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(50);
    }];
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.right.mas_offset(-12);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(12);
        make.right.equalTo(self.downloadBtn.mas_left).offset(-10);
    }];
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.titleLabel.mas_left).offset(0);
    }];
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fileSizeLabel.mas_centerY).offset(0);
        make.left.equalTo(self.fileSizeLabel.mas_right).offset(10);
    }];
}



#pragma mark - checkBtn
- (void)clickCheckBtn:(UIButton *)sender {
    if (self.clickCheckBoxBtn) {
        self.clickCheckBoxBtn(self.model);
    }
}

#pragma mark -
- (void)setHsEditing:(BOOL)hsEditing {
    _hsEditing = hsEditing;
    [self.background mas_updateConstraints:^(MASConstraintMaker *make) {
        if (hsEditing) {
            make.left.mas_offset(50);
        } else {
            make.left.mas_offset(0);
        }
    }];
}

- (void)setHsSelected:(BOOL)hsSelected {
    _hsSelected = hsSelected;
    self.checkBtn.selected = hsSelected;
}

#pragma mark - 赋值
- (void)setModel:(HWDownloadModel *)model {
    _model = model;
    _downloadBtn.model = model;
    _titleLabel.text = model.fileName;
    [self updateViewWithModel:model];
}

// 更新视图
- (void)updateViewWithModel:(HWDownloadModel *)model{
    _downloadBtn.progress = model.progress;
    [self reloadLabelWithModel:model];
}

// 刷新标签
- (void)reloadLabelWithModel:(HWDownloadModel *)model {
    NSString *totalSize = [HWToolBox stringFromByteCount:model.totalFileSize];
    NSString *tmpSize = [HWToolBox stringFromByteCount:model.tmpFileSize];

    if (model.state == HWDownloadStateFinish) {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@", totalSize];
        
    } else {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@ / %@", tmpSize, totalSize];
    }
    _fileSizeLabel.hidden = model.totalFileSize == 0;
    
    if (model.speed > 0) {
        _speedLabel.text = [NSString stringWithFormat:@"%@ / s", [HWToolBox stringFromByteCount:model.speed]];
    }
    _speedLabel.hidden = !(model.state == HWDownloadStateDownloading && model.totalFileSize > 0);
}

- (void)downBtnOnClick:(HWDownloadButton *)btn {
    // do something...
}


@end
