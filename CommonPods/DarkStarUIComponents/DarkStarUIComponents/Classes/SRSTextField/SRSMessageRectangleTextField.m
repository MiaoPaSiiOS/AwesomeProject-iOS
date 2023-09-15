
#define kSRSMessageRectangleTextFieldCount 6


#import "SRSMessageRectangleTextField.h"

@interface SRSMessageRectangleTextField()


@end

@implementation SRSMessageRectangleTextField

#pragma mark - public

- (void)showKeyboard {
    if (![self.textField isFirstResponder]) [self.textField becomeFirstResponder];
}

- (void)hidenKeyboard {
    [self.textField resignFirstResponder];
}

- (void)showBottomView {
    [self.bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (87/2.)));
    }];
    self.bottomLabel.hidden = NO;
    self.size = CGSizeMake(kScreenWidth, (51)+(87/2.));
}

- (void)hidenBottomView {
    [self.bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0));
    }];
    self.bottomLabel.hidden = YES;
    self.size = CGSizeMake(kScreenWidth, (51));
}

- (NSString *)achiveMessageText {
    return self.textField.text;
}

- (void)changeToErrorStatus {
    self.textField.textColor = kHexColor(0xFF4D29);
}

#pragma mark - ui
- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, (51));
        self.clipsToBounds = YES;
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self.topView addSubview:self.textField];
        [self.topView addSubview:self.lineLabel];
        [self.topView addSubview:self.sendBtn];
        [self.topView addSubview:self.clearBtnImage];
        [self addSubview:self.bottomContentView];
        [self.bottomContentView addSubview:self.bottomLabel];
        self.bottomContentView.clipsToBounds = YES;
        
        kWeakSelf
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.left.and.top.and.right.equalTo(strongSelf);
            make.height.mas_equalTo((51));
        }];
        
         [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             kStrongSelf
             make.left.equalTo(strongSelf.topView).offset((15));
             make.centerY.equalTo(strongSelf.topView);
         }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf.titleLabel.mas_right).offset((21));
            make.centerY.equalTo(strongSelf.topView);
            make.right.equalTo(strongSelf.clearBtnImage.mas_left).offset(-(15));
        }];
         
         [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             kStrongSelf
             make.right.equalTo(strongSelf.sendBtn.mas_left).offset(-(15));
             make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
             make.top.and.bottom.equalTo(strongSelf.topView);
         }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.centerY.equalTo(strongSelf.topView);
            make.size.mas_equalTo(CGSizeMake((75), (21)));
            make.right.equalTo(strongSelf.topView.mas_right).offset(-(15));
        }];
        
        [self.clearBtnImage mas_makeConstraints:^(MASConstraintMaker *make) {
           kStrongSelf
            make.right.equalTo(strongSelf.lineLabel.mas_left).offset((-15));
            make.centerY.equalTo(strongSelf.topView);
            make.size.mas_equalTo(CGSizeMake((21), (21)));
        }];
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];
        
        [self.sendBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, (87/2.)));
            make.left.and.right.equalTo(strongSelf);
            make.top.equalTo(strongSelf.topView.mas_bottom);
        }];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.equalTo(strongSelf.bottomContentView).offset((15));
            make.top.equalTo(strongSelf.bottomContentView).offset((15));
            make.right.equalTo(strongSelf.bottomContentView).offset((-15));
            make.height.mas_equalTo((37/2.));
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.clearBtnImage.alpha = weakSelf.textField.text.length ? 1 : 0;
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - action

- (void)btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageRectangleSendBtnClick:)]) {
        [self.delegate messageRectangleSendBtnClick:self];
    }
}

- (void)clearBtnClick {
    if (!self.textField.isFirstResponder) [self.textField becomeFirstResponder];
    self.textField.text = @"";
    self.clearBtnImage.alpha = 0;
}

#pragma mark - delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textField.textColor = kHexColor(0x222222);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= kSRSMessageRectangleTextFieldCount) {
        if (range.location < kSRSMessageRectangleTextFieldCount) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - set & get

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kHexColor(0x444444);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _titleLabel.text = @"验证码";
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入验证码";
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
        _textField.textColor = kHexColor(0x222222);
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = kHexColor(0xE8E8E8);
    }
    return _lineLabel;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kHexColor(0x4586FF) forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kHexColor(0x888888) forState:UIControlStateDisabled];
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(15)];
    }
    return _sendBtn;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = kHexColor(0x888888);
        _bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(13)];
    }
    return _bottomLabel;
}

- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
        _bottomContentView.backgroundColor = [UIColor colorWithRed:244/250. green:246/250. blue:248/250. alpha:1];
    }
    return _bottomContentView;
}

- (UIButton *)clearBtnImage {
    if (!_clearBtnImage) {
        _clearBtnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtnImage setBackgroundImage:[NSBundle ds_imageNamed:@"clear" inBundle:[NSBundle ds_bundleName:@"NrSRSTextFieldAssets" inPod:@"NrUIComponents"]] forState:UIControlStateNormal];
        [_clearBtnImage addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtnImage.alpha = 0;
    }
    return _clearBtnImage;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

@end
