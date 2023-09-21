//
//  CountDownBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/22.
//  Copyright © 2018 mh. All rights reserved.
//

#import "CountDownBar.h"
@interface CountDownBar ()

@property(nonatomic,assign)CGFloat curentLength;//当前已录制时长
@property(nonatomic,assign)CGFloat pauseTime;//暂停时间 默认15.0(最大视频长度)
@property(nonatomic,assign)BOOL needCountDown;//是否需要倒计时 默认no

@property(nonatomic,copy)CountDownCallBack callBack;

@property(nonatomic,strong)UIView * contentView;//底部内容区域容器
@property(nonatomic,strong)UIView * progressView;//中间区域
@property(nonatomic,strong)UIView * recodedView;//已录制时间区域

@property(nonatomic,strong)UIView * sliderView;//滑动杆view
@property(nonatomic,strong)UILabel * pauseTimeLab;//暂停时间lab
@property(nonatomic,assign)BOOL handleTouch;//是否响应手指滑动
@property(nonatomic,assign)CGFloat perSecontWidth;//每秒 页面占用长度

@end

@implementation CountDownBar

-(instancetype)initWithFrame:(CGRect)frame curentLength:(CGFloat)curentLength callBack:(CountDownCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curentLength = curentLength;
        self.callBack = callBack;
        self.pauseTime = 15.0;
        self.needCountDown = NO;
        
        UIControl * hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
        hidenControl.backgroundColor = [UIColor clearColor];
        [hidenControl addTarget:self action:@selector(hiden_hiden_hiden) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hidenControl];
        
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化
-(void)commit_subViews
{
    {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, (210) + SafeAreaInsetsConstantForDeviceWithNotch.bottom)];
        [self addSubview:self.contentView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.contentView.bounds;
        [self.contentView addSubview:effectView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
    }
    
    //提示标题
    UILabel * tipsLab = [[UILabel alloc] init];
    tipsLab.text = @"拖动选择暂停位置";
    tipsLab.textColor = [UIColor whiteColor];
    tipsLab.font = [UIFont systemFontOfSize:14];
    tipsLab.frame = CGRectMake(0, 0, self.width, 30);
    [self.contentView addSubview:tipsLab];
    
    //中间主容器
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, (59), self.width, (67))];
    [self.contentView addSubview:self.progressView];
    
    //时间线填充
    UIImageView * contentImg = [[UIImageView alloc] initWithFrame:CGRectMake((15), 0, self.width - (30), self.progressView.frame.size.height)];
    contentImg.backgroundColor = [UIColor grayColor];
    contentImg.layer.cornerRadius = 4;
    contentImg.layer.masksToBounds = YES;
    [self.progressView addSubview:contentImg];
    
    //每秒占用长度
    self.perSecontWidth = ((self.progressView.frame.size.width - (30)) / 15.0);
    
    //已录制时间区域
    if (self.curentLength > 0) {
        //已录制填充区域宽度
        CGFloat filteWidth = self.perSecontWidth * self.curentLength;
        self.recodedView = [[UIView alloc] initWithFrame:CGRectMake((15), 0, filteWidth, self.progressView.frame.size.height)];
        self.recodedView.backgroundColor = [UIColor greenColor];
        self.recodedView.alpha = 0.7;
        self.recodedView.layer.cornerRadius = 4;
        self.recodedView.layer.masksToBounds = YES;
        [self.progressView addSubview:self.recodedView];
    }
    
    //开始-结束时间
    UILabel * lab1 = [[UILabel alloc] init];
    lab1.textColor = UIColor.grayColor;
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.text = @"0s";
    lab1.frame = CGRectMake(0, CGRectGetMinY(self.progressView.frame) - 30, 100, 30);
    [self.contentView addSubview:lab1];
    
    UILabel * lab2 = [[UILabel alloc] init];
    lab2.textColor = UIColor.grayColor;
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.textAlignment = NSTextAlignmentRight;
    lab2.text = @"15s";
    lab2.frame = CGRectMake(self.width - 100, CGRectGetMinY(self.progressView.frame) - 30, 100, 30);
    [self.contentView addSubview:lab2];
    
    //暂停时间
    self.pauseTimeLab = [[UILabel alloc] init];
    self.pauseTimeLab.textColor = UIColor.whiteColor;
    self.pauseTimeLab.font = [UIFont systemFontOfSize:14];
    self.pauseTimeLab.textAlignment = NSTextAlignmentCenter;
    self.pauseTimeLab.frame = CGRectMake(0, 0, 40, 30);
    [self.contentView addSubview:self.pauseTimeLab];
 
    //时间滑竿
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, self.progressView.frame.size.height)];
    self.sliderView.center = CGPointMake(self.width - (15), self.progressView.frame.size.height/2);
    self.sliderView.backgroundColor = [UIColor clearColor];
    [self.progressView addSubview:self.sliderView];
    
    CGFloat tWidth = self.sliderView.frame.size.width;
    CGFloat tHeight = self.sliderView.frame.size.height;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(tWidth, 0)];
    [path addLineToPoint:CGPointMake(tWidth, 3)];
    [path addLineToPoint:CGPointMake(tWidth/3*2, 3 + 4)];
    [path addLineToPoint:CGPointMake(tWidth/3*2, tHeight - (3+4))];
    [path addLineToPoint:CGPointMake(tWidth, tHeight - 3)];
    [path addLineToPoint:CGPointMake(tWidth, tHeight)];
    [path addLineToPoint:CGPointMake(0, tHeight)];
    [path addLineToPoint:CGPointMake(0, tHeight - 3)];
    [path addLineToPoint:CGPointMake(tWidth/3, tHeight - (3+4))];
    [path addLineToPoint:CGPointMake(tWidth/3, 3+4)];
    [path addLineToPoint:CGPointMake(0, 3)];
    [path closePath];
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = [[UIColor yellowColor] CGColor];
    layer.opacity = 1;
    layer.lineCap = kCALineCapButt;
    layer.strokeEnd =  1.0;
    layer.path = path.CGPath;
    [self.sliderView.layer addSublayer:layer];
    
    //开启倒计时按钮
    UIButton * countDownBtn = [UIButton buttonWithType:0];
    countDownBtn.frame = CGRectMake((15), CGRectGetMaxY(self.progressView.frame) + 20, self.width - (30), (45));
    countDownBtn.backgroundColor = [UIColor redColor];
    [countDownBtn setTitle:@"倒计时拍摄" forState:0];
    [countDownBtn setTitleColor:[UIColor whiteColor] forState:0];
    countDownBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    countDownBtn.layer.cornerRadius = 4;
    countDownBtn.layer.masksToBounds = YES;
    [countDownBtn addTarget:self action:@selector(countDownitemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:countDownBtn];
    
    [self contentAnimationShow:YES];
    
    [self updatePauseTime];
}
#pragma mark - 更新暂停时间lab
-(void)updatePauseTime
{
    self.pauseTimeLab.text = [NSString stringWithFormat:@"%.1f",self.pauseTime];
    
    CGFloat pointX = 15 + self.perSecontWidth * self.pauseTime;
    CGFloat pointY = CGRectGetMinY(self.progressView.frame) - self.pauseTimeLab.frame.size.height/2;
    
    self.pauseTimeLab.center = CGPointMake(pointX, pointY);
    
    if (self.pauseTime >= 14.0 || self.pauseTime <= self.curentLength + 1) {
        self.pauseTimeLab.hidden = YES;
    }else{
        self.pauseTimeLab.hidden = NO;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([touches anyObject].view == self.sliderView) {
        self.handleTouch = YES;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.handleTouch) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self.progressView];
    //DLog(@"%f   ---    %f",point.x,point.y);
    //判断是否超出时间容器区域
    if (point.y < 0 || point.y > self.progressView.frame.size.height) {
        self.handleTouch = NO;
        return;
    }
    
    //判断是否到两边 边界
    //左边-已录制时长区域
    if (point.x <= ((15) + self.perSecontWidth * self.curentLength)) {
        //到达左边边界
        point.x = (15) + self.perSecontWidth * self.curentLength;
    }else if (point.x >= self.progressView.frame.size.width - (15)) {
        //到达右边边界
        point.x = self.progressView.frame.size.width - (15);
    }
    
    //改变滑竿中心点
    CGPoint sliderCenter = self.sliderView.center;
    sliderCenter.x = point.x;
    self.sliderView.center = sliderCenter;
    
    //计算暂停时间
    CGFloat pauseTime = (point.x - (15)) / self.perSecontWidth;
    NSLog(@"暂停时间   %f",pauseTime);
    self.pauseTime = pauseTime;
    [self updatePauseTime];
}
#pragma mark - 容器弹起/收起
-(void)contentAnimationShow:(BOOL)show
{
    CGRect rect = self.contentView.frame;
    if (show) {
        rect.origin.y = self.height - ((210) + SafeAreaInsetsConstantForDeviceWithNotch.bottom);
    }else{
        rect.origin.y = self.height;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = rect;
    }];
}
#pragma mark - 倒计时拍摄
-(void)countDownitemClick
{
    self.needCountDown = YES;
    [self hiden_hiden_hiden];
}
#pragma mark - 退出
-(void)hiden_hiden_hiden
{
    self.callBack(self.needCountDown, self.pauseTime);
    [self contentAnimationShow:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showWithCurentLength:(CGFloat)curentLength callBack:(CountDownCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[CountDownBar class]]) {
            [subView removeFromSuperview];
        }
    }
    
    CountDownBar * view = [[CountDownBar alloc] initWithFrame:keywindow.bounds curentLength:curentLength callBack:callBack];
    [keywindow addSubview:view];
}
@end


@interface CountDownTimer ()

@property(nonatomic,strong)UILabel * aniLab;
@property(nonatomic,strong)NSTimer * timer;//倒计时定时器
@property(nonatomic,assign)NSInteger countDown;//倒计时 3-2-1-0

@property(nonatomic,copy)CountDownTimerCallBack callBack;//倒计时结束回调

@end

@implementation CountDownTimer
-(instancetype)initWithFrame:(CGRect)frame callBack:(CountDownTimerCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.callBack = callBack;
        
        self.aniLab = [[UILabel alloc] init];
        self.aniLab.textColor = [UIColor whiteColor];
        self.aniLab.font = [UIFont boldSystemFontOfSize:40];
        self.aniLab.textAlignment = NSTextAlignmentCenter;
        self.aniLab.frame = CGRectMake(0, 0, 100, 100);
        self.aniLab.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        [self addSubview:self.aniLab];
        
        self.countDown = 4;
        //定时器开启
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    return self;
}
-(void)labAnimation
{
    self.aniLab.hidden = NO;
    self.aniLab.layer.transform = CATransform3DMakeScale(7.0, 7.0, 1);
    [UIView animateWithDuration:0.5 animations:^{
        self.aniLab.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    } completion:^(BOOL finished) {
        self.aniLab.hidden = YES;
    }];
}
-(void)timer_handle
{
    self.countDown -= 1;
    if (self.countDown > 0) {
        self.aniLab.text = [NSString stringWithFormat:@"%ld",self.countDown];
        [self labAnimation];
    }else{
        [self dealloc_timer];
        self.callBack();
        [self removeFromSuperview];
    }
}
#pragma mark - 创建定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer_handle) userInfo:nil repeats:YES];
    }
    return _timer;
}
#pragma mark - 定时器销毁
-(void)dealloc_timer
{
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}
+ (void)showCounrDownTimerWIthCallBack:(CountDownTimerCallBack)callBack
{
    UIWindow * keywindow = [UIWindow ds_window];
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[CountDownTimer class]]) {
            [subView removeFromSuperview];
        }
    }
    
    CountDownTimer * timer = [[CountDownTimer alloc] initWithFrame:keywindow.bounds callBack:callBack];
    [keywindow addSubview:timer];
}

@end
