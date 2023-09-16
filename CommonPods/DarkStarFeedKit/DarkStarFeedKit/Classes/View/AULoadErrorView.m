//
//  AULoadErrorView.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2021/11/19.
//

#import "AULoadErrorView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "AmenFeedTool.h"

@interface AULoadErrorView ()<UIGestureRecognizerDelegate >
/// 无网络显示的横幅Banner
@property(nonatomic, strong) UIView *networkNotReachableBanner;
@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UILabel *titleLab;
@property(nonatomic ,strong) UILabel *subtitleLab;
@property(nonatomic ,strong) UIButton *reloadBtn;

@end

@implementation AULoadErrorView

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
        case AULoadNoData:
            [self setDefaultNoData];
            break;
        case AULoadServerError:
            [self setDefaultServerError];
            break;
        case AULoadNetworkNotReachable:
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
    
    self.imageView.image = [AmenFeedTool imageNamed:@"SystemErrorImage"];
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
    
    self.imageView.image = [AmenFeedTool imageNamed:@"SystemErrorImage"];
    self.titleLab.text = @"哎呀！加载失败";
    self.subtitleLab.text = @"稍后再试试吧～";
}

#pragma mark 无网络连接
- (void)setDefaultNetworkNotReachable {
    self.backgroundColor = kHexColor(0xffffff);
    [self addSubview:self.networkNotReachableBanner];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.subtitleLab];
    [self addSubview:self.reloadBtn];
    
    [self.networkNotReachableBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self).offset(0);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
    }];
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
    
    self.imageView.image = [AmenFeedTool imageNamed:@"NetworkNotReachableImage"];
    self.titleLab.text = @"哎呀！没信号了呢";
    self.subtitleLab.text = @"刷新一下试试吧～";
    
}



#pragma mark event
- (void)goQuestion:(id)sender{

}

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
- (UIView *)networkNotReachableBanner {
    if (!_networkNotReachableBanner) {
        _networkNotReachableBanner = [[UIView alloc] init];
        _networkNotReachableBanner.backgroundColor = [UIColor colorWithRed:69/255.0 green:134/255.0 blue:255/255.0 alpha:0.1/1.0];;
        //icon
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [AmenFeedTool imageNamed:@"ExclamatoryMark"];
        [_networkNotReachableBanner addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(imageView.superview.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        //title
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = kHexColor(0x4586ff);
        titleLab.text = @"当前网络不可用，请检查你的网络";
        [_networkNotReachableBanner addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right);
            make.right.equalTo(titleLab.superview).offset(-30);
            make.centerY.equalTo(titleLab.superview.mas_centerY);
        }];
        //arrow
        UIImageView *arrowRightImg = [[UIImageView alloc] init];
        arrowRightImg.image = [AmenFeedTool imageNamed:@"ErrorPageRightArrow"];
        [_networkNotReachableBanner addSubview:arrowRightImg];
        [arrowRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 13));
            make.right.equalTo(arrowRightImg.superview).offset(-15);
            make.centerY.equalTo(titleLab.superview.mas_centerY);
        }];
        
        UITapGestureRecognizer *gestureRecognizerSet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goQuestion:)];
        [_networkNotReachableBanner addGestureRecognizer:gestureRecognizerSet];
    }
    return _networkNotReachableBanner;
}

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
