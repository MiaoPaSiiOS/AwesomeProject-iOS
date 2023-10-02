
#import "SRSTextField.h"
#import "SRSTextField+Private.h"

@interface SRSTextField()

@property (nonatomic, assign, readwrite) SRSTextFieldStatus textFieldStatus;

@end

@implementation SRSTextField


#pragma mark - public

- (void)showKeyboard {
    if (![self.textField isFirstResponder]) [self.textField becomeFirstResponder];
    [self changeTextFieldStatus:SRSTextFieldStatusInput];
}

- (void)hidenKeyboard {
    [self.textField resignFirstResponder];
    [self changeTextFieldStatus:SRSTextFieldStatusNormal];
}

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status {
    if ((self.textField.isFirstResponder && status == SRSTextFieldStatusNormal) || (!self.textField.isFirstResponder && status == SRSTextFieldStatusInput)) {
        return;
    }
    self.textFieldStatus = status;
    if (status == SRSTextFieldStatusError) {
        self.clearBtn.alpha = 0;
    }
    if (status == SRSTextFieldStatusDisable) {
        self.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = YES;
    }
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidChangeStatus:status:)]) {
        [self.srsTextFieldDelegate textFieldDidChangeStatus:self status:status];
    }
}

- (void)configTextFieldDefaultText:(NSString *)defaultText {
    self.textField.text = defaultText;
    if (self.textField.isFirstResponder) {
        self.clearBtn.alpha = self.textField.text.length ? 1 : 0;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.textField];
        [self addSubview:self.clearBtn];
        
        kWeakSelf
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf textFieldDidChange];
        }];
        
        self.textFieldStatus = SRSTextFieldStatusNormal;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.clearBtn.alpha = self.textField.text.length ? 1 : 0;
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.srsTextFieldDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.isFirstResponder) {
        [self changeTextFieldStatus:SRSTextFieldStatusInput];
    }
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.srsTextFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.srsTextFieldDelegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearBtn.alpha = 0;
    [self changeTextFieldStatus:SRSTextFieldStatusNormal];
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.srsTextFieldDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason  API_AVAILABLE(ios(10.0)){
    self.clearBtn.alpha = 0;
    [self changeTextFieldStatus:SRSTextFieldStatusNormal];
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [self.srsTextFieldDelegate textFieldDidEndEditing:textField reason:reason];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.srsTextFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.srsTextFieldDelegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.srsTextFieldDelegate && [self.srsTextFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.srsTextFieldDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}
#pragma mark - get & set
- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setBackgroundImage:[DSHelper imageNamed:@"clear" inBundle:[DSHelper findBundleWithBundleName:@"NrSRSTextFieldAssets" podName:@"NrUIComponents"]] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.alpha = 0;
    }
    return _clearBtn;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _textField.textColor = [DSHelper colorWithHexString:@"0x222222"];
        _textField.delegate = self;
    }
    return _textField;
}

@end
