

#import "SRSMultiLineTextView.h"

@interface SRSMultiLineTextView()<UITextViewDelegate>
@property (nonatomic, assign, readwrite) SRSTextFieldStatus textFieldStatus;

@end

@implementation SRSMultiLineTextView

#pragma mark - public

/// 不要使用textField.text 应该使用这个设置默认值
- (void)configTextFieldDefaultText:(NSString *)defaultText {
    self.textView.text = defaultText;
    if (self.textView.isFirstResponder) {
        self.clearBtn.alpha = self.textView.text.length ? 1 : 0;
    }
}

- (void)changeTextFieldStatus:(SRSTextFieldStatus)status {
    if ((self.textView.isFirstResponder && status == SRSTextFieldStatusNormal) || (!self.textView.isFirstResponder && status == SRSTextFieldStatusInput)) {
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
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textFieldDidChangeStatus:status:)]) {
        [self.srsMultiLineDelegate textViewDidChangeStatus:self status:status];
    }
}
/// 弹起键盘
- (void)showKeyboard {
    if (![self.textView isFirstResponder]) [self.textView becomeFirstResponder];
    [self changeTextFieldStatus:SRSTextFieldStatusInput];
}
/// 收起键盘
- (void)hidenKeyboard {
    [self.textView resignFirstResponder];
    [self changeTextFieldStatus:SRSTextFieldStatusNormal];
}

- (void)changeToErrorStatus {
    self.textView.textColor = [DSCommonMethods colorWithHexString:@"0xFF4D29"];
    self.clearBtn.alpha = 0;
}

#pragma mark - ui

- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, (82));
        self.backgroundColor = [DSCommonMethods colorWithHexString:@"0xffffff"];;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textView];
        [self addSubview:self.clearBtn];
        [self addSubview:self.placeholderLabel];
        [self addSubview:self.lineView];
        kWeakSelf
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.and.top.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-92/2.));
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf.titleLabel.mas_right).offset((21));
            make.top.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-15));
            make.right.equalTo(strongSelf.clearBtn.mas_left).offset((-15));
        }];
        
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.right.equalTo(strongSelf).offset((-15));
            make.size.mas_equalTo(CGSizeMake((21), (21)));
            make.top.equalTo(strongSelf).offset((28));
        }];
        
        
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.left.equalTo(strongSelf.titleLabel.mas_right).offset((27));
            make.top.equalTo(strongSelf).offset((21));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.height.mas_equalTo((1/[UIScreen mainScreen].scale));
            make.left.equalTo(strongSelf).offset((15));
            make.bottom.equalTo(strongSelf).offset((-1/[UIScreen mainScreen].scale));
            make.right.equalTo(strongSelf);
        }];
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];
        self.title = @"";
    }
    return self;
}

#pragma mark - action

- (void)clearBtnClick {
    if (!self.textView.isFirstResponder) [self.textView becomeFirstResponder];
    self.textView.text = @"";
    self.clearBtn.alpha = 0;
    self.placeholderLabel.alpha = 1;
}

#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.clearBtn.alpha = textView.text.length ? 1 : 0;
    self.placeholderLabel.alpha = textView.text.length ? 0 : 1;
    self.textView.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.srsMultiLineDelegate textViewDidChange:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.textView.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
    self.clearBtn.alpha = textView.text.length ? 1 : 0;
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.srsMultiLineDelegate textViewShouldBeginEditing:textView];
    } else {
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.srsMultiLineDelegate textViewShouldEndEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.srsMultiLineDelegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.clearBtn.alpha = 0;
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.srsMultiLineDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.srsMultiLineDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    } else {
        return YES;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.srsMultiLineDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.srsMultiLineDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    } else {
    return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        return [self.srsMultiLineDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    } else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange  {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.srsMultiLineDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    } else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if (self.srsMultiLineDelegate && [self.srsMultiLineDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.srsMultiLineDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    } else {
        return YES;
    }
}
#pragma mark - get & set
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _titleLabel.textColor = [DSCommonMethods colorWithHexString:@"0x333333"];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [DSCommonMethods colorWithHexString:@"0xE8E8E8"];
    }
    return _lineView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _textView.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _textView;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setBackgroundImage:[NSBundle ds_imageNamed:@"clear" inBundle:[NSBundle ds_bundleName:@"NrSRSTextFieldAssets" inPod:@"NrUIComponents"]] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.alpha = 0;
    }
    return _clearBtn;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _placeholderLabel.textColor = [DSCommonMethods colorWithHexString:@"0xCCCCCC"];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _placeholderLabel;
}

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) return;
    _title = title;
    self.titleLabel.text = title;
    kWeakSelf
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        if (title.length) {
            make.left.equalTo(strongSelf.titleLabel.mas_right).offset((27));
        } else {
            make.left.equalTo(strongSelf).offset((21));
        }
        make.top.equalTo(strongSelf).offset((15));
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if ([_placeholder isEqualToString:placeholder]) return;
    self.placeholderLabel.text = placeholder;
}


@end
