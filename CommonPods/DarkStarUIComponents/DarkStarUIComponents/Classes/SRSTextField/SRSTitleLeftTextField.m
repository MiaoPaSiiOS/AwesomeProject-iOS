

#import "SRSTitleLeftTextField.h"
#import "SRSTextField+Private.h"

@interface SRSTitleLeftTextField()


@end

@implementation SRSTitleLeftTextField

#pragma mark - ui

- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, DSDeviceInfo.screenWidth, (51));
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];

        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.and.top.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-15));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.top.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-15));
            make.right.equalTo(strongSelf.clearBtn.mas_left).offset((-15));
        }];
        
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.right.equalTo(strongSelf).offset((-15));
            make.size.mas_equalTo(CGSizeMake((21), (21)));
            make.centerY.equalTo(strongSelf);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.height.mas_equalTo((1/[UIScreen mainScreen].scale));
            make.left.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-1/[UIScreen mainScreen].scale));
            make.right.equalTo(strongSelf);
        }];
        
//        self.textField.delegate = self;
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];

        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return self;
}

#pragma mark - override

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status {
    [super changeTextFieldStatus:status];
    if (status == SRSTextFieldStatusNormal) {
        self.textField.textColor = [DSHelper colorWithHexString:@"0x222222"];
    } else if (status == SRSTextFieldStatusInput) {
        self.textField.textColor = [DSHelper colorWithHexString:@"0x222222"];
    } else if (status == SRSTextFieldStatusError) {
        self.textField.textColor = [DSHelper colorWithHexString:@"0xFF4D29"];
    } else {
        self.textField.textColor = [DSHelper colorWithHexString:@"0x888888"];
    }
}

- (void)clearBtnClick {
    [super clearBtnClick];
}

- (void)textFieldDidChange {
    [super textFieldDidChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textField.textColor = [DSHelper colorWithHexString:@"0x222222"];
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

#pragma mark - get & set
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _titleLabel.textColor = [DSHelper colorWithHexString:@"0x333333"];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [DSHelper colorWithHexString:@"0xE8E8E8"];
    }
    return _lineView;
}

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) return;
    _title = title;
    self.titleLabel.text = title;
    kWeakSelf
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        if (title.length) {
            make.left.equalTo(strongSelf.titleLabel.mas_right).offset((21));
        } else {
            make.left.equalTo(strongSelf).offset((15));
        }
        make.top.equalTo(strongSelf).offset((15));
        make.bottom.equalTo(strongSelf).offset((-15));
        make.right.equalTo(strongSelf.clearBtn.mas_left).offset((-15));
    }];
}


@end
