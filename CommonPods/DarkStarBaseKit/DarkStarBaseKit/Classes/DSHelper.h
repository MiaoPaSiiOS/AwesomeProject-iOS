//
//  DSHelper.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#pragma mark - 常用Block定义
typedef void (^IUVoidBlock)(void);
typedef BOOL (^IUBoolBlock)(void);
typedef int  (^IUIntBlock) (void);
typedef id   (^IUIDBlock)  (void);

typedef void (^IUVoidBlock_int)(int);
typedef BOOL (^IUBoolBlock_int)(int);
typedef int  (^IUIntBlock_int) (int);
typedef id   (^IUIDBlock_int)  (int);

typedef void (^IUVoidBlock_string)(NSString *);
typedef BOOL (^IUBoolBlock_string)(NSString *);
typedef int  (^IUIntBlock_string) (NSString *);
typedef id   (^IUIDBlock_string)  (NSString *);

typedef void (^IUVoidBlock_id)(id);
typedef BOOL (^IUBoolBlock_id)(id);
typedef int  (^IUIntBlock_id) (id);
typedef id   (^IUIDBlock_id)  (id);


@interface DSHelper : NSObject
#pragma mark - NSBundle
/// 获取Pod库中的指定NSBundle（Pod库中可能存在多个.bundle文件）
/// @param bundleName bundle名
/// @param podName pod名
+ (NSBundle *)findBundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;
/// 获取Bundle中指定资源path路径
/// @param bundle bundle description
/// @param name 文件名 e.g:  home
/// @param ext 文件后缀 e.g: png
+ (NSString *)pathForScaledResourceWithBundle:(NSBundle *)bundle name:(NSString *)name ofType:(NSString *)ext;
/// 获取Bundle中指定资源path路径
/// 获取bundle中xxx文件夹中home.png，dirPath传xxx即可
/// @param bundle bundle description
/// @param name name description
/// @param ext ext description
/// @param subpath 子路径
+ (NSString *)pathForScaledResourceWithBundle:(NSBundle *)bundle name:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;
/// 获取Bundle中的图片
/// @param name name description
/// @param bundle bundle description
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

+ (NSArray *)preferredScales;
#pragma mark - 颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
+ (UIColor *)colorWithColorString:(NSString *)colorString;
+ (UIColor *)randomColor;

#pragma mark - UIWindow | UIViewController
+ (UIWindow *)findWindow;
+ (UIViewController *)findTopViewController;
+ (UIViewController *)findTopViewController:(UIViewController *)rootViewController;

/// 获取当前View所在控制器
/// @param view view description
+ (UIViewController *)findCurrentViewControllerAtView:(UIView *)view;
///  获取和自身处于同一个UINavigationController里的上一个UIViewController
/// @param viewController viewController description
+ (UIViewController *)findPreviousViewController:(UIViewController *)viewController;


#pragma mark - NSString
/**
 判断对象是否存在, 是否为 NSString 类型

 @param obj 要判断的对象
 @return 对象为 NSString 类型: YES, 对象不存在或不是 NSString 类型: NO
 */
+(BOOL)isString:(id)obj;

/**
 判断对象是否存在, 是否为 NSString 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isStringEmptyOrNil:(id)obj;

/**
 直接取值

 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: 空字符串, 其他情况: 原值
 */
+(NSString* )safeString:(id)obj;
#pragma mark - NSArray

/**
 判断对象是否存在, 是否为 NSArray 类型

 @param obj 要判断的对象
 @return 对象存在为 NSArray 类型: YES, 对象不存在或不是 NSArray 类型: NO
 */
+(BOOL)isArray:(id)obj;

/**
 判断对象是否存在, 是否为 NSArray 类型, 是否有数据 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSArray 类型 或数组为空 或为nil: YES, 其他情况: NO
 */
+(BOOL)isArrayEmptyOrNil:(id)obj;

#pragma mark - NSDictionary


/**
 判断对象是否存在, 是否为 NSDictionary 类型

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型: YES, 对象不存在或不是 NSDictionary 类型: NO
 */
+(BOOL)isDictionary:(id)obj;

/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型且字典不为空: 原对象字典, 其他情况: 空字典
 */
+(NSDictionary *)isEmptyDict:(id)obj;


/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSDictionary 类型 或字典为空 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isDictEmptyOrNil:(id)obj;

#pragma mark - JSON & STRING
+(NSDictionary*)JSON_OBJ_FROM_STRING:(NSString *)jsonString;
+(NSString*)JSON_STRING_FROM_OBJ:(NSDictionary *)dic;



#pragma mark - UIScrollView
+ (void)scrollToTop:(UIScrollView *)scrollView;
+ (void)scrollToBottom:(UIScrollView *)scrollView;
+ (void)scrollToLeft:(UIScrollView *)scrollView;
+ (void)scrollToRight:(UIScrollView *)scrollView;
+ (void)scrollToTop:(UIScrollView *)scrollView animated:(BOOL)animated;
+ (void)scrollToBottom:(UIScrollView *)scrollView animated:(BOOL)animated;
+ (void)scrollToLeft:(UIScrollView *)scrollView animated:(BOOL)animated;
+ (void)scrollToRight:(UIScrollView *)scrollView animated:(BOOL)animated;

#pragma mark - Alert
+ (void)showAlertControllerWithTitle:(id)title message:(id)message buttonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock;

+ (void)showAlertControllerWithTitle:(id)title message:(id)message alertClick:(IUVoidBlock_int)clickBlock;

+ (void)showAlertControllerWithTitle:(id)title message:(id)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr  alertClick:(IUVoidBlock_int)clickBlock;

#pragma mark - Alert Sheet
+ (void)showAlertSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr  alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock;

+ (void)showAlertSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock;

+ (void)showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock;

+ (void)showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock;

+ (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock;

#pragma mark - 添加渐变色

/// 添加横向渐变色
/// @param view view description
/// @param startColor startColor description
/// @param endColor endColor description
+ (void)addHorizontalGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/// 添加竖向渐变色
/// @param view view description
/// @param startColor startColor description
/// @param endColor endColor description
+ (void)addVerticalGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame colors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(CGFloat)cornerRadius;
+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame colors:(NSArray *)colors endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth;
+ (CAGradientLayer *)gradientLayerToView:(UIView *)view;
+ (void)removeGradientLayerToView:(UIView *)view;

#pragma mark - 添加手势
+ (void)addTapGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action;
+ (void)addPanGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action;
+ (void)addLongPressGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action;

#pragma mark - 添加圆角
+ (void)addAllCornerToView:(UIView *)view radius:(CGFloat)radius;
+ (void)addAllCornerToView:(UIView *)view rect:(CGRect)rect radius:(CGFloat)radius;
+ (void)addCornerToView:(UIView *)view corner:(UIRectCorner)corner radius:(CGFloat)radius;
+ (void)addRectCorneToView:(UIView *)view rect:(CGRect)rect corner:(UIRectCorner)corner radius:(CGFloat)radius;
+ (void)setCornerWithLeftTopCorner:(CGFloat)leftTop
                    rightTopCorner:(CGFloat)rigtTop
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight
                              view:(UIView *)view
                             frame:(CGRect)frame;
#pragma mark - UIImage
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 屏幕截图
/// 屏幕快照
/// @param view view description
+ (UIImage *)snapshotForView:(UIView *)view;

/// 屏幕快照-生成PDF
/// @param view view description
+ (NSData *)snapshotPDFForView:(UIView *)view;

/// 截取 view 上某个位置的图像
/// @param rect rect description
/// @param view view description
+ (UIImage *)cutoutInViewWithRect:(CGRect)rect forView:(UIView *)view;

#pragma mark - 毛玻璃
/// 毛玻璃效果
/// @param blurStyle blurStyle description
/// @param view view description
+ (void)addBlurEffectWith:(UIBlurEffectStyle)blurStyle forView:(UIView *)view;

/// 使用CoreImage技术使图片模糊
/// @param image image description
/// @param blurNum 模糊数值 0~100 （默认100）
+ (UIImage *)blurImage:(UIImage *)image WithCoreImageBlurNumber:(CGFloat)blurNum;
/// 使用Accelerate技术模糊图片，模糊效果比CoreImage效果更美观，效率要比CoreImage要高，处理速度快
/// @param image image description
/// @param blurValue 模糊数值 0 ~ 1.0，默认0.1
+ (UIImage *)blurImage:(UIImage *)image WithAccelerateBlurValue:(CGFloat)blurValue;

/// 高亮模糊
/// @param image image description
+ (UIImage *)applyLightEffectImage:(UIImage *)image;

/// 轻度亮模糊
/// @param image image description
+ (UIImage *)applyExtraLightEffectImage:(UIImage *)image;

/// 暗色模糊
/// @param image image description
+ (UIImage *)applyDarkEffectImage:(UIImage *)image;

/// 自定义颜色模糊图片
/// @param image image description
/// @param tintColor 影响颜色
+ (UIImage *)applyTintEffectImage:(UIImage *)image tintColor:(UIColor*)tintColor;

/// 模糊图片
/// @param image image description
/// @param blurRadius 模糊半径
/// @param tintColor 颜色
/// @param saturationDeltaFactor 饱和增量因子 0 图片色为黑白 小于0颜色反转 大于0颜色增深
/// @param maskImage 遮罩图像
+ (UIImage *)applyBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

#pragma mark - 颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

#pragma mark - 生成渐变色的图片
+ (UIImage *)gradientColorImageWithSize:(CGSize)size colors:(NSArray *)colors startPoint:(CGPoint)startP endPoint:(CGPoint)endP;

#pragma mark - 生成带圆角的颜色图片
/// 生成矩形的颜色图片
/// @param color color description
/// @param targetSize targetSize description
+ (UIImage *)squareImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize;

/// 生成带圆角的颜色图片,背景默认白色
/// @param color color description
/// @param targetSize targetSize description
/// @param cornerRadius cornerRadius description
+ (UIImage *)cornerRadiusImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)cornerRadiusImageWithColor:(UIColor *)tintColor targetSize:(CGSize)targetSize corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor;

#pragma mark - 图片裁剪
/// 裁剪图片中的一块区域
/// @param image image description
/// @param clipRect clipRect description
+ (UIImage *)image:(UIImage *)image clipRect:(CGRect)clipRect;
/// 图片裁剪，默认全圆角
/// @param image image description
/// @param radius radius description
+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius;

/// 图片裁剪+边框，默认全圆角
/// @param image image description
/// @param radius radius description
/// @param borderWidth borderWidth description
/// @param borderColor borderColor description
+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin;

#pragma mark - 图片@拉伸
/// 拉伸图片
/// @param image image description
/// @param edgeInsets 不进行拉伸的区域
/// @param resizingMode 处理方式
+ (UIImage *)resizableImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets resizingMode:(UIImageResizingMode)resizingMode;

/// 创建一个内容可拉伸，而边角不拉伸的图片，例如，leftCapHeight为6，topCapHeight为8。那么，图片左边的6个像素，上边的8个像素。不会被拉伸，
/// 而左边的第7个像素，上边的第9个像素这一块区域将会被拉伸。剩余的部分也不会被拉伸。***这个方法只能拉伸1x1的区域***
/// @param image image description
/// @param left 左边不拉伸区域的宽度
/// @param top 上面不拉伸的高度
+ (UIImage *)stretchableImage:(UIImage *)image left:(NSInteger)left top:(NSInteger)top;

/// 改变图片尺寸
/// @param image image description
/// @param newSize 新尺寸
/// @param isScale 是否按照比例转换
+ (UIImage *)changeSizeImage:(UIImage *)image newSize:(CGSize)newSize isScale:(BOOL)isScale;

/*
 static UIImage *topLineBG = [DSHelper imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
     CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
     CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
     CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
     CGContextFillPath(context);
 }];
 */
/// 图像绘制block
/// @param size 尺寸
/// @param drawBlock 绘制回调
+ (UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

/// Create a square image from apple emoji.
/// It creates a square image from apple emoji, image's scale is equal to current screen's scale.
/// The original emoji image in `AppleColorEmoji` font is in size 160*160 px.
/// @param emoji single emoji, such as @"😄".
/// @param size image's size.
+ (UIImage *)imageWithEmoji:(NSString *)emoji size:(CGFloat)size;



#pragma mark - PHAsset
+ (PHAsset *)latestAsset;
+ (void)latestOriginImageWithCompleteBlock:(void (^)(UIImage *))block;
+ (void)latestImageWithSize:(CGSize)size completeBlock:(void (^)(UIImage *))block;


#pragma mark - NSTimer
/// Creates and returns a new NSTimer object and schedules it on the current runloop in the default mode.
/// @param seconds The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
/// @param block The block to invoke when the timer fires. The timer  maintains a strong reference to the block until it (the timer) is invalidated.
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/// Creates and returns a new NSTimer object initialized with the specified block.
/// @param seconds The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
/// @param block  The block to invoke when the timer fires. The timer instructs the block to maintain a strong reference to its arguments.
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

#pragma mark - 文本校验
/// 检测字符串是否包含中文
+(BOOL)checkIsContainChinese:(NSString *)string;
/// 整形
+ (BOOL)checkIsPureInt:(NSString *)string;
/// 浮点型
+ (BOOL)checkIsPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)checkIsValidMobile:(NSString *)string;

/// 纯数字
+ (BOOL)checkIsPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)checkIsValidCharacterOrNumber:(NSString *)string;

/// 判断是否全是空格
+ (BOOL)checkIsEmpty:(NSString *)string;

/// 是否是正确的邮箱
+ (BOOL)checkIsValidEmail:(NSString *)string;

/// 是否是正确的QQ
+ (BOOL)checkIsValidQQ:(NSString *)string;

#pragma mark - NSDate

/// 日期转换（类似朋友圈）
/// @param date date description
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

#pragma mark - ???
+ (NSString *)shortedNumberDesc:(NSUInteger)number;
/// 生成 [min, max] 区间的随机数
+ (NSInteger)getRandomNumber:(NSInteger)min max:(NSInteger)max;
@end
