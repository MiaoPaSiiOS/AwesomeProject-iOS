//
//  NrBaseDialogView.m
//  Animations
//
//  Created by YouXianMing on 2017/11/29.
//  Copyright © 2017年 YouXianMing. All rights reserved.
//

#import "NrBaseDialogView.h"

@interface NrBaseDialogView ()
@property (nonatomic, assign) BOOL animateFlag;
@property (nonatomic, strong) UIView   *container;
@property (nonatomic, strong) UIButton *background;
@end

@implementation NrBaseDialogView

// 这里主动释放一些空间，加速内存的释放，防止有时候消失之后，再点不出来。
- (void)dealloc {
    NSLog(@"%@ --> dealloc",[self class]);
    [self.background removeFromSuperview];
    [self.container removeFromSuperview];
}

#pragma mark - 布局UI

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.background];
        [self addSubview:self.container];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
        
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.left.right.mas_offset(0);
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.animateFlag = YES;
    if (self.dialogWillShow) {
        self.dialogWillShow(self);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.animateFlag = NO;
    if (self.dialogDidShow) {
        self.dialogDidShow(self);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.animateFlag = YES;
    if (self.dialogWillHide) {
        self.dialogWillHide(self);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.animateFlag = NO;
    if (self.dialogDidHide) {
        self.dialogDidHide(self);
    }
}

#pragma mark - 添加子视图
- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"示例";
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.container addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(300);
    }];
}


#pragma mark - 展示 & 隐藏
- (void)showInView:(UIView *)superiorView {
    [self setupView];
    [self viewWillAppear:YES];
    [self layoutIfNeeded];
    //添加自身
    [superiorView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    
    //重置
    self.background.alpha = 0.f ;
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(self.container.height);
    }];
    
    //重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.background.alpha = 1.0f ;
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self viewDidAppear:YES];
    }];
}

- (void)dismisView {
    [self viewWillDisappear:YES];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.background.alpha = 0.0f ;
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(self.container.height);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self viewDidDisappear:YES];
        [self removeFromSuperview];
    }];
}

- (void)dissMiss {
    if (self.animateFlag) return;
    [self dismisView];
}

#pragma mark - 懒加载
- (UIButton *)background {
    if (!_background) {
        _background = [[UIButton alloc] init];
        _background.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5f];
        _background.alpha = 0.0f;
        [_background addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _background;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

@end
