

#import "PNCGifWaitView.h"
#import "RECacheManger.h"

@interface PNCGifWaitView ()

@property(strong,nonatomic)UIView *supView;
@property(strong,nonatomic)UIImageView *WaitImgView;
@property (nonatomic, assign) BOOL isRotate;

@end

@implementation PNCGifWaitView

#pragma  mark -  等待层覆盖在 UIViewController 上导航栏以下部分
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
   
    if (waitView==nil) {
        PNCGifWaitView *waitView = [[PNCGifWaitView alloc]initWithSuperViewController:vc style:style];
        [waitView show];
    }
  
}

#pragma  mark -  等待层覆盖在 UIViewController 上导航栏以下部分 __旋转90度
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style isRotate:(BOOL)rotate
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
    
    if (waitView==nil) {
        PNCGifWaitView *waitView = [[PNCGifWaitView alloc]initWithSuperViewController:vc style:style isRotate:YES];
        [waitView show];
    }
    waitView.isRotate = YES;
}

#pragma  mark -  等待层全屏覆盖在 View上 带提示语 及 是否旋转
+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style isRotate:(BOOL)isRotate
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style isRotate:isRotate];
    [waitView show];
}


+(void)hideWaitViewInController:(UIViewController *)vc
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
    if (waitView != nil) {
        [waitView hide];
    }
}


#pragma  mark -  等待层全屏覆盖在 View上

+(UIView *)bcmShowWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style];
    [waitView show];
    return waitView;
}

+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style];
    [waitView show];
}

+(void)hideWaitViewInView:(UIView *)view
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView=(PNCGifWaitView *)[superView viewWithTag:9001];
    [waitView hide];
}
#pragma 隐藏刷新加载的透明蒙版
+ (void)hideRefreshWaitView:(UIView *)view
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView=(PNCGifWaitView *)[superView viewWithTag:9003];
    [waitView hide];
}
#pragma 为了配合长登录 增加倒8
+ (void)hideLongLoginWaitView {
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    PNCGifWaitView * waitView = (PNCGifWaitView *)[window viewWithTag:9002];
    if (waitView) {
        [waitView hide];
    }
}

-(id)initWithSuperView:(UIView *)superView style:(PNCGifWaitingStyle)style{
    
    if (self = [super init]) {
        _supView = superView;
        self.frame = superView.bounds;
        [self drawFrame:style];
    }
    return self;
}


-(id)initWithSuperViewController:(UIViewController *)viewController style:(PNCGifWaitingStyle)style
{
    if (self = [super init]) {
      
        _supView = viewController.view;
        self.size = CGSizeMake(kScreenWidth, kScreenHeight - kNaviBarHeight);
        self.origin = CGPointMake(0, kNaviBarHeight);

        [self drawFrame:style];
    
    }
    return self;
}

-(id)initWithSuperViewController:(UIViewController *)viewController style:(PNCGifWaitingStyle)style isRotate:(BOOL)rotate
{
    if (self = [super init]) {
        
        _supView = viewController.view;
        self.size=CGSizeMake(kScreenWidth,kScreenHeight-kNaviBarHeight);
        self.origin=CGPointMake(0, kNaviBarHeight);
        self.isRotate = rotate;
        [self drawFrame:style];
        
    }
    return self;
}

-(id)initWithSuperView:(UIView *)superView style:(PNCGifWaitingStyle)style isRotate:(BOOL)isRotate{
    
    if (self = [super init]) {
        _supView = superView;
        self.frame = superView.bounds;
        self.isRotate = isRotate;
        [self drawFrame:style];
    }
    return self;
}

-(void)setIsRotate:(BOOL)isRotate
{
    _isRotate = isRotate;
}

- (void)drawFrame:(PNCGifWaitingStyle)style {
    
    if (style == DefaultWaitStyle || style == LongLoginWaitStyle) { //灰底白色转圈样式
        
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake((self.width - (75))/2, self.height*0.4 - (75)/2, (75), (75))];
        
        if(self.height == kScreenHeight - kNaviBarHeight) {
            mainview.origin = CGPointMake((self.width - (75))/2, kScreenHeight*0.4 - (75)/2 - kNaviBarHeight);
        }
        if (self.isRotate) {
            //旋转90度
            mainview.transform = CGAffineTransformRotate(mainview.transform, M_PI*0.5);
            mainview.center = CGPointMake(self.width/2, self.height/2);
        }
        [mainview setBackgroundColor:[UIColor blackColor]];
        mainview.layer.cornerRadius = 12;
        mainview.alpha = 0.5;
        
        self.WaitImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (55), (55))];
        [self.WaitImgView setCenter:CGPointMake(mainview.width/2, mainview.height/2)];
        
        self.WaitImgView.animationImages = [RECacheManger sharedInstance].refreshWhiteLoadingArray;
        self.WaitImgView.animationDuration = 1;
        self.WaitImgView.animationRepeatCount = 0;
        [self.WaitImgView startAnimating];
        
        [mainview addSubview:self.WaitImgView];
        
        self.tag = 9001;
        if (style == LongLoginWaitStyle){
            self.tag = 9002;
        }
        [self addSubview:mainview];
        
        [_supView addSubview:self];
        
    } else if (style == ClearColorStyle) {
        self.tag = 9003;
        [_supView addSubview:self];
    }else { //无底色蓝色转圈样式
        
        CGFloat scale = 0.4;
        if (style == PartLoadWaitStyle) {
            scale = 0.5;
        }
        
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake((self.width - (55))/2, self.height*scale - (55)/2, (55), (55))];
        mainview.centerX = self.width/2;

        if(style != PartLoadWaitStyle && self.height == kScreenHeight - kNaviBarHeight) {
            mainview.origin = CGPointMake((self.width - (55))/2, kScreenHeight*0.4 - (55)/2 - kNaviBarHeight);
        }
        if (self.isRotate) {
            //旋转90度
            mainview.transform = CGAffineTransformRotate(mainview.transform, M_PI*0.5);
            mainview.center = CGPointMake(self.width/2, self.height/2);
        }
        [mainview setBackgroundColor:[UIColor clearColor]];
        
        self.WaitImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (55), (55))];
        [self.WaitImgView setCenter:CGPointMake(mainview.width/2, mainview.height/2)];
        
        self.WaitImgView.animationImages = [RECacheManger sharedInstance].refreshBlueLoadingArray;
        self.WaitImgView.animationDuration = 1;
        self.WaitImgView.animationRepeatCount = 0;
        [self.WaitImgView startAnimating];
        
        [mainview addSubview:self.WaitImgView];
        
        self.tag = 9001;
        [self addSubview:mainview];
        [_supView addSubview:self];
        
    }
}

-(void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_supView bringSubviewToFront:self];
    });
}

-(void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.WaitImgView stopAnimating];
        [self removeFromSuperview];
    });
}

@end
