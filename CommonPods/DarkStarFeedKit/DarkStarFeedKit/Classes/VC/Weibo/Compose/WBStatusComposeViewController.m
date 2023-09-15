//
//  WBStatusComposeViewController.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/21.
//

#import "WBStatusComposeViewController.h"
#import "WBEmoticonInputView.h"
#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"
#import "WBStatusLayout.h"
#import <YYText/YYText.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#define kToolbarHeight (35 + 46)

@interface WBStatusComposeViewController() <YYTextViewDelegate, YYTextKeyboardObserver, WBStatusComposeEmoticonViewDelegate>
@property (nonatomic, strong) UIButton *navbarCancleButton;
@property (nonatomic, strong) UIButton *navbarPublishButton;
@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarBackground;
@property (nonatomic, strong) UIButton *toolbarPOIButton;
@property (nonatomic, strong) UIButton *toolbarGroupButton;
@property (nonatomic, strong) UIButton *toolbarPictureButton;
@property (nonatomic, strong) UIButton *toolbarAtButton;
@property (nonatomic, strong) UIButton *toolbarTopicButton;
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;
@property (nonatomic, strong) UIButton *toolbarExtraButton;
@property (nonatomic, assign) BOOL isInputEmoticon;

@end

@implementation WBStatusComposeViewController

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self ldzfSetUpNavigationItems];
    [self _initTextView];
    [self _initToolbar];
//    [_textView becomeFirstResponder];
}

- (void)ldzfSetUpNavigationItems {
    [self.appBar.navigationBar addSubview:self.navbarCancleButton];
    [self.appBar.navigationBar addSubview:self.navbarPublishButton];
//
//
//    [self.appBar setLeftItems:@[self.navbarCancleButton]];
//    [self.appBar setRightItems:@[self.navbarPublishButton]];
    switch (_type) {
        case WBStatusComposeViewTypeStatus: {
            self.title = @"发微博";
        } break;
        case WBStatusComposeViewTypeRetweet: {
            self.title = @"转发微博";
        } break;
        case WBStatusComposeViewTypeComment: {
            self.title = @"发评论";
        } break;
    }
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.top = 0;
    _textView.size = CGSizeMake(self.nrView.width, self.nrView.height);
    _textView.textContainerInset = UIEdgeInsetsMake(0, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(0, 0, kToolbarHeight + 44, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textParser = [WBStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:17];
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = nil;
    switch (_type) {
        case WBStatusComposeViewTypeStatus: {
            placeholderPlainText = @"分享新鲜事...";
        } break;
        case WBStatusComposeViewTypeRetweet: {
            placeholderPlainText = @"说说分享心得...";
        } break;
        case WBStatusComposeViewTypeComment: {
            placeholderPlainText = @"写评论...";
        } break;
    }
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.yy_color = kHexColor(0xb4b4b4);
        atr.yy_font = [UIFont systemFontOfSize:17];
        _textView.placeholderAttributedText = atr;
    }
    
    [self.nrView addSubview:_textView];
}

- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.size = CGSizeMake(self.nrView.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    
    _toolbarBackground = [UIView new];
    _toolbarBackground.backgroundColor = kHexColor(0xF9F9F9);
    _toolbarBackground.size = CGSizeMake(_toolbar.width, 46);
    _toolbarBackground.bottom = _toolbar.height;
    _toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolbar addSubview:_toolbarBackground];
    
    _toolbarBackground.height = 300; // extend
    
    UIView *line = [UIView new];
    line.backgroundColor = kHexColor(0xBFBFBF);
    line.width = _toolbarBackground.width;
    line.height = LINE_HEIGHT;
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_toolbarBackground addSubview:line];
    
    _toolbarPOIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolbarPOIButton.size = CGSizeMake(88, 26);
    _toolbarPOIButton.centerY = 35 / 2.0;
    _toolbarPOIButton.left = 5;
    _toolbarPOIButton.clipsToBounds = YES;
    _toolbarPOIButton.layer.cornerRadius = _toolbarPOIButton.height / 2;
    _toolbarPOIButton.layer.borderColor = kHexColor(0xe4e4e4).CGColor;
    _toolbarPOIButton.layer.borderWidth = LINE_HEIGHT;
    _toolbarPOIButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _toolbarPOIButton.adjustsImageWhenHighlighted = NO;
    [_toolbarPOIButton setTitle:@"显示位置 " forState:UIControlStateNormal];
    [_toolbarPOIButton setTitleColor:kHexColor(0x939393) forState:UIControlStateNormal];
    [_toolbarPOIButton setImage:[WBStatusHelper imageNamed:@"compose_locatebutton_ready"] forState:UIControlStateNormal];
    [_toolbarPOIButton setBackgroundImage:[UIImage ds_imageWithColor:kHexColor(0xf8f8f8)] forState:UIControlStateNormal];
    [_toolbarPOIButton setBackgroundImage:[UIImage ds_imageWithColor:kHexColor(0xe0e0e0)] forState:UIControlStateHighlighted];
    [_toolbar addSubview:_toolbarPOIButton];
    
    _toolbarGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolbarGroupButton.size = CGSizeMake(62, 26);
    _toolbarGroupButton.centerY = 35 / 2.0;
    _toolbarGroupButton.right = _toolbar.width - 5;
    _toolbarGroupButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _toolbarGroupButton.clipsToBounds = YES;
    _toolbarGroupButton.layer.cornerRadius = _toolbarGroupButton.height / 2;
    _toolbarGroupButton.layer.borderColor = kHexColor(0xe4e4e4).CGColor;
    _toolbarGroupButton.layer.borderWidth = LINE_HEIGHT;
    _toolbarGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _toolbarGroupButton.adjustsImageWhenHighlighted = NO;
    [_toolbarGroupButton setTitle:@"公开 " forState:UIControlStateNormal];
    [_toolbarGroupButton setTitleColor:kHexColor(0x527ead) forState:UIControlStateNormal];
    [_toolbarGroupButton setImage:[WBStatusHelper imageNamed:@"compose_publicbutton"] forState:UIControlStateNormal];
    [_toolbarGroupButton setBackgroundImage:[UIImage ds_imageWithColor:kHexColor(0xf8f8f8)] forState:UIControlStateNormal];
    [_toolbarGroupButton setBackgroundImage:[UIImage ds_imageWithColor:kHexColor(0xe0e0e0)] forState:UIControlStateHighlighted];
    [_toolbar addSubview:_toolbarGroupButton];
    
    _toolbarPictureButton = [self _toolbarButtonWithImage:@"compose_toolbar_picture"
                                                highlight:@"compose_toolbar_picture_highlighted"];
    _toolbarAtButton = [self _toolbarButtonWithImage:@"compose_mentionbutton_background"
                                           highlight:@"compose_mentionbutton_background_highlighted"];
    _toolbarTopicButton = [self _toolbarButtonWithImage:@"compose_trendbutton_background"
                                              highlight:@"compose_trendbutton_background_highlighted"];
    _toolbarEmoticonButton = [self _toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];
    _toolbarExtraButton = [self _toolbarButtonWithImage:@"message_add_background"
                                              highlight:@"message_add_background_highlighted"];
    
    CGFloat one = _toolbar.width / 5;
    _toolbarPictureButton.centerX = one * 0.5;
    _toolbarAtButton.centerX = one * 1.5;
    _toolbarTopicButton.centerX = one * 2.5;
    _toolbarEmoticonButton.centerX = one * 3.5;
    _toolbarExtraButton.centerX = one * 4.5;
    _toolbar.bottom = kScreenHeight - kStatusHeight - 44;
    [self.nrView addSubview:_toolbar];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[WBStatusHelper imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[WBStatusHelper imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
}

- (void)_cancel {
    [self.view endEditing:YES];
    if (_dismiss) _dismiss();
}

- (void)_buttonClicked:(UIButton *)button {
    if (button == _toolbarPictureButton) {
        
    } else if (button == _toolbarAtButton) {
        NSArray *atArray = @[@"@姚晨 ", @"@陈坤 ", @"@赵薇 ", @"@Angelababy " , @"@TimCook ", @"@我的印象笔记 "];
        NSString *atString = [atArray ds_randomObject];
        [_textView replaceRange:_textView.selectedTextRange withText:atString];
        
    } else if (button == _toolbarTopicButton) {
        NSArray *topic = @[@"#冰雪奇缘[电影]# ", @"#Let It Go[音乐]# ", @"#纸牌屋[图书]# ", @"#北京·理想国际大厦[地点]# " , @"#腾讯控股 kh00700[股票]# ", @"#WWDC# "];
        NSString *topicString = [topic ds_randomObject];
        [_textView replaceRange:_textView.selectedTextRange withText:topicString];
        
    } else if (button == _toolbarEmoticonButton) {
        if (_textView.inputView) {
            _textView.inputView = nil;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
        } else {
            
            WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
            v.delegate = self;
            _textView.inputView = v;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        }
        
        
    } else if (button == _toolbarExtraButton) {
        
    }
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.nrView];
    if (transition.animationDuration == 0) {
        _toolbar.bottom = CGRectGetMinY(toFrame) - 44;
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self->_toolbar.bottom = CGRectGetMinY(toFrame) - 44;
        } completion:NULL];
    }
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}


#pragma mark - event
- (void)clicknavbarCancleButton {
    [self _cancel];
}

- (void)clicknavbarPublishButton {
    
}

#pragma mark - getter setter
- (UIButton *)navbarCancleButton {
    if (!_navbarCancleButton) {
        _navbarCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbarCancleButton.size = CGSizeMake(60, 44);
        _navbarCancleButton.clipsToBounds = YES;
        _navbarCancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_navbarCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navbarCancleButton setTitleColor:kHexColor(0x939393) forState:UIControlStateNormal];
        [_navbarCancleButton addTarget:self action:@selector(clicknavbarCancleButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbarCancleButton;
}

- (UIButton *)navbarPublishButton {
    if (!_navbarPublishButton) {
        _navbarPublishButton = [[UIButton alloc] init];
        _navbarPublishButton.size = CGSizeMake(70, 30);
        _navbarPublishButton.clipsToBounds = YES;
        _navbarPublishButton.layer.cornerRadius = _toolbarPOIButton.height / 2;
        _navbarPublishButton.layer.borderColor = kHexColor(0xe4e4e4).CGColor;
        _navbarPublishButton.layer.borderWidth = LINE_HEIGHT;
        _navbarPublishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_navbarPublishButton setTitle:@"发布" forState:UIControlStateNormal];
        [_navbarPublishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navbarPublishButton setBackgroundImage:[UIImage ds_imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_navbarPublishButton setBackgroundImage:[UIImage ds_imageWithColor:UIColor.orangeColor] forState:UIControlStateHighlighted];
        [_navbarPublishButton addTarget:self action:@selector(clicknavbarPublishButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbarPublishButton;
}
@end
