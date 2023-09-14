//
//  RERectCornerView.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/20.
//

#import "RERectCornerView.h"

@interface RERectCornerView()
@property(nonatomic, strong) UIView *background;
@end

@implementation RERectCornerView

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
    [self.background ds_addGradientLayer:self.background.bounds withStartColor:self.startColor?self.startColor:[UIColor clearColor] withendColor:self.endColor?self.endColor:[UIColor clearColor] startPoint:self.startPoint endPoint:self.endPoint];
    [self.background ds_addRectCornerWith:self.reCorner radius:self.reRadius];
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
