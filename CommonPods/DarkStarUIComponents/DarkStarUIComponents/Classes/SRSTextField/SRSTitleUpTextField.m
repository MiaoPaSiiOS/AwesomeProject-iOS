
#import "SRSTitleUpTextField.h"
#import "SRSTextField+Private.h"

@interface SRSTitleUpTextField()


@end

@implementation SRSTitleUpTextField

#pragma mark - ui
- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        
        self.frame = CGRectMake(0, 0, [DSCommonMethods screenWidth], (196/2.));
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineLabel];
        self.textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(24)];

        
        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.and.top.equalTo(strongSelf).offset((15));
            make.height.mas_equalTo((45/2.));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset((13/2.));
            make.right.equalTo(strongSelf.clearBtn.mas_left).offset((-15));
        }];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.right.equalTo(strongSelf).offset((-15));
            make.top.equalTo(strongSelf.textField.mas_bottom).offset((9.5/2.));
        }];
        
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.size.mas_equalTo(CGSizeMake((21), (21)));
            make.right.equalTo(strongSelf).offset((-15));
            make.centerY.equalTo(strongSelf.textField);
        }];
    }
    return self;
}

#pragma mark - override

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status {
    [super changeTextFieldStatus:status];
    if (status == SRSTextFieldStatusNormal) { // 正常
        self.lineLabel.backgroundColor = kHexColor(0x444444);
        self.titleLabel.textColor = kHexColor(0x333333);
        self.titleLabel.text = self.title;
    } else if (status == SRSTextFieldStatusInput) { // 输入
        self.lineLabel.backgroundColor = kHexColor(0x4586FF);
        self.titleLabel.textColor = kHexColor(0x333333);
        self.titleLabel.text = self.title;
    } else if (status == SRSTextFieldStatusError) { // 报错
        self.lineLabel.backgroundColor = kHexColor(0xFF4D29);
        self.titleLabel.textColor = kHexColor(0xFF4D29);
        self.titleLabel.text = self.errorTitle;
    } else {
        
    }
}

- (void)clearBtnClick {
    [super clearBtnClick];
}

- (void)textFieldDidChange {
    [super textFieldDidChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textField.textColor = kHexColor(0x222222);
    return [super textFieldShouldBeginEditing:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [super textFieldShouldEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    [super textFieldDidEndEditing:textField reason:reason];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return [super textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [super textFieldShouldReturn:textField];
}

#pragma mark get & set

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(16)];
        _titleLabel.textColor = kHexColor(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = kHexColor(0x444444);
    }
    return _lineLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self changeTextFieldStatus:self.textFieldStatus];
}

- (void)setErrorTitle:(NSString *)errorTitle {
    _errorTitle = errorTitle;
    [self changeTextFieldStatus:self.textFieldStatus];
}

@end
