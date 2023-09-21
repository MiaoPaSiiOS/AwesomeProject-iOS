//
//  IUHUD.h
//  IUHUD
//
//  Created by zhuyuhui on 2020/9/19.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class IUHUD;

// 定义block
typedef void (^ConfigIUHUDBlock)(IUHUD *config);
typedef UIView * (^ConfigIUHUDCustomViewBlock)(void);

@interface IUHUD : NSObject
/// 动画效果
@property (nonatomic, assign) MBProgressHUDAnimation animationStyle;
/// 文本加菊花
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
/// 自定义view
@property (nonatomic, strong) UIView *customView;
/// 只显示文本的相关设置
@property (nonatomic, assign) BOOL showTextOnly;
/// 边缘留白
@property (nonatomic, assign) float margin;
/// 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 文本颜色
@property (nonatomic, strong) UIColor *labelColor;
/// A color that gets forwarded to all labels and supported indicators.
@property (nonatomic, strong) UIColor *contentColor;
/// 圆角
@property (nonatomic, assign) float cornerRadius;
/// default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
@property (nonatomic, assign) BOOL userInteractionEnabled;

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
               inView:(UIView *)view;

+ (void)alertTextOnly:(NSString *)text
             duration:(NSTimeInterval)sec
               inView:(UIView *)view;

+ (void)alertTextOnly:(NSString *)text
               inView:(UIView *)view;

// 显示文本与菊花并持续几秒的方法(文本为nil时只显示菊花)
/* - 使用示例 -
 [IUHUD alertText:@"请稍后,显示不了..."
 configParameter:^(IUHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */
+ (void)alertText:(NSString *)text
    configParameter:(ConfigIUHUDBlock)config
           duration:(NSTimeInterval)sec
             inView:(UIView *)view;

+ (void)alertText:(NSString *)text
         duration:(NSTimeInterval)sec
           inView:(UIView *)view;

+ (void)alertText:(NSString *)text
           inView:(UIView *)view;

// 加载自定义view并持续几秒的方法
/* - 使用示例 -
 [IUHUD alertText:@"请稍后,显示不了..."
 configParameter:^(IUHUD *config) {
 config.margin          = 10.f;    // 边缘留白
 config.opacity         = 0.7f;    // 设定透明度
 config.cornerRadius    = 2.f;     // 设定圆角
 } duration:3 inView:self.view];
 */
+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
        configParameter:(ConfigIUHUDBlock)config
               duration:(NSTimeInterval)sec
                 inView:(UIView *)view;

+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
               duration:(NSTimeInterval)sec
                 inView:(UIView *)view;

+ (void)alertCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
                 inView:(UIView *)view;

//返回类对象,显示时间自己控制
+ (instancetype)showTextOnly:(NSString *)text
             configParameter:(ConfigIUHUDBlock)config
                      inView:(UIView *)view;
+ (instancetype)showTextOnly:(NSString *)text
                      inView:(UIView *)view;

+ (instancetype)showText:(NSString *)text
         configParameter:(ConfigIUHUDBlock)config
                  inView:(UIView *)view;
+ (instancetype)showText:(NSString *)text
                  inView:(UIView *)view;

+ (instancetype)showCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
               configParameter:(ConfigIUHUDBlock)config
                        inView:(UIView *)view;
+ (instancetype)showCustomView:(ConfigIUHUDCustomViewBlock)viewBlock
                        inView:(UIView *)view;

- (void)hideAnimated:(BOOL)animated;
@end


