//
//  AresJsbWebErrorView.m
//  DarkStarWebKit
//
//  Created by zhuyuhui on 2023/9/16.
//

#import "AresJsbWebErrorView.h"
#import "Masonry.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@interface AresJsbWebErrorView ()<UIGestureRecognizerDelegate >
@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UILabel *titleLab;
@property(nonatomic ,strong) UILabel *subtitleLab;
@property(nonatomic ,strong) UIButton *reloadBtn;

@end

@implementation AresJsbWebErrorView

- (void)removeAllSubviews{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
        child = nil;
    }
}

- (void)setType:(AresJsbWebErrorViewType)type {
    _type = type;
    [self removeAllSubviews];
    switch (type) {
        case AresJsbWebErrorViewNoData:
            [self setDefaultNoData];
            break;
        case AresJsbWebErrorViewServerError:
            [self setDefaultServerError];
            break;
        case AresJsbWebErrorViewNetworkNotReachable:
            [self setDefaultNetworkNotReachable];
            break;
        default:
            break;
    }
}


#pragma mark 无数据
- (void)setDefaultNoData {
    self.backgroundColor = kHexColor(0xffffff);
    [self addSubview:self.imageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.subtitleLab];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(240, 180));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    
    self.imageView.image = [UIImage ds_imageWithColor:[UIColor lightGrayColor]];
    self.titleLab.text = @"哎呀！暂无数据";
    self.subtitleLab.text = @"稍后再试试吧～";
}

#pragma mark 服务器错误
- (void)setDefaultServerError {
    self.backgroundColor = kHexColor(0xffffff);
    [self addSubview:self.imageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.subtitleLab];
    [self addSubview:self.reloadBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(240, 180));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLab.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    self.imageView.image = [UIImage ds_imageWithColor:[UIColor lightGrayColor]];
    self.titleLab.text = @"哎呀！加载失败";
    self.subtitleLab.text = @"稍后再试试吧～";
}

#pragma mark 无网络连接
- (void)setDefaultNetworkNotReachable {
    self.backgroundColor = kHexColor(0xffffff);
    [self addSubview:self.imageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.subtitleLab];
    [self addSubview:self.reloadBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(240, 180));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLab.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    self.imageView.image = [UIImage ds_imageWithColor:[UIColor lightGrayColor]];
    self.titleLab.text = @"哎呀！没信号了呢";
    self.subtitleLab.text = @"刷新一下试试吧～";
    
}



#pragma mark event
- (void)clickReloadBtn:(id)sender{
    if (self.refreshHandle) {
        self.refreshHandle(self);
    }
}


- (void)setMOffset:(CGFloat)offset {
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40+offset);
    }];
}

#pragma mark Lazy Init
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = kHexColor(0x000000);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    }
    return _titleLab;
}

- (UILabel *)subtitleLab {
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.textColor = kHexColor(0x888888);
        _subtitleLab.textAlignment = NSTextAlignmentCenter;
        _subtitleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];;
    }
    return _subtitleLab;
}

- (UIButton *)reloadBtn {
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];;
        _reloadBtn.layer.masksToBounds = YES;
        _reloadBtn.layer.cornerRadius = 20;
        _reloadBtn.layer.borderWidth = 1;
        _reloadBtn.layer.borderColor = kHexColor(0x4586ff).CGColor;
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:kHexColor(0x2f71eb) forState:UIControlStateHighlighted];
        [_reloadBtn setTitleColor:kHexColor(0x4586ff) forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(clickReloadBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}

@end

