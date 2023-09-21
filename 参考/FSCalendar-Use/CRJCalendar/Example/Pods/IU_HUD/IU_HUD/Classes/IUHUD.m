//
//  IUHUD.m
//  IUHUD
//
//  Created by zhuyuhui on 2020/9/19.
//

#import "IUHUD.h"

@interface IUHUD ()<MBProgressHUDDelegate>
{
    MBProgressHUD   *_hud;
}

@end

@implementation IUHUD

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:view];
        _hud.delegate                  = self;                       // 设置代理
        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.animationType             = MBProgressHUDAnimationZoom; // 默认动画样式
        _hud.removeFromSuperViewOnHide = YES;
        _userInteractionEnabled = YES;
        _animationStyle = MBProgressHUDAnimationZoom;
        [view addSubview:_hud];
    }
    return self;
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [_hud hideAnimated:animated afterDelay:delay];
}

- (void)hideAnimated:(BOOL)animated {
    [_hud hideAnimated:animated];
}

- (void)showAnimated:(BOOL)animated {
    _hud.userInteractionEnabled = _userInteractionEnabled;
    
    // 如果设置这个属性,则只显示文本
    if (_showTextOnly == YES && _text != nil && _text.length != 0) {
        _hud.mode = MBProgressHUDModeText;
    }
    // 根据属性判断是否要显示文本
    if (_text != nil && _text.length != 0) {
        _hud.label.text = _text;
        _hud.label.numberOfLines = 0;
    }
    // 设置文本字体
    if (_textFont) {
        _hud.label.font = _textFont;
    }
    // _contentColor
    if (_contentColor) {
        _hud.contentColor = _contentColor;
    }
    
    // 设置背景色
    if (_backgroundColor) {
        _hud.bezelView.color = _backgroundColor;
    }
    
    // 文本颜色
    if (_labelColor) {
        _hud.label.textColor = _labelColor;
    }
    
    // 设置圆角
    if (_cornerRadius) {
        _hud.bezelView.layer.cornerRadius = _cornerRadius;
    }
    
    // 自定义view
    if (_customView) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = _customView;
    }
    
    // 边缘留白
    if (_margin > 0) {
        _hud.margin = _margin;
    }
    [_hud showAnimated:animated];
}

#pragma mark - HUD代理方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

#pragma mark - 重写setter方法
-(void)setAnimationStyle:(MBProgressHUDAnimation)animationStyle {
    _animationStyle    = animationStyle;
    _hud.animationType = animationStyle;
}

#pragma mark - 便利的方法
// 仅仅显示文本并持续几秒的方法
/* - 使用示例 -
 [IUHUD alertTextOnly:@"请稍后,显示不了..."
 configParameter:^(IUHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */
+ (void)alertTextOnly:(NSString *)text
     configParameter:(ConfigIUHUDBlock)config
            duration:(NSTimeInterval)sec
              inView:(UIView *)view
{
    IUHUD *hud      = [[IUHUD alloc] initWithView:view];
    hud.text            = text;
    hud.showTextOnly    = YES;
    hud.textFont = [UIFont systemFontOfSize:15];
    hud.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.cornerRadius = 10;    // 圆角
    hud.margin = 20;          // 边缘留白
    // 配置额外的参数
    if (config) config(hud);
    
    
    // 显示
    [hud showAnimated:YES];
    
    // 延迟sec后消失
    [hud hideAnimated:YES afterDelay:sec];
}

+ (void)alertTextOnly:(NSString *)text
            duration:(NSTimeInterval)sec
              inView:(UIView *)view
{
    [IUHUD alertTextOnly:text configParameter:nil duration:sec inView:view];
}

+ (void)alertTextOnly:(NSString *)text
              inView:(UIView *)view
{
    [IUHUD alertTextOnly:text configParameter:nil duration:1.5 inView:view];
}

// 显示文本与菊花并持续几秒的方法(文本为nil时只显示菊花)
/* - 使用示例 -
 [IUHUD showText:@"请稍后,显示不了..."
 configParameter:^(IUHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */
+ (void)alertText:(NSString *)text
 configParameter:(ConfigIUHUDBlock)config
        duration:(NSTimeInterval)sec
          inView:(UIView *)view
{
    IUHUD *hud  = [[IUHUD alloc] initWithView:view];
    hud.text        = text;
    hud.textFont = [UIFont systemFontOfSize:15];
    hud.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.cornerRadius = 10;
    hud.margin = 20;
    
    // 配置额外的参数
    if (config) config(hud);

    // 显示
    [hud showAnimated:YES];
    
    // 延迟sec后消失
    [hud hideAnimated:YES afterDelay:sec];
}

+ (void)alertText:(NSString *)text
        duration:(NSTimeInterval)sec
          inView:(UIView *)view
{
    [IUHUD alertText:text configParameter:nil duration:sec inView:view];
}

+ (void)alertText:(NSString *)text
          inView:(UIView *)view
{
    [IUHUD alertText:text configParameter:nil duration:1.5 inView:view];
}

// 加载自定义view并持续几秒的方法
/* - 使用示例 -
 [IUHUD showText:@"请稍后,显示不了..."
 configParameter:^(IUHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */
+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
       configParameter:(ConfigIUHUDBlock)config
              duration:(NSTimeInterval)sec
                inView:(UIView *)view
{
    IUHUD *hud     = [[IUHUD alloc] initWithView:view];
    hud.margin       = 0.1f;
    
    // 配置额外的参数
    if (config) config(hud);

    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud showAnimated:YES];
    
    [hud hideAnimated:YES afterDelay:sec];
}

+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
              duration:(NSTimeInterval)sec
                inView:(UIView *)view
{
    [IUHUD alertCustomView:viewBlock configParameter:nil duration:sec inView:view];
}

+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
                inView:(UIView *)view
{
    [IUHUD alertCustomView:viewBlock configParameter:nil duration:1.5 inView:view];
}



//返回类对象,显示时间自己控制
+ (instancetype)showTextOnly:(NSString *)text
             configParameter:(ConfigIUHUDBlock)config
                      inView:(UIView *)view
{
    IUHUD *hud     = [[IUHUD alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.textFont = [UIFont systemFontOfSize:15];
    hud.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.cornerRadius = 10;
    hud.margin = 20;
    // 配置额外的参数
    if (config) config(hud);

    // 显示
    [hud showAnimated:YES];

    return hud;
}

+ (instancetype)showTextOnly:(NSString *)text
                      inView:(UIView *)view
{
    return [IUHUD showTextOnly:text configParameter:nil inView:view];
}

+ (instancetype)showText:(NSString *)text
         configParameter:(ConfigIUHUDBlock)config
                  inView:(UIView *)view
{
    IUHUD *hud     = [[IUHUD alloc] initWithView:view];
    hud.text         = text;
    hud.textFont = [UIFont systemFontOfSize:15];
    hud.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.cornerRadius = 10;
    hud.margin = 20;
    // 配置额外的参数
    if (config) config(hud);

    // 显示
    [hud showAnimated:YES];
    
    return hud;
}

+ (instancetype)showText:(NSString *)text
                  inView:(UIView *)view
{
    return [IUHUD showText:text configParameter:nil inView:view];
}


+ (instancetype)showCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
               configParameter:(ConfigIUHUDBlock)config
                        inView:(UIView *)view
{
    IUHUD *hud     = [[IUHUD alloc] initWithView:view];
    hud.margin       = 0.1f;

    // 配置额外的参数
    if (config) config(hud);

    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud showAnimated:YES];
    
    return hud;
}

+ (instancetype)showCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
                        inView:(UIView *)view
{
    return [IUHUD showCustomView:viewBlock configParameter:nil inView:view];
}




- (void)dealloc
{
    NSLog(@"%@ 资源释放了,没有泄露^_^",[self class]);
}

@end

