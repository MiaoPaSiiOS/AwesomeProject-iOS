//
//  DSCornerView.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/20.
//

#import "DSCornerView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@interface DSCornerView()
@property(nonatomic, strong) UIView *background;
@end

@implementation DSCornerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.background];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [DSHelper addGradientLayerToView:self.background frame:self.background.bounds startColor:self.startColor?self.startColor:[UIColor clearColor] endColor:self.endColor?self.endColor:[UIColor clearColor] startPoint:self.startPoint endPoint:self.endPoint];
    [DSHelper addCornerToView:self.background corner:self.reCorner radius:self.reRadius];
}

- (void)setReBackgroundColor:(UIColor *)reBackgroundColor {
    _reBackgroundColor = reBackgroundColor;
    self.background.backgroundColor = reBackgroundColor;
}

- (void)setReCorner:(UIRectCorner)reCorner {
    _reCorner = reCorner;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

- (void)setReRadius:(CGFloat)reRadius {
    _reRadius = reRadius;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark - 懒加载
- (UIView *)background {
    if (!_background) {
        _background = [[UIView alloc] init];
        _background.backgroundColor = [UIColor whiteColor];
    }
    return _background;
}
@end
