//
//  YYPhotoProgress.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/20.
//

#import "YYPhotoProgress.h"
#import <DarkStarUIComponents/DarkStarUIComponents.h>

@interface YYPhotoProgress()
@property(nonatomic, strong) NrCircleView *circle;
@property(nonatomic, strong) UILabel *percentL;
@end


@implementation YYPhotoProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circle = [NrCircleView circleViewWithFrame:self.bounds lineWidth:5 lineColor:UIColor.blackColor clockWise:YES startAngle:0];
        [self addSubview:self.circle];
        [self addSubview:self.percentL];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.circle.frame = self.bounds;
    self.percentL.frame = self.bounds;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self.circle strokeEnd:progress easing:QMUIAnimationEasingsLinear animated:NO duration:0];
    self.percentL.text = [NSString stringWithFormat:@"%.f%%",progress * 100];
}


- (UILabel *)percentL {
    if (!_percentL) {
        _percentL = [[UILabel alloc] initWithFrame:self.bounds];
        _percentL.text = @"";
        _percentL.textColor = [UIColor whiteColor];
        _percentL.font = [UIFont systemFontOfSize:10];
        _percentL.textAlignment = NSTextAlignmentCenter;
    }
    return _percentL;
}
@end
