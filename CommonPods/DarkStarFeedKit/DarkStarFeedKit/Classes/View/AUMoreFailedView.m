//
//  AUMoreFailedView.m
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/1/27.
//

#import "AUMoreFailedView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarUIComponents/DarkStarUIComponents.h>
#import "AmenFeedTool.h"
@interface AUMoreFailedView ()
@property (nonatomic, strong) NrUIButton * retryButton;
@end
@implementation AUMoreFailedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kHexColor(0xffffff);
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.retryButton = [[NrUIButton alloc] init];
    self.retryButton.layer.borderColor = kHexAColor(0x4586ff, 1).CGColor;
    self.retryButton.layer.borderWidth = 1;
    self.retryButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.retryButton.layer.cornerRadius = 14;
    [self.retryButton setTitle:@"加载失败，点我再试试" forState:UIControlStateNormal];
    [self.retryButton setTitleColor:kHexColor(0x4586ff) forState:UIControlStateNormal];
    [self.retryButton setTitleColor:kHexAColor(0x4586ff,0.5) forState:UIControlStateHighlighted];
    [self.retryButton setImage:[AmenFeedTool imageNamed:@"activites_reset_icon"] forState:UIControlStateNormal];
    self.retryButton.imagePosition = NrUIButtonImagePositionLeft;
    self.retryButton.spacingBetweenImageAndTitle = 4;
    [self.retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(164, 28));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
}

- (void)retryButtonClick:(UIButton *)button {
    if (self.retryBlock) {
        self.retryBlock();
    }
}
@end