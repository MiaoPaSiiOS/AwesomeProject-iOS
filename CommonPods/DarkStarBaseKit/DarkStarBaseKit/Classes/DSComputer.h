//
//  DSComputer.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSComputer : NSObject
#pragma mark - CGFloat

/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 *  issue: https://github.com/Tencent/QMUI_iOS/issues/203
 */
+(CGFloat)removeFloatMin:(CGFloat)floatValue;

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
+(CGFloat)flatSpecificScale:(CGFloat)floatValue scale:(CGFloat)scale;

/**
 *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
 */
+(CGFloat)flat:(CGFloat)floatValue;

/**
 *  类似flat()，只不过 flat 是向上取整，而 floorInPixel 是向下取整
 */
+(CGFloat)floorInPixel:(CGFloat)floatValue;

+(BOOL)between:(CGFloat)minimumValue value:(CGFloat)value maximumValue:(CGFloat)maximumValue;

+(BOOL)betweenOrEqual:(CGFloat)minimumValue value:(CGFloat)value maximumValue:(CGFloat)maximumValue;

/**
 *  调整给定的某个 CGFloat 值的小数点精度，超过精度的部分按四舍五入处理。
 *
 *  例如 CGFloatToFixed(0.3333, 2) 会返回 0.33，而 CGFloatToFixed(0.6666, 2) 会返回 0.67
 *
 *  @warning 参数类型为 CGFloat，也即意味着不管传进来的是 float 还是 double 最终都会被强制转换成 CGFloat 再做计算
 *  @warning 该方法无法解决浮点数精度运算的问题，如需做浮点数的 == 判断，可用下方的 CGFloatEqualToFloat()
 */
+(CGFloat)CGFloatToFixed:(CGFloat)value precision:(NSUInteger)precision;

/**
 将给定的两个 CGFloat 进行等值比较，并通过参数 precision 指定要考虑的小数点后的精度，内部会将浮点数转成整型，从而避免浮点数精度导致的 == 判断错误。
 例如 CGFloatEqualToFloatWithPrecision(1.000, 0.999, 0) 会返回 YES，但 1.000 == 0.999 会得到 NO。
 */
+(BOOL)CGFloatEqualToFloatWithPrecision:(CGFloat)value1 value2:(CGFloat)value2 precision:(NSUInteger)precision;

/**
 将给定的两个 CGFloat 进行等值比较，不考虑小数点后的数值。
 例如 CGFloatEqualToFloat(1.000, 0.999) 会返回 YES，但 1.000 == 0.999 会得到 NO。
 */
+(BOOL)CGFloatEqualToFloat:(CGFloat)value1 value2:(CGFloat)value2;

/// 用于居中运算
+(CGFloat)CGFloatGetCenter:(CGFloat)parent child:(CGFloat)child;

/// 检测某个数值如果为 NaN 则将其转换为 0，避免布局中出现 crash
+(CGFloat)CGFloatSafeValue:(CGFloat)value;

#pragma mark - CGPoint

/// 两个point相加
+(CGPoint)CGPointUnion:(CGPoint)point1 point2:(CGPoint)point2;

/// 获取rect的center，包括rect本身的x/y偏移
+(CGPoint)CGPointGetCenterWithRect:(CGRect)rect;

+(CGPoint)CGPointGetCenterWithSize:(CGSize)size;

+(CGPoint)CGPointToFixed:(CGPoint)point precision:(NSUInteger)precision;

+(CGPoint)CGPointRemoveFloatMin:(CGPoint)point;

#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
+(CGFloat)UIEdgeInsetsGetHorizontalValue:(UIEdgeInsets)insets;

/// 获取UIEdgeInsets在垂直方向上的值
+(CGFloat)UIEdgeInsetsGetVerticalValue:(UIEdgeInsets)insets;

/// 将两个UIEdgeInsets合并为一个
+(UIEdgeInsets)UIEdgeInsetsConcat:(UIEdgeInsets)insets1 insets2:(UIEdgeInsets)insets2;

+(UIEdgeInsets)UIEdgeInsetsSetTop:(UIEdgeInsets)insets top:(CGFloat)top;

+(UIEdgeInsets)UIEdgeInsetsSetLeft:(UIEdgeInsets)insets left:(CGFloat)left;

+(UIEdgeInsets)UIEdgeInsetsSetBottom:(UIEdgeInsets)insets bottom:(CGFloat)bottom;

+(UIEdgeInsets)UIEdgeInsetsSetRight:(UIEdgeInsets)insets right:(CGFloat)right;

+(UIEdgeInsets)UIEdgeInsetsToFixed:(UIEdgeInsets)insets precision:(NSUInteger)precision;

+(UIEdgeInsets)UIEdgeInsetsRemoveFloatMin:(UIEdgeInsets)insets;

#pragma mark - CGSize

/// 判断一个 CGSize 是否存在 NaN
+(BOOL)CGSizeIsNaN:(CGSize)size;

/// 判断一个 CGSize 是否存在 infinite
+(BOOL)CGSizeIsInf:(CGSize)size;

/// 判断一个 CGSize 是否为空（宽或高为0）
+(BOOL)CGSizeIsEmpty:(CGSize)size;

/// 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
+(BOOL)CGSizeIsValidated:(CGSize)size;

/// 将一个 CGSize 像素对齐
+(CGSize)CGSizeFlatted:(CGSize)size;

/// 将一个 CGSize 以 pt 为单位向上取整
+(CGSize)CGSizeCeil:(CGSize)size;

/// 将一个 CGSize 以 pt 为单位向下取整
+(CGSize)CGSizeFloor:(CGSize)size;

+(CGSize)CGSizeToFixed:(CGSize)size precision:(NSUInteger)precision;

+(CGSize)CGSizeRemoveFloatMin:(CGSize)size;

+(CGSize)CGSizePixelRound:(CGSize)size;

+(CGFloat)CGFloatPixelRound:(CGFloat)value;

/// floor point value for pixel-aligned
+(CGFloat)CGFloatPixelFloor:(CGFloat)value;

/// floor UIEdgeInset for pixel-aligned
+(UIEdgeInsets)UIEdgeInsetPixelFloor:(UIEdgeInsets)insets;
#pragma mark - CGRect
/// 判断一个 CGRect 是否存在 NaN
+(BOOL)CGRectIsNaN:(CGRect)rect;

/// 系统提供的 CGRectIsInfinite 接口只能判断 CGRectInfinite 的情况，而该接口可以用于判断 INFINITY 的值
+(BOOL)CGRectIsInf:(CGRect)rect;

/// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
+(BOOL)CGRectIsValidated:(CGRect)rect;

/// 检测某个 CGRect 如果存在数值为 NaN 的则将其转换为 0，避免布局中出现 crash
+(CGRect)CGRectSafeValue:(CGRect)rect;

/// 创建一个像素对齐的CGRect
+(CGRect)CGRectFlatMake:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
+(CGRect)CGRectFlatted:(CGRect)rect;

/// 计算目标点 targetPoint 围绕坐标点 coordinatePoint 通过 transform 之后此点的坐标
+(CGPoint)CGPointApplyAffineTransformWithCoordinatePoint:(CGPoint)coordinatePoint targetPoint:(CGPoint)targetPoint t:(CGAffineTransform)t;

/// 系统的 CGRectApplyAffineTransform 只会按照 anchorPoint 为 (0, 0) 的方式去计算，但通常情况下我们面对的是 UIView/CALayer，它们默认的 anchorPoint 为 (.5, .5)，所以增加这个函数，在计算 transform 时可以考虑上 anchorPoint 的影响
+(CGRect)CGRectApplyAffineTransformWithAnchorPoint:(CGRect)rect t:(CGAffineTransform)t anchorPoint:(CGPoint)anchorPoint;

/// 为一个CGRect叠加scale计算
+(CGRect)CGRectApplyScale:(CGRect)rect scale:(CGFloat)scale;

/// 计算view的水平居中，传入父view和子view的frame，返回子view在水平居中时的x值
+(CGFloat)CGRectGetMinXHorizontallyCenterInParentRect:(CGRect)parentRect childRect:(CGRect)childRect;

/// 计算view的垂直居中，传入父view和子view的frame，返回子view在垂直居中时的y值
+(CGFloat)CGRectGetMinYVerticallyCenterInParentRect:(CGRect)parentRect childRect:(CGRect)childRect;

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持垂直居中时，layoutingRect的originY
+(CGFloat)CGRectGetMinYVerticallyCenter:(CGRect)referenceRect layoutingRect:(CGRect)layoutingRect;

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持水平居中时，layoutingRect的originX
+(CGFloat)CGRectGetMinXHorizontallyCenter:(CGRect)referenceRect layoutingRect:(CGRect)layoutingRect;

/// 为给定的rect往内部缩小insets的大小（系统那个方法的命名太难联想了，所以定义了一个新函数）
+(CGRect)CGRectInsetEdges:(CGRect)rect insets:(UIEdgeInsets)insets;
/// 以inset填充矩形框.
+(CGRect)CGRectFrameInset:(CGRect)rect insets:(UIEdgeInsets)insets;
/// 传入size，返回一个x/y为0的CGRect
+(CGRect)CGRectMakeWithSize:(CGSize)size;

+(CGRect)CGRectFloatTop:(CGRect)rect top:(CGFloat)top;

+(CGRect)CGRectFloatBottom:(CGRect)rect bottom:(CGFloat)bottom;

+(CGRect)CGRectFloatRight:(CGRect)rect right:(CGFloat)right;

+(CGRect)CGRectFloatLeft:(CGRect)rect left:(CGFloat)left;

/// 保持rect的左边缘不变，改变其宽度，使右边缘靠在right上
+(CGRect)CGRectLimitRight:(CGRect)rect rightLimit:(CGFloat)rightLimit;

/// 保持rect右边缘不变，改变其宽度和origin.x，使其左边缘靠在left上。只适合那种右边缘不动的view
/// 先改变origin.x，让其靠在offset上
/// 再改变size.width，减少同样的宽度，以抵消改变origin.x带来的view移动，从而保证view的右边缘是不动的
+(CGRect)CGRectLimitLeft:(CGRect)rect leftLimit:(CGFloat)leftLimit;

/// 限制rect的宽度，超过最大宽度则截断，否则保持rect的宽度不变
+(CGRect)CGRectLimitMaxWidth:(CGRect)rect maxWidth:(CGFloat)maxWidth;

+(CGRect)CGRectSetX:(CGRect)rect x:(CGFloat)x;

+(CGRect)CGRectSetY:(CGRect)rect y:(CGFloat)y;

+(CGRect)CGRectSetXY:(CGRect)rect x:(CGFloat)x y:(CGFloat)y;

+(CGRect)CGRectSetWidth:(CGRect)rect width:(CGFloat)width;

+(CGRect)CGRectSetHeight:(CGRect)rect height:(CGFloat)height;

+(CGRect)CGRectSetSize:(CGRect)rect size:(CGSize)size;

+(CGRect)CGRectToFixed:(CGRect)rect precision:(NSUInteger)precision;

+(CGRect)CGRectRemoveFloatMin:(CGRect)rect;

/// outerRange 是否包含了 innerRange
+(BOOL)NSContainingRanges:(NSRange)outerRange innerRange:(NSRange)innerRange;

@end

NS_ASSUME_NONNULL_END
