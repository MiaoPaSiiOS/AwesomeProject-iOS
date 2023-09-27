//
//  SRSFloatElementView.m
//  SiriusCoreKit
//
//  Created by HustXuYingjie on 2019/9/9.
//

#import "SRSFloatElementView.h"

static CGFloat SRSFloatWindowMaxHeight = 445.f;

@interface SRSFloatElementView()

@property (nonatomic, assign, readwrite) SRSFloatElementViewType type;
@property (nonatomic, strong, readwrite) SRSAutoLayoutScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIButton *dismissButton;

@end

@implementation SRSFloatElementView
@synthesize isCloseButtonNeeded = _isCloseButtonNeeded;
@synthesize floatEdges = _floatEdges;
@synthesize shadowEdges= _shadowEdges;

#pragma mark - init & dealloc
- (instancetype)init {
    self = [super init];
    if (self) {
        _type = SRSFloatElementViewTypeDefault;
        self.backgroundColor = [DSCommonMethods RGBA:0 green:0 blue:0 alpha:0.4];
        [self baseInit];
        [self defaultTypeInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _type = SRSFloatElementViewTypeDefault;
        self.backgroundColor = [DSCommonMethods RGBA:0 green:0 blue:0 alpha:0.4];
        [self baseInit];
        [self defaultTypeInit];
    }
    
    return self;
}

- (instancetype)initWithType:(SRSFloatElementViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        self.backgroundColor = [DSCommonMethods RGBA:0 green:0 blue:0 alpha:0.4];
        [self baseInit];
        if (type == SRSFloatElementViewTypeDefault) {
            [self defaultTypeInit];
        } else if (type == SRSFloatElementViewTypeCustom) {
            [self customTypeInit];
        }
    }
    
    return self;
}

- (void)dealloc {
    _dismissBlock = nil;
    _scrollView = nil;
}

- (void)baseInit {
    _shadowEdges = UIEdgeInsetsZero;
    _floatEdges = UIEdgeInsetsMake(267, 0, 0, 0);
    _isOutDismiss = YES;
    _isCloseButtonNeeded = YES;
    _floatWindowMaxHeight = SRSFloatWindowMaxHeight;

    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.dismissButton.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.dismissButton];
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).mas_offset((15));
        make.trailing.equalTo(self.scrollView.mas_trailing).mas_offset(-(15));
        make.width.mas_offset((20));
        make.height.mas_offset((20));
    }];
    
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTapped:)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:dismissTap];
}

- (void)defaultTypeInit {
    //NrPOD_IMAGE(@"circle_close", Nr_BUNDLE(@"NrFloatAssets", @"NrUIComponents"))
    //NrPOD_IMAGE(@"cross_close", Nr_BUNDLE(@"NrFloatAssets", @"NrUIComponents"))
    UIImage *buttonImage = [NSBundle ds_imageNamed:@"circle_close" inBundle:[NSBundle ds_bundleName:@"NrFloatAssets" inPod:@"NrUIComponents"]];
    
    [self.dismissButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    self.scrollView.layer.cornerRadius = 12.f;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.height.mas_greaterThanOrEqualTo((self.floatWindowMaxHeight)).priority(200);
        make.height.mas_lessThanOrEqualTo((self.floatWindowMaxHeight)).priority(500);
        make.height.lessThanOrEqualTo(self.scrollView.contentView.mas_height).priority(500);
        make.leading.mas_offset((self.floatEdges.left));
        make.trailing.mas_offset(-(self.floatEdges.right));
    }];
}

- (void)customTypeInit {
    UIImage *buttonImage = [NSBundle ds_imageNamed:@"cross_close" inBundle:[NSBundle ds_bundleName:@"NrFloatAssets" inPod:@"NrUIComponents"]];
    
    [self.dismissButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((self.floatEdges.top));
        make.leading.mas_equalTo((self.floatEdges.left));
        make.trailing.mas_equalTo(-(self.floatEdges.right));
        make.bottom.mas_equalTo(-(self.floatEdges.bottom));
    }];
}

#pragma mark - private
- (void)updateDismissButton {
    if (self.isCloseButtonNeeded) {
        self.dismissButton.hidden = NO;
    } else {
        self.dismissButton.hidden = YES;
    }
}

#pragma mark - public
- (void)appendSubView:(UIView *)subView {
    if (subView) {
        [self.scrollView.contentView addSubview:subView];
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((self.shadowEdges.top));
        make.leading.mas_equalTo((self.shadowEdges.left));
        make.trailing.mas_equalTo(-(self.shadowEdges.right));
        make.bottom.mas_equalTo(-(self.shadowEdges.bottom));
    }];
}

- (void)showIn:(UIView *)superView {
    if (superView) {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((self.shadowEdges.top));
            make.leading.mas_equalTo((self.shadowEdges.left));
            make.trailing.mas_equalTo(-(self.shadowEdges.right));
            make.bottom.mas_equalTo(-(self.shadowEdges.bottom));
        }];
    }
}

#pragma mark - action
- (void)dismissTapped:(UITapGestureRecognizer *)gesture {
    if (self.isOutDismiss) {
        CGPoint point = [gesture locationInView:self];
        if (!CGRectContainsPoint(self.scrollView.frame, point)) {
            [self removeFromSuperview];
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        }
    }
}

- (void)dismissButtonPressed:(UIButton *)btn {
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.type == SRSFloatElementViewTypeDefault) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset((self.floatEdges.left));
            make.trailing.mas_offset(-(self.floatEdges.right));
        }];
    } else if (self.type == SRSFloatElementViewTypeCustom) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((self.floatEdges.top));
            make.leading.mas_equalTo((self.floatEdges.left));
            make.trailing.mas_equalTo(-(self.floatEdges.right));
            make.bottom.mas_equalTo(-(self.floatEdges.bottom));
        }];
    }
}

#pragma mark - getter & setter
- (UIEdgeInsets)shadowEdges {
    return (self.type == SRSFloatElementViewTypeDefault) ? UIEdgeInsetsZero : _shadowEdges;
}

- (UIEdgeInsets)floatEdges {
    return (self.type == SRSFloatElementViewTypeDefault) ? UIEdgeInsetsMake(0, 37.5, 0, 37.5) : _floatEdges;
}

- (void)setShadowEdges:(UIEdgeInsets)shadowEdges {
    _shadowEdges = shadowEdges;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setFloatEdges:(UIEdgeInsets)floatEdges {
    _floatEdges = floatEdges;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (BOOL)isOutDismiss {
    return _isOutDismiss;
}

- (BOOL)isCloseButtonNeeded {
    return _isCloseButtonNeeded;
}

- (void)setIsCloseButtonNeeded:(BOOL)isCloseButtonNeeded {
    _isCloseButtonNeeded = isCloseButtonNeeded;
    [self updateDismissButton];
}

- (SRSAutoLayoutScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [SRSAutoLayoutScrollView new];
        _scrollView.isHorizontal = NO;
    }
    
    return _scrollView;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.backgroundColor = [UIColor clearColor];
        [_dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _dismissButton;
}

@end
