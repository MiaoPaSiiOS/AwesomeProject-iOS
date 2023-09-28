//
//  DSDownSheetView.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/7/8.
//

#import "DSDownSheetView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@interface DSDownSheetView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) UIImage *leftImage;
@property (nonatomic, copy) UIImage *rightImage;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation DSDownSheetView

- (instancetype)initWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle contentHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        // 标题
        self.title = title;
        // 左按钮标题
        self.leftTitle = leftTitle;
        // 右按钮标题
        self.rightTitle = rightTitle;
        // 内容高度
        self.contentHeight = height;
        [self buildUI];
        [self makeConstraints];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage  contentHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        // 标题
        self.title = title;
        //左按钮标题
        self.leftImage = leftImage;
        //右按钮标题
        self.rightImage = rightImage;
        // 内容高度
        self.contentHeight = height;
        [self buildUI];
        [self makeConstraints];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    if ([DSCommonMethods safeString:(self.leftTitle)].length || self.leftImage) {
        [self.titleView addSubview:self.leftButton];
    }
    if ([DSCommonMethods safeString:(self.rightTitle)].length || self.rightImage) {
        [self.titleView addSubview:self.rightButton];
    }
    [self.contentView addSubview:self.listView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewDismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)makeConstraints {
    self.contentHeight = self.contentHeight ?: (422);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_offset(self.contentHeight);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.contentView);
        make.height.mas_equalTo((44));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(self.contentHeight - (44));
    }];
    
    BOOL hasLeftButton = [DSCommonMethods safeString:(self.leftTitle)].length || self.leftImage;
    BOOL hasRightButton = [DSCommonMethods safeString:(self.rightTitle)].length || self.rightImage;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.titleView);
        make.left.greaterThanOrEqualTo(hasLeftButton ? self.leftButton : self.titleView).offset((15));
        make.right.greaterThanOrEqualTo(hasRightButton ? self.rightButton : self.titleView).offset((-15));
    }];
    if (hasLeftButton) {
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.left.equalTo(self.titleView).offset((15));
        }];
    }
    if (hasRightButton) {
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.right.equalTo(self.titleView).offset((-15));
        }];
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
#pragma mark - 标题栏
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

#pragma mark - 标题栏
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        // 标题头
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

#pragma mark - 标题取消按钮
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitleColor:[DSCommonMethods colorWithHexString:@"0x2072cf"]  forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        if ([DSCommonMethods safeString:(self.leftTitle)].length) {
            [_leftButton setTitle:self.leftTitle forState:UIControlStateNormal];
        }
        if (self.leftImage) {
            [_leftButton setImage:self.leftImage forState:UIControlStateNormal];
        }
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

#pragma mark - 右按钮
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:[DSCommonMethods colorWithHexString:@"0x2072cf"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        if ([DSCommonMethods safeString:(self.rightTitle)].length) {
            [_rightButton setTitle:self.rightTitle forState:UIControlStateNormal];
        }
        if (self.rightImage) {
            [_rightButton setImage:self.rightImage forState:UIControlStateNormal];
        }
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - 展示列表
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.bounces = NO;
        _listView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _listView.separatorColor = [DSCommonMethods colorWithHexString:@"0xE8E8E8"];
        _listView.estimatedRowHeight = 0;
        _listView.estimatedSectionHeaderHeight = 0;
        _listView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else if (@available(iOS 13.0, *)) {
            _listView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        // iOS15 section头部的处理
    #ifndef __IPHONE_15_0
    #define __IPHONE_15_0 150000
    #endif
    #if (__IPHONE_OS_VERSION_MAX_ALLOWED  >= __IPHONE_15_0)
        if (@available(iOS 15.0, *)) {
            _listView.sectionHeaderTopPadding = 0;
        }
    #endif
    }
    return _listView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(downSheetView:numberOfRowsInSection:)]) {
        return [self.dataSource downSheetView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(downSheetView:cellForIndexPath:)]) {
        return [self.dataSource downSheetView:self cellForIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(downSheetView:heightForRowAtIndexPath:)]) {
        return [self.delegate downSheetView:self heightForRowAtIndexPath:indexPath];
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(downSheetView:didSelectIndexPath:)]) {
        [self.delegate downSheetView:self didSelectIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 点击取消事件
- (void)leftButtonClick:(UIButton *)button {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(downSheetLeftButtonClick:)]) {
        [self.delegate downSheetLeftButtonClick:button];
    } else {
        [self fadeOut];
    }
}

- (void)rightButtonClick:(UIButton *)button {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(downSheetRightButtonClick:)]) {
        [self.delegate downSheetRightButtonClick:button];
    }else{
        [self fadeOut];
    }
}

#pragma mark - 点击遮罩层事件
- (void)overlayViewDismiss {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(overlayViewDismiss)]) {
        [self.delegate overlayViewDismiss];
    } else {
        [self fadeOut];
    }
}

#pragma mark --  消失动画
- (void)fadeOut {
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.top = self.bottom;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- 弹出展示
- (void)showInViewController:(UIViewController *)viewController {
    UIView *superView = viewController.view;
    if (superView == nil) {
        superView = [[UIApplication sharedApplication] keyWindow];
    }
    [superView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contentView.top = self.bottom;
        [UIView animateWithDuration:0.3f animations:^{
            self.contentView.bottom = self.bottom;
        }];
    });
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        // 如果是点击的是content view，则关闭手势
        return NO;
    }
    return YES;
}

@end
