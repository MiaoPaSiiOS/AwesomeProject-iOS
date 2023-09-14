
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DarkStarGeneral)

#pragma mark - General
/// 屏幕快照
- (UIImage *)ds_snapshot;

/// 屏幕快照生成pdf
- (NSData *)ds_snapshotPDF;

/// 截取 view 上某个位置的图像
- (UIImage *)ds_cutoutInViewWithRect:(CGRect)rect;

/// 毛玻璃效果
/// @param blurStyle 模糊程度
- (void)ds_addBlurEffectWith:(UIBlurEffectStyle)blurStyle;

#pragma mark - Draw

/**
 添加圆角，适用于自动布局，传入设置frame

 @param rect 目标view的frame
 @param corner 圆角位置
 @param radius 圆角大小
 */
- (void)ds_addRectCornerWithViewBounds:(CGRect)rect corner:(UIRectCorner)corner radius:(CGFloat)radius;

/**
 添加圆角,适用于已知frame，即非自动布局

 @param corner 圆角位置
 @param radius 圆角大小
 */
- (void)ds_addRectCornerWith:(UIRectCorner)corner radius:(CGFloat)radius;

/**
 添加圆角，适用于已知frame，即非自动布局，圆角位置为UIRectCornerAllCorners

 @param radius 圆角大小
 */
- (void)ds_addAllCornerWith:(CGFloat)radius;

/**
 添加圆角，适用于自动布局，传入设置frame，圆角位置为UIRectCornerAllCorners

 @param rect 目标view的frame
 @param radius 圆角大小
 */
- (void)ds_addAllCornerWithViewBounds:(CGRect)rect radius:(CGFloat)radius;

/**
 绘制虚线

 @param pointArr 通过NSStringFromCGPoint传入坐标数组
 @param lineWidth 虚线的宽度
 @param lineLength 虚线的长度
 @param lineSpacing 虚线的间距
 @param lineColor 虚线的颜色
 */
- (void)ds_drawDashLineWithpointArray:(NSArray *)pointArr lineWidth:(float)lineWidth lineLength:(float)lineLength lineSpacing:(float)lineSpacing lineColor:(UIColor *)lineColor;




#pragma mark - 添加手势

/**
 添加Tap手势
 
 @param target target description
 @param action 方法名
 */
- (void)ds_addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 添加Pan手势
 
 @param target target description
 @param action 方法名
 */
- (void)ds_addPanGestureRecognizerWithTarget:(id)target action:(SEL)action;

/**
 添加LongPress手势
 
 @param target target description
 @param action 方法名
 */
- (void)ds_addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action;



#pragma mark - 添加渐变色
- (void)ds_addGradientLayerWithStartColor:(UIColor *)startColor withendColor:(UIColor *)endColor;
- (void)ds_addGradientLayer:(CGRect)frame withStartColor:(UIColor *)startColor withendColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)ds_addGradientLayer:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius withStartColor:(UIColor *)startColor withendColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)ds_addGradientLayer:(CGRect)frame withBorderWidth:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius withStartColor:(UIColor *)startColor withendColor:(UIColor *)endColor;

- (CAGradientLayer *)ds_achiveGraduallylayer;

- (void)ds_removeGradientLayer;

- (CAGradientLayer *)ds_graduallylayer;



#pragma mark - 坐标转换
/**
 以指定的view作为参考系(坐标系统中的x,y的起始值以指定的view开始计算),获取当前view相对于指定view的相对位移值

 @param view 指定的view
 @return 相对于指定view的point值
 */
- (CGPoint)ds_frameOriginFromView:(UIView *)view;

/**
 以指定的view作为参考系(坐标系统中的x,y的起始值以指定的view开始计算),获取当前view相对于指定view的相对位移值

 @param view 指定的view
 @return 相对于指定view的frame值
 */
- (CGRect)ds_frameFromView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
