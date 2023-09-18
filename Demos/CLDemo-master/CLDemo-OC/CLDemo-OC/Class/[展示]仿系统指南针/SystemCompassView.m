
#import "SystemCompassView.h"

@interface SystemCompassView ()
{
    UIView * _backgroundView;
    UIView * _levelView;
    UIView * _verticalView;
}
@end


@implementation SystemCompassView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.width/2;
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_backgroundView];
        
        [self paintingScale];
//        [self one];
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
        
        //中间标志线
        UIView *centerLine = [[UIView alloc] init];
        centerLine.backgroundColor = [UIColor redColor];
        centerLine.frame = CGRectMake((self.frame.size.height - 1)/2, 0, 1, self.frame.size.height);
        [self addSubview:centerLine];
    }
    
    return self;
}


- (void)one {
    int N = 10;//等分数N
    CGFloat radius = self.frame.size.width/2 - 50;//半径
    CGFloat angle = M_PI*2 / N;//等分后每段所占弧度数
    
    
    for (int i = 0; i < N; i++) {
        //默认是从最右侧开始，减去M_PI_2后，从最上边开始。
        CGFloat startAngle = angle * i - M_PI_2;
        CGFloat endAngle = startAngle + angle;

        
        // 可以利用贝塞尔path获取圆弧终点的位置CGPoint
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

        // 等分点
        CGPoint position = path.currentPoint;
        // 在相应等分点上绘制元素
        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:position radius:10 startAngle:0 endAngle:M_PI*2 clockwise:YES];

        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor blueColor].CGColor;
        layer.path = p.CGPath;
        [self.layer addSublayer:layer];
        
        
        // 等分弧线段
        CAShapeLayer * circleLayer = [CAShapeLayer layer];
        circleLayer.lineWidth = 4;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = i % 2 == 0 ? [UIColor redColor].CGColor : [UIColor greenColor].CGColor;
        circleLayer.path = path.CGPath;
        [self.layer addSublayer:circleLayer];
    }
}



//化刻度表
- (void)paintingScale{
    //½ ⅓ ⅔ ¼ ¾ ⅛ ⅜
    int N = 180;//等分数N
    CGFloat perAngle = M_PI*2/N;//每份所占弧度数
    CGFloat perAngle_2 = perAngle/2;//实际每个弧线的弧度
    CGFloat perAngle_4 = perAngle/4;//实际每个弧线的弧度的一半

    NSArray *array = @[@"北",@"东",@"南",@"西"];
    //0 30 60 90 120 150 180 210 240 270 300 330 360
    //画圆环，每隔2°画一个弧线，总共180条
    for (int i = 0; i < N; i++) {
        //默认是从最右侧开始，减去M_PI_2后，从最上边开始。还需要再减去perAngle_4：应该从第一个弧线的中间位置开始，所以要再减去perAngle_4
        CGFloat startAngle = perAngle * i - M_PI_2 - perAngle_4;
        CGFloat endAngle = startAngle + perAngle_2;//这里是perAngle_2的原因是：如果是perAngle，那就是连贯线了，彼此间看不出间距
        
        UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:(self.frame.size.width/2 - 50) startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //每隔30°画一个白条刻度
        if (i%15 == 0) {
            shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 20;
        }else{
            shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
            shapeLayer.lineWidth = 10;
        }
        
        shapeLayer.path = bezPath.CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_backgroundView.layer addSublayer:shapeLayer];
        

        if (i % 15 == 0){
            //刻度的标注 0 30 60...
            NSString *tickText = [NSString stringWithFormat:@"%d",i * 2];
            CGFloat textAngel = startAngle+(endAngle-startAngle)/2;
            CGPoint point = [self calculateTextPositonWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) Angle:textAngel andScale:1.2];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, 30, 15)];
            label.center = point;
            label.text = tickText;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [_backgroundView addSubview:label];

            if (i%45 == 0){
                //北 东 南 西
                tickText = array[i/45];
                CGPoint point2 = [self calculateTextPositonWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) Angle:textAngel andScale:0.8];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point2.x, point2.y, 30, 20)];
                label.center = point2;
                label.text = tickText;
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:20];
                label.textAlignment = NSTextAlignmentCenter;
                if ([tickText isEqualToString:@"北"]) {
                    UILabel * markLabel = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, 8, 8)];
                    markLabel.center = CGPointMake(point.x, point.y + 12);
                    markLabel.clipsToBounds = YES;
                    markLabel.layer.cornerRadius = 4;
                    markLabel.backgroundColor = [UIColor redColor];
                    [_backgroundView addSubview:markLabel];

                }

                [_backgroundView addSubview:label];
            }
        }
    }
}

//计算中心坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
                                    andScale:(CGFloat)scale
{
    CGFloat x = (self.frame.size.width/2 - 50) * scale * cosf(angel);
    CGFloat y = (self.frame.size.width/2 - 50) * scale * sinf(angel);
    
    return CGPointMake(center.x + x, center.y + y);
}

//旋转重置刻度标志的方向
- (void)resetDirection:(CGFloat)heading {
    [UIView animateWithDuration:0.2
                     animations:^{
                       _backgroundView.transform = CGAffineTransformMakeRotation(heading);

                       for (UILabel *label in _backgroundView.subviews) {
                           label.transform = CGAffineTransformMakeRotation(-heading);
                       }
                     }];
}


@end

