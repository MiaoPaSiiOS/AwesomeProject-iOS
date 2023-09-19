//
//  DSCircleView.m
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import "DSCircleView.h"


#define SpringDefaultMass 1.0
#define SpringDefaultDamping 18.0
#define SpringDefaultStiffness 82.0
#define SpringDefaultInitialVelocity 0.0

@interface DSCircleView ()
@property (nonatomic, strong) CAShapeLayer *baseCircleLayer; // 圆形layer
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation DSCircleView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createBaseCircleLayer];
        [self createCircleLayer];
    }
    
    return self;
}
- (void)createBaseCircleLayer {
    self.baseCircleLayer       = [CAShapeLayer layer];
    self.baseCircleLayer.frame = self.bounds;
    [self.layer addSublayer:self.baseCircleLayer];
}
- (void)createCircleLayer {
    self.circleLayer       = [CAShapeLayer layer];
    self.circleLayer.frame = self.bounds;
    [self.layer addSublayer:self.circleLayer];
}

- (CGFloat)radianFromDegree:(CGFloat)degree {

    return ((M_PI * (degree))/ 180.f);
}

- (void)makeConfigEffective {
    
    CGFloat  lineWidth = (self.lineWidth <= 0 ? 1 : self.lineWidth);
    UIColor *lineColor = (self.lineColor == nil ? [UIColor blackColor] : self.lineColor);
    CGSize   size      = self.bounds.size;
    CGFloat  radius    = size.width / 2.f - lineWidth / 2.f;
    
    // Set clockWise or not.
    BOOL    clockWise  = self.clockWise;
    CGFloat startAngle = 0;
    CGFloat endAngle   = 0;
    
    if (clockWise == YES) {
        
        startAngle = -[self radianFromDegree:180 - self.startAngle];
        endAngle   = [self radianFromDegree:180 + self.startAngle];
        
    } else {
        
        startAngle = [self radianFromDegree:180 - self.startAngle];
        endAngle   = -[self radianFromDegree:180 + self.startAngle];
    }
    
    // Create path.
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.height / 2.f, size.width / 2.f) radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockWise];
    self.circleLayer.path = circlePath.CGPath;
    
    // Set shapeLayer fill color & stroke color.
    self.circleLayer.strokeColor = lineColor.CGColor;
    self.circleLayer.fillColor   = [[UIColor clearColor] CGColor];
    self.circleLayer.lineWidth   = lineWidth;
    self.circleLayer.strokeEnd   = 0.f;
    self.circleLayer.lineCap     = kCALineCapRound;

    
    self.baseCircleLayer.path = circlePath.CGPath;
    // Set shapeLayer fill color & stroke color.
    self.baseCircleLayer.strokeColor = (self.baseLineColor == nil ? [UIColor groupTableViewBackgroundColor] : self.baseLineColor).CGColor;
    self.baseCircleLayer.fillColor   = [[UIColor clearColor] CGColor];
    self.baseCircleLayer.lineWidth   = lineWidth;
    self.baseCircleLayer.strokeEnd   = 1;
    self.baseCircleLayer.lineCap     = kCALineCapRound;
}

- (void)strokeEnd:(CGFloat)value easing:(QMUIAnimationEasings)easing animated:(BOOL)animated duration:(CGFloat)duration {
    
    if (value <= 0) {
        
        value = 0;
        
    } else if (value >= 1) {
        
        value = 1.f;
    }
    
    if (animated) {
        
        // CAKeyframeAnimation
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
        keyAnimation.keyPath    = @"strokeEnd";
        keyAnimation.duration   = duration;
        keyAnimation.values = [[self class] calculateFrameFromValue:self.circleLayer.strokeEnd toValue:value easing:easing frameCount:duration * 60];
        // Start animation.
        self.circleLayer.strokeEnd = value;
        [self.circleLayer addAnimation:keyAnimation forKey:nil];
        
    } else {
        
        // DisableActions.
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeEnd = value;
        [CATransaction setDisableActions:NO];
    }
}


- (void)strokeStart:(CGFloat)value easing:(QMUIAnimationEasings)easing animated:(BOOL)animated duration:(CGFloat)duration {
    
    if (value <= 0) {
        
        value = 0;
        
    } else if (value >= 1) {
        
        value = 1.f;
    }
    
    if (animated) {
        
        // CAKeyframeAnimation
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
        keyAnimation.keyPath    = @"strokeStart";
        keyAnimation.duration   = duration;
        keyAnimation.values = [[self class] calculateFrameFromValue:self.circleLayer.strokeStart toValue:value easing:easing frameCount:duration * 60];
        
        // Start animation.
        self.circleLayer.strokeStart = value;
        [self.circleLayer addAnimation:keyAnimation forKey:nil];
        
    } else {
        
        // DisableActions.
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeStart = value;
        [CATransaction setDisableActions:NO];
    }
}

+ (instancetype)circleViewWithFrame:(CGRect)frame
                          lineWidth:(CGFloat)width
                          lineColor:(UIColor *)color
                          clockWise:(BOOL)clockWise
                         startAngle:(CGFloat)angle
{
    
    DSCircleView *circleView = [[DSCircleView alloc] initWithFrame:frame];
    circleView.lineWidth   = width;
    circleView.lineColor   = color;
    circleView.clockWise   = clockWise;
    circleView.startAngle  = angle;
    [circleView makeConfigEffective];
    
    return circleView;
}




#pragma mark -
+ (NSArray *)calculateFrameFromValue:(CGFloat)fromValue
                             toValue:(CGFloat)toValue
                              easing:(QMUIAnimationEasings)easing
                          frameCount:(size_t)frameCount {
    
    // 设置帧数量
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount];
    
    // 计算并存储
    CGFloat t  = 0.0;
    CGFloat dt = 1.0 / (frameCount - 1);
    for(size_t frame = 0; frame < frameCount; ++frame, t += dt) {
        // 此处就会根据不同的函数计算出不同的值达到不同的效果
        NSNumber *value = [QMUIAnimationHelper interpolateFromValue:@(fromValue) toValue:@(toValue) time:t easing:easing];
        // 将计算结果存储进数组中
        [values addObject:value];
    }
    
    // 数组中存储的数据为 NSNumber float 型
    return values;
}


@end
