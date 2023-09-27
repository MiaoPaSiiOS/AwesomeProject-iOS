

#import "SRSAttributedClickLabelAlert.h"

static CGFloat const kButtonHeight = 44.f;
static NSInteger const kButtonTag = 74637;
static NSInteger const kSRSAlertContrllerTag = 837569;
#define kAlertControllerWidth (DSCommonMethods.screenWidth-100)

@interface SRSAttributedClickLabelAlertButtonsView : UIView

@property (nonatomic, copy) void(^ButtonClickAction)(NSInteger index);

@property (nonatomic, copy) NSArray *buttonsArray;

- (instancetype)initWithButtonsArray:(NSArray *)buttonsArray;

@end

@implementation SRSAttributedClickLabelAlertButtonsView

- (instancetype)initWithButtonsArray:(NSArray *)buttonsArray {
    if (self = [super initWithFrame:CGRectZero]) {
        _buttonsArray = buttonsArray;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = kHexColor(0xE8E8E8);
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(DSCommonMethods.LINE_HEIGHT);
    }];
    
    for (NSInteger i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kButtonTag+i;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        [button setTitle:self.buttonsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:kHexColor(0x3E73FF) forState:UIControlStateNormal];
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
            middleLine.backgroundColor = kHexColor(0xE8E8E8);
            [self addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.leading.equalTo(self).mas_equalTo(width);
                make.width.mas_equalTo(DSCommonMethods.LINE_HEIGHT);
            }];
            if (1 == i) {
                [self emphasizeButton:button];
            }
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.height.mas_equalTo(kButtonHeight);
                make.width.mas_equalTo(DSCommonMethods.screenWidth-100);
                make.top.equalTo(self).mas_equalTo(kButtonHeight*i);
            }];
            if (0 == i) {
                [self emphasizeButton:button];
            }
            
            if (self.buttonsArray.count > 2 && i != self.buttonsArray.count-1) {
                UIView *bottomLineView = [[UIView alloc] init];
                bottomLineView.backgroundColor = kHexColor(0xE8E8E8);
                [self addSubview:bottomLineView];
                [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.equalTo(self);
                    make.height.mas_equalTo(DSCommonMethods.LINE_HEIGHT);
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

@interface SRSAttributedClickLabelAlert ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TTTAttributedLabel *messageLbl;
@property (nonatomic, strong) NSArray *actionNameArray;
@property (nonatomic, assign) BOOL moreAction;
@property (nonatomic, assign) BOOL autoDismiss;
@property (nonatomic, copy) BCMAttrClickAction clickAction;
@property (nonatomic, copy) BCMAttrConfigLable configLable;
@property (nonatomic, copy) BCMAttrClickLinkModel clickLinkModel;

@end

@implementation SRSAttributedClickLabelAlert
static SRSAttributedClickLabelAlert *lastAlert;

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, DSCommonMethods.screenWidth, DSCommonMethods.screenHeight);
        self.backgroundColor = kHexAColor(0x000000, 0.4);
    }
    return self;
}

- (instancetype)initWithAutoDismiss:(BOOL)autoDismiss
                         acionNames:(NSArray *)actionNameArray
                         clickAcion:(nullable BCMAttrClickAction)clickAction
                        configLable:(nullable BCMAttrConfigLable)configLable
                     clickLinkModel:(nullable BCMAttrClickLinkModel)clickLinkModel; {
    if (self = [self init]) {
        self.alpha = 0;
        _autoDismiss = autoDismiss;
        _actionNameArray = actionNameArray;
        _clickAction = clickAction;
        _moreAction = actionNameArray.count > 2;
        _configLable = configLable;
        _clickLinkModel = clickLinkModel;
        [self initSubviews];
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
    
    self.messageLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.messageLbl.numberOfLines = 0;
    self.messageLbl.textAlignment = NSTextAlignmentCenter;
    //链接下面默认有下划线的，可以去掉：
    self.messageLbl.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:false] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.messageLbl.delegate = self;
    self.messageLbl.userInteractionEnabled = YES;
    //AttributedClickLabel 具体配置交由外部处理
    if (self.configLable) {
        self.configLable(self.messageLbl);
    }
    [self.contentView addSubview:self.messageLbl];
    [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).mas_equalTo(30);
        make.trailing.equalTo(self.contentView).mas_equalTo(-30);
        make.top.equalTo(self.contentView).mas_equalTo(28);
    }];

    
    SRSAttributedClickLabelAlertButtonsView *buttonsView = [[SRSAttributedClickLabelAlertButtonsView alloc] initWithButtonsArray:self.actionNameArray];
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


#pragma mark - AttributedClickLabelDelegate蓝色字体点击代理 -
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    // 执行您的点击操作，比如打开链接
    NSLog(@"点击了链接：%@", [url absoluteString]);
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSLog(@"点击了TransitInformation：%@", components);
    if (self.clickLinkModel && components) {
        self.clickLinkModel(components);
    }
    if (self.autoDismiss) {
        [self dismissAlertController];
    }
}

+ (void)alertWithConfigLable:(nullable BCMAttrConfigLable)configLable
              clickLinkModel:(nullable BCMAttrClickLinkModel)clickLinkModel
                 ActionNames:(nullable NSArray *)actionNameArray
                  clickAcion:(BCMAttrClickAction)clickAction {
    SRSAttributedClickLabelAlert *alertController = [[SRSAttributedClickLabelAlert alloc] initWithAutoDismiss:YES acionNames:actionNameArray clickAcion:clickAction configLable:configLable clickLinkModel:clickLinkModel];
    [self addAlertController:alertController];
}

+ (instancetype)alertCustomDismissConfigLable:(nullable BCMAttrConfigLable)configLable
                               clickLinkModel:(nullable BCMAttrClickLinkModel)clickLinkModel
                                  ActionNames:(nullable NSArray *)actionNameArray
                                   clickAcion:(nullable BCMAttrClickAction)clickAction {
    SRSAttributedClickLabelAlert *alertController = [[SRSAttributedClickLabelAlert alloc] initWithAutoDismiss:NO acionNames:actionNameArray clickAcion:clickAction configLable:configLable clickLinkModel:clickLinkModel];
    return [self addCustomDismissAlertController:alertController];
}

+ (void)addAlertController:(SRSAttributedClickLabelAlert *)alertController {
    SRSAttributedClickLabelAlert *alertView = [[UIApplication sharedApplication].keyWindow viewWithTag:kSRSAlertContrllerTag];
    if (!alertView && ![alertView isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        [[UIApplication sharedApplication].keyWindow addSubview:alertController];
        lastAlert = alertController;
    }
}

+ (SRSAttributedClickLabelAlert *)addCustomDismissAlertController:(SRSAttributedClickLabelAlert *)alertController {
    SRSAttributedClickLabelAlert *alertView = [[UIApplication sharedApplication].keyWindow viewWithTag:kSRSAlertContrllerTag];
    if (!alertView && ![alertView isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        [[UIApplication sharedApplication].keyWindow addSubview:alertController];
        return alertController;
    }
    return nil;
}

@end
