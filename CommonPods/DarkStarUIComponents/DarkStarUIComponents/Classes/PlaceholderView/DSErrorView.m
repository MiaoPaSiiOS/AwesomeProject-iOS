//
//  DSErrorView.m
//  REWLY
//
//  Created by zhuyuhui on 2023/6/1.
//

#import "DSErrorView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarResourceKit/DarkStarResourceKit.h>

@interface DSErrorView()
@property(nonatomic, strong) UILabel *customTextLab;
@end

@implementation DSErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kHexColor(0xFFFFFF);
    }
    return self;
}

- (void)setErrorType:(DSErrorType)errorType {
    [self removeAllSubviews];
    switch (errorType) {
        case DSErrorTypeDefault:
            [self setupDefault];
            break;
        case DSErrorTypeUnavailableNetwork:
            [self setupUnavailableNetwork];
            break;
            
        case DSErrorTypeEmptyData:
            [self setupEmptyData];
            break;
        case DSErrorTypeSeverError:
            [self setupSeverError];
            break;
        default:
            break;
    }
}

#pragma mark - Default
- (void)setupDefault {
    
}

#pragma mark - UnavailableNetwork
- (void)setupUnavailableNetwork {
    [self addSubview:self.customTextLab];
    [self.customTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-30);
    }];
    self.customTextLab.text = @"网络异常~~~";
}

#pragma mark - EmptyData
- (void)setupEmptyData {
    [self addSubview:self.customTextLab];
    [self.customTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-30);
    }];
    self.customTextLab.text = @"暂无数据";

}

#pragma mark - SeverError
- (void)setupSeverError {
    [self addSubview:self.customTextLab];
    [self.customTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.right.mas_offset(-12);
        make.centerY.mas_offset(-30);
    }];
    self.customTextLab.text = @"请求失败，请稍后重试";
}

#pragma mark - 要显示的文案
- (void)setCustomText:(NSString *)customText {
    self.customTextLab.text = customText;
}

#pragma mark - 点击事件
- (void)addTarget:(id)target action:(SEL)action {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

#pragma mark - 懒加载
- (UILabel *)customTextLab {
    if (!_customTextLab) {
        _customTextLab = [[UILabel alloc] init];
        _customTextLab.textColor = kHexColor(0x333333);
        _customTextLab.font = [UIFont systemFontOfSize:14];
        _customTextLab.textAlignment = NSTextAlignmentCenter;
    }
    return _customTextLab;
}
@end
