//
//  SRSAlertController.m
//  SiriusCoreKit
//
//  Created by zhaoyang on 2019/3/27.
//

#import "SRSAlertController.h"

CGFloat kButtonHeight = 44.f;
NSInteger kButtonTag = 74637;
NSInteger SRSAlertContrllerTag = 837458;
#define kAlertControllerWidth (DSDeviceInfo.screenWidth-100)

@interface SRSAlertButtonsView : UIView

@property (nonatomic, copy) void(^ButtonClickAction)(NSInteger index);

@property (nonatomic, copy) NSArray *buttonsArray;

- (instancetype)initWithButtonsArray:(NSArray *)buttonsArray;

@end

@implementation SRSAlertButtonsView

- (instancetype)initWithButtonsArray:(NSArray *)buttonsArray {
    if (self = [super initWithFrame:CGRectZero]) {
        _buttonsArray = buttonsArray;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [DSCommonMethods colorWithHexString:@"0xE8E8E8"];
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(DSDeviceInfo.LINE_HEIGHT);
    }];
    
    for (NSInteger i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kButtonTag+i;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        [button setTitle:self.buttonsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[DSCommonMethods colorWithHexString:@"0x3E73FF"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (self.buttonsArray.count == 2) {
            CGFloat width = kAlertControllerWidth/2.f;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(kButtonHeight);
                make.top.equalTo(self);
                make.leading.equalTo(self).mas_equalTo(i*width);
            }];
            UIView *middleLine = [[UIView alloc] init];
            middleLine.backgroundColor = [DSCommonMethods colorWithHexString:@"0xE8E8E8"];
            [self addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.leading.equalTo(self).mas_equalTo(width);
                make.width.mas_equalTo(DSDeviceInfo.LINE_HEIGHT);
            }];
            if (1 == i) {
                [self emphasizeButton:button];
            }
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.height.mas_equalTo(kButtonHeight);
                make.width.mas_equalTo(DSDeviceInfo.screenWidth-100);
                make.top.equalTo(self).mas_equalTo(kButtonHeight*i);
            }];
            if (0 == i) {
                [self emphasizeButton:button];
            }
            
            if (self.buttonsArray.count > 2 && i != self.buttonsArray.count-1) {
                UIView *bottomLineView = [[UIView alloc] init];
                bottomLineView.backgroundColor = [DSCommonMethods colorWithHexString:@"0xE8E8E8"];
                [self addSubview:bottomLineView];
                [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.equalTo(self);
                    make.height.mas_equalTo(DSDeviceInfo.LINE_HEIGHT);
                    make.top.mas_equalTo(kButtonHeight*(i+1));
                }];
            }
        }
        
        
    }
}

- (void)emphasizeButton:(UIButton *)button {
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
}

- (void)buttonAction:(UIButton *)button {
    if (self.ButtonClickAction) {
        self.ButtonClickAction(button.tag-kButtonTag);
    }
}


@end

@interface SRSAlertController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, strong) NSArray *actionNameArray;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) BOOL moreAction;
@property (nonatomic, assign) BOOL autoDismiss;
@property (nonatomic, copy) ClickActionBlock clickAction;
@end

@implementation SRSAlertController

static SRSAlertController *lastAlert;

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, DSDeviceInfo.screenWidth, DSDeviceInfo.screenHeight);
        self.backgroundColor = [DSCommonMethods colorWithHexString:@"0x000000" alpha:0.4];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message acionNames:(NSArray *)actionNameArray autoDismiss:(BOOL)autoDismiss clickAcion:(ClickActionBlock)clickAction {
    if (self = [self init]) {
        self.alpha = 0;
        _titleStr = title;
        _messageStr = message;
        _actionNameArray = actionNameArray;
        _moreAction = actionNameArray.count > 2;
        _autoDismiss = autoDismiss;
        _clickAction = clickAction;
        [self initSubviews];
    }
    return self;
}


- (instancetype)initWithIconName:(NSString *)iconName attrMessage:(NSAttributedString *)attrMessage message:(NSString *)message acionNames:(NSArray *)actionNameArray autoDismiss:(BOOL)autoDismiss clickAcion:(ClickActionBlock)clickAction {
    if (self = [self init]) {
        self.alpha = 0;
        _iconName = iconName;
        _actionNameArray = actionNameArray;
        _moreAction = actionNameArray.count > 2;
        _autoDismiss = autoDismiss;
        _clickAction = clickAction;
        [self initSubviewsWithAttrString:attrMessage message:message];
    }
    return self;
}


- (void)initSubviews {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.center = self.center;
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.alpha = 0;
    self.contentView.layer.transform = CATransform3DMakeScale(0, 0, 1);
    [self addSubview:self.contentView];
    [self addAnimation];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.equalTo(self).mas_equalTo(50.f);
        make.trailing.equalTo(self).mas_equalTo(-50.f);
    }];
   
    if (self.titleStr.length) {
        self.titleLbl = [[UILabel alloc] init];
        self.titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        self.titleLbl.textColor = [DSCommonMethods colorWithHexString:@"0x333333"];
        self.titleLbl.numberOfLines = 0;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.text = self.titleStr;
        [self.contentView addSubview:self.titleLbl];
        CGFloat top = self.moreAction ? 25.f : 20.f;
        [self.titleLbl sizeToFit];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).mas_equalTo(30);
            make.trailing.equalTo(self.contentView).mas_equalTo(-30);
            make.top.equalTo(self.contentView).mas_equalTo(top);
        }];
    }
    
    self.messageLbl = [[UILabel alloc] init];
    self.messageLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.f];
    self.messageLbl.textColor = [DSCommonMethods colorWithHexString:@"0x333333"];
    self.messageLbl.text = self.messageStr;
    [self.messageLbl sizeToFit];
    self.messageLbl.numberOfLines = 0;
    [self.contentView addSubview:self.messageLbl];
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).mas_equalTo(30);
        make.trailing.equalTo(self.contentView).mas_equalTo(-30);
    }];
    if (self.titleStr.length) {
        [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).mas_equalTo(15);
        }];
    } else {
        [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_equalTo(25);
        }];
    }
    [self layoutIfNeeded];
    BOOL textAlignment = self.messageLbl.frame.size.height/self.messageLbl.font.lineHeight > 4 ? YES : NO;
    self.messageLbl.textAlignment = textAlignment ? NSTextAlignmentLeft : NSTextAlignmentCenter;

    SRSAlertButtonsView *buttonsView = [[SRSAlertButtonsView alloc] initWithButtonsArray:self.actionNameArray];
    [self.contentView addSubview:buttonsView];
    CGFloat buttonsViewHeight = self.moreAction ? self.actionNameArray.count*kButtonHeight : kButtonHeight;
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.messageLbl.mas_bottom).mas_equalTo(24);
        make.height.mas_equalTo(buttonsViewHeight);
    }];
    kWeakSelf
    buttonsView.ButtonClickAction = ^(NSInteger index) {
        kStrongSelf
        if (strongSelf.clickAction) {
            strongSelf.clickAction(index);
        }
        if (strongSelf.autoDismiss) {
            [strongSelf dismissAlertController];
        }
    };
}

- (void)initSubviewsWithAttrString:(NSAttributedString *)attrMessage message:(NSString *)message {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.center = self.center;
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.alpha = 0;
    self.contentView.layer.transform = CATransform3DMakeScale(0, 0, 1);
    [self addSubview:self.contentView];
    [self addAnimation];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.equalTo(self).mas_equalTo(50.f);
        make.trailing.equalTo(self).mas_equalTo(-50.f);
    }];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:self.iconName];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(150/2.f);
        make.top.equalTo(self.contentView).mas_equalTo(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    
    self.messageLbl = [[UILabel alloc] init];
    self.messageLbl.textColor = [DSCommonMethods colorWithHexString:@"0x222222"];
    if (attrMessage.length) {
        self.messageLbl.attributedText = attrMessage;
    } else if (message.length) {
        self.messageLbl.text = message;
    }
    [self.messageLbl sizeToFit];
    self.messageLbl.numberOfLines = 0;
    self.messageLbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.messageLbl];
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).mas_equalTo(30);
        make.trailing.equalTo(self.contentView).mas_equalTo(-30);
        make.top.equalTo(iconImgView.mas_bottom).mas_equalTo(10);
    }];

    SRSAlertButtonsView *buttonsView = [[SRSAlertButtonsView alloc] initWithButtonsArray:self.actionNameArray];
    [self.contentView addSubview:buttonsView];
    CGFloat buttonsViewHeight = self.moreAction ? self.actionNameArray.count*kButtonHeight : kButtonHeight;
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.messageLbl.mas_bottom).mas_equalTo(24);
        make.height.mas_equalTo(buttonsViewHeight);
    }];
    kWeakSelf
    buttonsView.ButtonClickAction = ^(NSInteger index) {
        kStrongSelf
        if (strongSelf.clickAction) {
            strongSelf.clickAction(index);
        }
        if (strongSelf.autoDismiss) {
            [strongSelf dismissAlertController];
        }
    };
}



- (void)addAnimation {
    [UIView animateWithDuration:.25f animations:^{
        self.alpha = 1;
        self.contentView.alpha = 1;
        self.contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)dismissAlertController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = 0;
            self.contentView.alpha = 0;
            self.contentView.layer.transform = CATransform3DMakeScale(.1f, .1f, 1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

+ (void)dismissLastAlertController {
    if (lastAlert && [lastAlert isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        [lastAlert dismissAlertController];
    }
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithTitle:title message:message acionNames:actionNames autoDismiss:YES clickAcion:clickAction];
    [self addAlertController:alertController];
}

+ (instancetype)alertCustomDismissWithTitle:(NSString *)title message:(NSString *)message actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithTitle:title message:message acionNames:actionNames autoDismiss:NO clickAcion:clickAction];
    return [self addCustomDismissAlertController:alertController];
}



+ (void)alertWithIconName:(NSString *)iconName attrMessage:(NSAttributedString *)attrMessage actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithIconName:iconName attrMessage:attrMessage message:nil acionNames:actionNames autoDismiss:YES clickAcion:clickAction];
    [self addAlertController:alertController];
    
}

+ (instancetype)alertCustomDismissWithIconName:(NSString *)iconName attrMessage:(NSAttributedString *)attrMessage actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithIconName:iconName attrMessage:attrMessage message:nil acionNames:actionNames autoDismiss:NO clickAcion:clickAction];
    return [self addCustomDismissAlertController:alertController];
}


+ (void)alertWithIconName:(NSString *)iconName message:(NSString *)message actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithIconName:iconName attrMessage:nil message:message acionNames:actionNames autoDismiss:YES clickAcion:clickAction];
    [self addAlertController:alertController];

}

+ (instancetype)alertCustomDismissWithIconName:(NSString *)iconName message:(NSString *)message actionNames:(NSArray<NSString *> *)actionNames clickAcion:(ClickActionBlock)clickAction {
    SRSAlertController *alertController = [[SRSAlertController alloc] initWithIconName:iconName attrMessage:nil message:message acionNames:actionNames autoDismiss:NO clickAcion:clickAction];
    return [self addCustomDismissAlertController:alertController];
}



+ (void)addAlertController:(SRSAlertController *)alertController {
    SRSAlertController *alertView = [[UIApplication sharedApplication].keyWindow viewWithTag:SRSAlertContrllerTag];
    if (!alertView && ![alertView isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        [[UIApplication sharedApplication].keyWindow addSubview:alertController];
        lastAlert = alertController;
    }
}

+ (SRSAlertController *)addCustomDismissAlertController:(SRSAlertController *)alertController {
    SRSAlertController *alertView = [[UIApplication sharedApplication].keyWindow viewWithTag:SRSAlertContrllerTag];
    if (!alertView && ![alertView isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        [[UIApplication sharedApplication].keyWindow addSubview:alertController];
        return alertController;
    }
    return nil;
}

@end
