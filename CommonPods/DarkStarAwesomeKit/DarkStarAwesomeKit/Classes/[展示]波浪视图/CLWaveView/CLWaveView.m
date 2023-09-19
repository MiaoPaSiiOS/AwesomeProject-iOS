//
//  CLWaveView.m
//  CLDemo
//
//  Created by AUG on 2019/3/6.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

#import "CLWaveView.h"


@interface CLWaveViewConfigure ()

@end

@implementation CLWaveViewConfigure

+ (instancetype)defaultConfigure {
    CLWaveViewConfigure *configure = [[CLWaveViewConfigure alloc] init];
    configure.color = [UIColor orangeColor];
    configure.speed = 0.05;
    configure.amplitude = 12;
    configure.cycle = 0.5/30.0;
    configure.y = configure.amplitude;
    configure.upSpeed = 0;
    return configure;
}

@end



@interface CLWaveView ()

@property (nonatomic, weak) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///配置
@property (nonatomic, strong) CLWaveViewConfigure *configure;
///位移
@property (nonatomic, assign) CGFloat offsetX;

@end


@implementation CLWaveView

- (CLWaveViewConfigure *) configure {
    if (_configure == nil){
        _configure = [CLWaveViewConfigure defaultConfigure];
        _configure.width = self.frame.size.width;
    }
    return _configure;
}
- (void)updateWithConfigure:(void(^)(CLWaveViewConfigure *configure))configureBlock {
    configureBlock(self.configure);
    configureBlock = nil;
    self.shapeLayer.fillColor = self.configure.color.CGColor;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    //初始化layer
    if (self.shapeLayer == nil) {
        //初始化
        self.shapeLayer = [CAShapeLayer layer];
        //设置闭环的颜色
        self.shapeLayer.fillColor = self.configure.color.CGColor;
        [self.layer addSublayer:self.shapeLayer];
    }
    //启动定时器
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentWave)];
    self.displayLink = displayLink;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)currentWave {
    if (self.configure.amplitude == 0 && self.configure.y == 0 && self.configure.upSpeed != 0) {
        [self invalidate];
    }else {
        //实时的位移
        self.offsetX += self.configure.speed;
        self.configure.y = MAX(self.configure.y - self.configure.upSpeed, 0);
        if (self.configure.y < self.configure.amplitude) {
            self.configure.amplitude = self.configure.y;
        }
        [self currentFirstWaveLayerPath];
    }
}
/*
 水波动画的关键点就是正余弦函数:
 正弦型函数解析式：y=Asin（ωx+φ）+h
 各常数值对函数图像的影响：
 φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 ω：决定周期（最小正周期T=2π/|ω|）
 A：决定峰值（即纵向拉伸压缩的倍数）
 h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 --------------------------------------
   把上面的原理落实到我们需要制作的动画上面。首先要总结出一个公式，确定正弦型函数解析式：y=Asin（ωx+φ）+h中各个常数的值。这里需要注意UIKit的坐标系统y轴是向下延伸。

     1、我们的容器高度是100，我希望波的整体高度，固定在容器的一个相对的位置。
     这里设置h ＝ 30；也就是说，当Asin（ωx+φ）计算为0的时候，这个时候y的位置是30；
     2、决定波起伏的高度，我们设置波峰是5，波峰越大，曲线越陡峭；
     3、决定波的宽度和周期，比如，我们可以看到上面的例子中是一个周期的波曲线，
     一个波峰、一个波谷，如果我们想在0到2π这个距离显示2个完整的波曲线，那么周期就是π。
     我们这里设置波的宽度是容器的宽度_waveWidth，希望能展示2.5个波曲线，周期就是_waveWidth／2.5。
     那么ω常量就可以这样计算：2.5*M_PI/_waveWidth。
     4、一共有两个波曲线，形成一个落差，也就是设置不同的φ（初相位），我们这里设置落差是M_PI/4。
     5、时间和初相位的函数关系：我们在计时器的函数中一直调用_offset += _speed;
     可以看到，如果我们设置波的速度speed越大，波的震动将会越快。

 最后我们的公式如下：
 CGFloat y = _waveHeight*sinf(2.5*M_PI*i/_waveWidth + 3*_offset*M_PI/_waveWidth + M_PI/4) + _h;
 这些参数都可以自己调整，得到一个符合要求的效果。
 
 */
- (void)currentFirstWaveLayerPath {
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = self.configure.y;
    //将点移动到 x=0,y=y的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger i = 0.0f; i <= self.configure.width; i++) {
        //正弦函数波浪公式
        y = self.configure.amplitude * sin(self.configure.cycle * i + self.offsetX) + self.configure.y;
        //将点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    CGPathAddLineToPoint(path, nil, self.configure.width, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    self.shapeLayer.path = path;
    //使用layer 而没用CurrentContext
    CGPathRelease(path);
}
- (void)invalidate {
    [self.displayLink invalidate];
}
- (void)dealloc {
    NSLog(@"波浪视图销毁了");
}
@end
