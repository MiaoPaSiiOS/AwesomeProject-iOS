

#import "SRSMessageSingle.h"

@interface SRSMessageSingle()

/// 光标
@property (nonatomic, strong) UIImageView * cursor;
/// 内容
@property (nonatomic, strong) UIView * contentView;
/// 文字内容
@property (nonatomic, strong, readwrite) UILabel *textLabel;

/// 底部线
@property (nonatomic, strong) UILabel * bottomLabel;

@end

@implementation SRSMessageSingle

- (instancetype)init {
    if (self = [super init]) {
        
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        
        kWeakSelf
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.edges.equalTo(strongSelf);
        }];
        
        self.cursor = [[UIImageView alloc] init];
        self.cursor.alpha = 0;
        self.cursor.userInteractionEnabled = YES;
        self.cursor.backgroundColor = kHexColor(0x4586FF);
        self.cursor.layer.cornerRadius = (4);
        self.cursor.layer.masksToBounds = YES;
        [self.contentView addSubview:_cursor];
        
        [self.cursor mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.size.mas_equalTo(CGSizeMake((2), (52/2.)));
            make.centerX.equalTo(strongSelf);
            make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-(15/2.));
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.userInteractionEnabled = YES;
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:(24)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.edges.equalTo(strongSelf).mas_offset(UIEdgeInsetsMake((15/2.), 0, (4), 0));
        }];
        
        self.bottomLabel = [[UILabel alloc] init];
        self.bottomLabel.userInteractionEnabled = YES;
        self.bottomLabel.backgroundColor = kHexColor(0x444444);
        [self.contentView addSubview:self.bottomLabel];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            kStrongSelf
            make.left.and.right.and.bottom.equalTo(strongSelf);
            make.height.mas_equalTo(1./[UIScreen mainScreen].scale);
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.contentView addGestureRecognizer:tap];
        
        self.status = eSRSBottomLabelStatusDefault;
        
    }
    return self;
}

- (void)tapClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtn:)]) {
        [self.delegate clickBtn:self];
    }
}

- (void)startAnimatuon
{
    CGFloat duration = 1;
    CAAnimationGroup * group = [[CAAnimationGroup alloc] init];
    CAKeyframeAnimation *an3 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    an3.values = @[@1,@1,@0,@0];
    NSArray * arr = @[an3];
    group.animations = arr;
    group.duration = duration;
    group.repeatCount = MAXFLOAT;
    [_cursor.layer addAnimation:group forKey:@"PostionAni"];
    
}
- (void)stopAnimaton
{
    [_cursor.layer removeAllAnimations];
}

- (void)setStatus:(eSRSBottomLabelStatus)status {
    if (status == _status) return;
    if (status > 2 || status < 0) status = 0;
    _status = status;
    switch (status) {
            case eSRSBottomLabelStatusError:
            self.bottomLabel.backgroundColor = kHexColor(0xFF4D29);
            break;
            case eSRSBottomLabelStatusInput:
            self.bottomLabel.backgroundColor = kHexColor(0x4586FF);
            break;
            case eSRSBottomLabelStatusDefault:
            self.bottomLabel.backgroundColor = kHexColor(0x444444);
            break;
    }
}

@end
