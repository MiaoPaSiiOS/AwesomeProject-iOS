
#import "SRSTitleDownTexField.h"
#import "SRSTextField+Private.h"

@interface SRSTitleDownTexField()

@end

@implementation SRSTitleDownTexField

#pragma mark - ui
- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.flagLabel];
        [self addSubview:self.lineLabel];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.bottomLabel];
        
        
        self.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, (281/2.));

        self.textField.font = [UIFont fontWithName:@"DINAlternate-Bold" size:(73/2.)];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.clipsToBounds = YES;
        
        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.and.top.equalTo(strongSelf).offset((15));
            make.height.mas_equalTo((37/2.));
        }];
        
        [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset((57/2.));
            make.bottom.equalTo(strongSelf.lineLabel.mas_top).offset(-(10));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset((25/2.));
            make.bottom.equalTo(strongSelf.lineLabel.mas_top).offset(-(5/2.));
        }];
        
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf.textField.mas_right).offset((15));
            make.centerY.equalTo(strongSelf.textField);
            make.size.mas_equalTo(CGSizeMake((21), (21)));
            make.right.equalTo(strongSelf).offset(-(15));
        }];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.right.equalTo(strongSelf).offset(-(15));
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf).offset((15));
            make.top.equalTo(strongSelf.lineLabel.mas_bottom).offset((11));
            make.bottom.equalTo(strongSelf).offset(-(21/2.));
        }];
        
        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.centerY.equalTo(strongSelf.bottomLabel);
            make.left.equalTo(strongSelf).offset((15));
        }];
        
        
        UIView *aView = [[UIView alloc] init];
        [self addSubview:aView];
        
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.right.equalTo(strongSelf).offset(-(15));
            make.left.equalTo(strongSelf.bottomBtn.mas_right);
            make.centerY.equalTo(strongSelf.bottomBtn);
            make.height.equalTo(strongSelf.bottomBtn);
        }];
        [self.flagLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];
        [self.flagLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.bottomBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

#pragma mark - action

- (void)btnClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

#pragma mark - override

- (void)configTextFieldDefaultText:(NSString *)defaultText {
    [super configTextFieldDefaultText:defaultText];
}

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status {
    [super changeTextFieldStatus:status];
    if (status == SRSTextFieldStatusNormal) { // 正常
        self.lineLabel.backgroundColor = [DSCommonMethods colorWithHexString:@"0x444444"];
    } else if (status == SRSTextFieldStatusInput) { // 输入
        self.lineLabel.backgroundColor = [DSCommonMethods colorWithHexString:@"0x4586FF"];
    } else if (status == SRSTextFieldStatusError) { // 报错
        self.lineLabel.backgroundColor = [DSCommonMethods colorWithHexString:@"0xFF4D29"];
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
    self.textField.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
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

#pragma mark - set & get

- (void)setFlagText:(NSString *)flagText {
    if ([_flagText isEqualToString:flagText]) return;
    _flagText = flagText;
    self.flagLabel.text = flagText;
    kWeakSelf
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        if (flagText.length) {
            make.left.equalTo(strongSelf.flagLabel.mas_right).offset((13/2.));
        } else {
            make.left.equalTo(strongSelf).offset((15));
        }
        make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset((25/2.));
        make.bottom.equalTo(strongSelf.lineLabel.mas_top).offset(-(5/2.));
    }];
}

- (void)setAttributeString:(NSMutableAttributedString *)attributeString {
    if ([_attributeString isEqualToAttributedString:attributeString]) return;
    _attributeString = attributeString;
    self.bottomLabel.attributedText = attributeString;
    kWeakSelf
    [self.bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        if (attributeString.length) {
            make.left.equalTo(strongSelf.bottomLabel.mas_right).offset((10));
        } else {
            make.left.equalTo(strongSelf).offset((15));
        }
        make.centerY.equalTo(strongSelf.bottomLabel);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(13)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
    }
    return _titleLabel;
}

- (UILabel *)flagLabel {
    if (!_flagLabel) {
        _flagLabel = [[UILabel alloc] init];
        _flagLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:(24)];
        _flagLabel.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
    }
    return _flagLabel;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [DSCommonMethods colorWithHexString:@"0x444444"];
    }
    return _lineLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
    }
    return _bottomLabel;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitleColor:[DSCommonMethods colorWithHexString:@"0x4586FF"] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(13)];
    }
    return _bottomBtn;
}


@end
