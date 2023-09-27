
#define kSRSMessageIntervalTextFieldCount 6

#import "SRSMessageIntervalTextField.h"
#import "SRSMessageSingle.h"


@interface SRSMessageIntervalTextField()<SRSMessageSingleDelegate>

@end

@implementation SRSMessageIntervalTextField

#pragma mark - public

- (void)showKeyboard {
    if (![self.textField isFirstResponder]) [self.textField becomeFirstResponder];
    [self changeBottomLabelColorAndCursorAnmation:YES];
}

- (void)hidenKeyboard {
    [self changeBottomLabelColorAndCursorAnmation:NO];
    [self.textField resignFirstResponder];
}

- (NSString *)achiveMessageText {
    return self.textField.text;
}

- (void)changeToErrorStatus {
    for (NSInteger i=0; i<kSRSMessageIntervalTextFieldCount; i++) {
        SRSMessageSingle * aView = (SRSMessageSingle *)[self viewWithTag:1000+i];
        aView.status = eSRSBottomLabelStatusError;
    }
    self.textLabel.textColor = [DSCommonMethods colorWithHexString:@"0xFF4D29"];
    self.textLabel.text = @"短信验证码输入错误";
}

#pragma mark - ui

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, (196/2.));
        self.textLabel.text = @"请输入6位短信验证码";

        self.textField.text = text;
        [self addAllSubViews];
        [self addAllConstraints];
        self.contentView.backgroundColor = [UIColor whiteColor];
        kWeakSelf
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf changeBottomLabelColorAndCursorAnmation:YES];
        }];
        
        [self.sendBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addAllSubViews {
    [self addSubview:self.contentView];
    [self addSubview:self.textField];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.sendBtn];
    
    // 一个的宽、高
    CGFloat aW = (75/2.);
    CGFloat ah = (90/2.);
    // 距离屏幕距离
    CGFloat span = (15);
    // 间距
    CGFloat space = (10);
    SRSMessageSingle *lastView = nil;
    for (NSInteger i=0; i<kSRSMessageIntervalTextFieldCount; i++) {
        CGFloat x = span + (i * aW) + i * space;
        SRSMessageSingle * oneV = [[SRSMessageSingle alloc] init];
        oneV.tag = 1000+i;
        oneV.delegate = self;
        [self.contentView addSubview:oneV];
        oneV.frame = CGRectMake(x, 0, aW, ah);
        kWeakSelf
        if (lastView) {
            [oneV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset((10));
                make.top.equalTo(lastView);
                make.size.mas_equalTo(CGSizeMake((75/2.), (90/2.)));
            }];
        } else {
            [oneV mas_makeConstraints:^(MASConstraintMaker *make) {
                kStrongSelf
                make.top.equalTo(strongSelf.textLabel.mas_bottom);
                make.left.equalTo(strongSelf.contentView);
                make.size.mas_equalTo(CGSizeMake((75/2.), (90/2.)));
            }];
        }
        lastView = oneV;
        if (i < self.textField.text.length) {
            oneV.textLabel.text = [self.textField.text substringWithRange:NSMakeRange(i, 1)];
            oneV.status = eSRSBottomLabelStatusInput;
        } else {
            oneV.status = eSRSBottomLabelStatusDefault;
        }
    }
}

- (void)addAllConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat edge = (15);
        make.edges.mas_equalTo(UIEdgeInsetsMake(edge, edge, edge, edge));
    }];
    
    kWeakSelf
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.left.and.top.equalTo(strongSelf.contentView);
        make.height.mas_equalTo((45/2.));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.right.equalTo(strongSelf.contentView);
        make.top.equalTo(strongSelf.textLabel.mas_bottom).offset((29/2.));
        make.size.mas_equalTo(CGSizeMake((112/2.), (37/2.)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.right.and.top.equalTo(strongSelf);
    }];
}

#pragma mark - private

- (void)changeBottomLabelColorAndCursorAnmation:(BOOL)isStart {
    NSUInteger count = self.textField.text.length;
    for (NSInteger i=0; i<kSRSMessageIntervalTextFieldCount; i++) {
        SRSMessageSingle * aView = (SRSMessageSingle *)[self viewWithTag:1000+i];
        [aView stopAnimaton];
        aView.textLabel.text = i < count ? [[self.textField text] substringWithRange:NSMakeRange(i, 1)] : @"";
        aView.status = i < count ? eSRSBottomLabelStatusInput : eSRSBottomLabelStatusDefault;
    }
    SRSMessageSingle * aView = (SRSMessageSingle *)[self viewWithTag:1000+count];
    if (count < kSRSMessageIntervalTextFieldCount && aView && isStart) {
        [aView startAnimatuon];
        aView.status = eSRSBottomLabelStatusInput;
    }
    self.textLabel.textColor = [DSCommonMethods colorWithHexString:@"0x333333"];
    self.textLabel.text = @"请输入6位短信验证码";
}

#pragma mark - action
- (void)btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageIntervalSendBtnClick:)]) {
        [self.delegate messageIntervalSendBtnClick:self];
    }
}

#pragma mark - delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self changeBottomLabelColorAndCursorAnmation:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hidenKeyboard];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= kSRSMessageIntervalTextFieldCount) {
        if (range.location < kSRSMessageIntervalTextFieldCount) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

- (void)clickBtn:(SRSMessageSingle *)aView {
    [self showKeyboard];
}

#pragma mark - get & set

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(16)];
        _textLabel.textColor = [DSCommonMethods colorWithHexString:@"0x333333"];
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[DSCommonMethods colorWithHexString:@"0x4586FF"] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[DSCommonMethods colorWithHexString:@"0x888888"] forState:UIControlStateDisabled];
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:(13)];
    }
    return _sendBtn;
}


@end
