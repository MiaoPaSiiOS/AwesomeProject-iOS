//
//  PACalendarCell.m
//  pickDataDemo
//
//  Created by 朱玉辉(EX-ZHUYUHUI001) on 2020/9/15.
//  Copyright © 2020 王小腊. All rights reserved.
//

#import "PACalendarCell.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@implementation PACalendarCell
#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UILabel *label;
    CAShapeLayer *shapeLayer;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.subtitleLabel = label;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.shapeLayer = shapeLayer;
        
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 30);
    self.subtitleLabel.frame = CGRectMake(0, self.contentView.frame.size.height - 10, self.contentView.frame.size.width, 10);

    self.shapeLayer.frame = CGRectMake((self.contentView.frame.size.width - self.titleLabel.frame.size.height) / 2, 0, self.titleLabel.frame.size.height, self.titleLabel.frame.size.height);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(self.shapeLayer.bounds)*0.5].CGPath;
    if (!CGPathEqualToPath(self.shapeLayer.path,path)) {
        self.shapeLayer.path = path;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.window) { // Avoid interrupt of navigation transition somehow
        [CATransaction setDisableActions:YES]; // Avoid blink of shape layer.
    }
    self.shapeLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];
}

#pragma mark - Public

//- (void)performSelecting
//{
//    _shapeLayer.opacity = 1;
//        
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomOut.fromValue = @0.3;
//    zoomOut.toValue = @1.2;
//    zoomOut.duration = 0.15/4*3;
//    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomIn.fromValue = @1.2;
//    zoomIn.toValue = @1.0;
//    zoomIn.beginTime = 0.15/4*3;
//    zoomIn.duration = 0.15/4;
//    group.duration = 0.15;
//    group.animations = @[zoomOut, zoomIn];
//    [_shapeLayer addAnimation:group forKey:@"bounce"];
//    [self configureAppearance];
//}

#pragma mark - Private

- (void)configureAppearance
{
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:10];
    _subtitleLabel.textColor = kHexColor(0x5E5E5E);
    /// title
    _titleLabel.text = self.model.title;
    if (self.model.selected) {
        _titleLabel.textColor = [UIColor whiteColor];
    } else {
        if (self.model.hasEvent) {
            _titleLabel.textColor = kHexColor(0x222222);
        } else {
            _titleLabel.textColor = kHexColor(0x979797);
        }
    }
    
    /// subtitle
    if (self.model.selected && self.model.dateIsToday) {
        _subtitleLabel.text = @"今天";
    } else {
        _subtitleLabel.text = @"";
    }
    
    // 设置选中
    UIColor *borderColor = kHexColor(0x00C771);
    UIColor *fillColor = kHexColor(0x00C771);
    BOOL shouldHideShapeLayer = YES;
    if (self.model.selected) {
        shouldHideShapeLayer = NO;
        _shapeLayer.opacity = 1;
    } else {
        _shapeLayer.opacity = 0;
    }
    
    if (!shouldHideShapeLayer) {
        
        CGColorRef cellFillColor = fillColor.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.fillColor, cellFillColor)) {
            _shapeLayer.fillColor = cellFillColor;
        }
        
        CGColorRef cellBorderColor = borderColor.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.strokeColor, cellBorderColor)) {
            _shapeLayer.strokeColor = cellBorderColor;
        }
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                    cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5].CGPath;
        if (!CGPathEqualToPath(_shapeLayer.path, path)) {
            _shapeLayer.path = path;
        }
    }
    
}
@end


@implementation PACalendarBlankCell

- (void)configureAppearance {}

@end
