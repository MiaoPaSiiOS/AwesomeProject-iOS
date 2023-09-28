//
//  DSComputer.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import "DSComputer.h"
@implementation DSComputer
#pragma mark - CGFloat

/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 *  issue: https://github.com/Tencent/QMUI_iOS/issues/203
 */
+(CGFloat)removeFloatMin:(CGFloat)floatValue {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
+(CGFloat)flatSpecificScale:(CGFloat)floatValue  scale:(CGFloat)scale {
    floatValue = [self removeFloatMin:floatValue];
    scale = scale ?: [UIScreen mainScreen].scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
 *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
 */
+(CGFloat)flat:(CGFloat)floatValue {
    return [self flatSpecificScale:floatValue scale:0];
}

/**
 *  类似flat()，只不过 flat 是向上取整，而 floorInPixel 是向下取整
 */
+(CGFloat)floorInPixel:(CGFloat)floatValue {
    floatValue = [self removeFloatMin:floatValue];
    CGFloat resultValue = floor(floatValue * [UIScreen mainScreen].scale) / [UIScreen mainScreen].scale;
    return resultValue;
}

+(BOOL)between:(CGFloat)minimumValue value:(CGFloat)value maximumValue:(CGFloat)maximumValue {
    return minimumValue < value && value < maximumValue;
}

+(BOOL)betweenOrEqual:(CGFloat)minimumValue value:(CGFloat)value maximumValue:(CGFloat)maximumValue {
    return minimumValue <= value && value <= maximumValue;
}

/**
 *  调整给定的某个 CGFloat 值的小数点精度，超过精度的部分按四舍五入处理。
 *
 *  例如 CGFloatToFixed(0.3333, 2) 会返回 0.33，而 CGFloatToFixed(0.6666, 2) 会返回 0.67
 *
 *  @warning 参数类型为 CGFloat，也即意味着不管传进来的是 float 还是 double 最终都会被强制转换成 CGFloat 再做计算
 *  @warning 该方法无法解决浮点数精度运算的问题，如需做浮点数的 == 判断，可用下方的 CGFloatEqualToFloat()
 */
+(CGFloat)CGFloatToFixed:(CGFloat)value precision:(NSUInteger)precision {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
    #if CGFLOAT_IS_DOUBLE
    CGFloat result = [toString doubleValue];
    #else
    CGFloat result = [toString floatValue];
    #endif
    return result;
}

/**
 将给定的两个 CGFloat 进行等值比较，并通过参数 precision 指定要考虑的小数点后的精度，内部会将浮点数转成整型，从而避免浮点数精度导致的 == 判断错误。
 例如 CGFloatEqualToFloatWithPrecision(1.000, 0.999, 0) 会返回 YES，但 1.000 == 0.999 会得到 NO。
 */
+(BOOL)CGFloatEqualToFloatWithPrecision:(CGFloat)value1 value2:(CGFloat)value2 precision:(NSUInteger)precision {
    NSInteger a = ((NSInteger)round(value1) * pow(10, precision));
    NSInteger b = ((NSInteger)round(value2) * pow(10, precision));
    return a == b;
}

/**
 将给定的两个 CGFloat 进行等值比较，不考虑小数点后的数值。
 例如 CGFloatEqualToFloat(1.000, 0.999) 会返回 YES，但 1.000 == 0.999 会得到 NO。
 */
+(BOOL)CGFloatEqualToFloat:(CGFloat)value1 value2:(CGFloat)value2 {
    return [self CGFloatEqualToFloatWithPrecision:value1 value2:value2 precision:0];
}

/// 用于居中运算
+(CGFloat)CGFloatGetCenter:(CGFloat)parent child:(CGFloat)child {
    return [self flat:((parent - child) / 2.0)];
}

/// 检测某个数值如果为 NaN 则将其转换为 0，避免布局中出现 crash
+(CGFloat)CGFloatSafeValue:(CGFloat)value {
    return isnan(value) ? 0 : value;
}

#pragma mark - CGPoint

/// 两个point相加
+(CGPoint)CGPointUnion:(CGPoint)point1 point2:(CGPoint)point2 {
    return CGPointMake([self flat:(point1.x + point2.x)], [self flat:(point1.y + point2.y)]);
}

/// 获取rect的center，包括rect本身的x/y偏移
+(CGPoint)CGPointGetCenterWithRect:(CGRect)rect {
    return CGPointMake([self flat:(CGRectGetMidX(rect))], [self flat:(CGRectGetMidY(rect))]);
}

+(CGPoint)CGPointGetCenterWithSize:(CGSize)size {
    return CGPointMake([self flat:(size.width / 2.0)], [self flat:(size.height / 2.0)]);
}

+(CGPoint)CGPointToFixed:(CGPoint)point precision:(NSUInteger)precision {
    CGPoint result = CGPointMake([self CGFloatToFixed:point.x precision:precision], [self CGFloatToFixed:point.y precision:precision]);
    return result;
}

+(CGPoint)CGPointRemoveFloatMin:(CGPoint)point {
    CGPoint result = CGPointMake([self removeFloatMin:(point.x)], [self removeFloatMin:(point.y)]);
    return result;
}

#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
+(CGFloat)UIEdgeInsetsGetHorizontalValue:(UIEdgeInsets)insets {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
+(CGFloat)UIEdgeInsetsGetVerticalValue:(UIEdgeInsets)insets {
    return insets.top + insets.bottom;
}

/// 将两个UIEdgeInsets合并为一个
+(UIEdgeInsets)UIEdgeInsetsConcat:(UIEdgeInsets)insets1 insets2:(UIEdgeInsets)insets2 {
    insets1.top += insets2.top;
    insets1.left += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right += insets2.right;
    return insets1;
}

+(UIEdgeInsets)UIEdgeInsetsSetTop:(UIEdgeInsets)insets top:(CGFloat)top {
    insets.top = [self flat:(top)];
    return insets;
}

+(UIEdgeInsets)UIEdgeInsetsSetLeft:(UIEdgeInsets)insets left:(CGFloat)left {
    insets.left = [self flat:(left)];
    return insets;
}

+(UIEdgeInsets)UIEdgeInsetsSetBottom:(UIEdgeInsets)insets bottom:(CGFloat)bottom {
    insets.bottom = [self flat:(bottom)];
    return insets;
}

+(UIEdgeInsets)UIEdgeInsetsSetRight:(UIEdgeInsets)insets right:(CGFloat)right {
    insets.right = [self flat:(right)];
    return insets;
}

+(UIEdgeInsets)UIEdgeInsetsToFixed:(UIEdgeInsets)insets precision:(NSUInteger)precision {
    UIEdgeInsets result = UIEdgeInsetsMake([self CGFloatToFixed:insets.top precision:precision], [self CGFloatToFixed:insets.left precision:precision], [self CGFloatToFixed:insets.bottom precision:precision], [self CGFloatToFixed:insets.right precision:precision]);
    return result;
}

+(UIEdgeInsets)UIEdgeInsetsRemoveFloatMin:(UIEdgeInsets)insets {
    UIEdgeInsets result = UIEdgeInsetsMake([self removeFloatMin:(insets.top)], [self removeFloatMin:(insets.left)], [self removeFloatMin:(insets.bottom)], [self removeFloatMin:(insets.right)]);
    return result;
}

#pragma mark - CGSize

/// 判断一个 CGSize 是否存在 NaN
+(BOOL)CGSizeIsNaN:(CGSize)size {
    return isnan(size.width) || isnan(size.height);
}

/// 判断一个 CGSize 是否存在 infinite
+(BOOL)CGSizeIsInf:(CGSize)size {
    return isinf(size.width) || isinf(size.height);
}

/// 判断一个 CGSize 是否为空（宽或高为0）
+(BOOL)CGSizeIsEmpty:(CGSize)size {
    return size.width <= 0 || size.height <= 0;
}

/// 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
+(BOOL)CGSizeIsValidated:(CGSize)size {
    return ![self CGSizeIsEmpty:(size)] && ![self CGSizeIsInf:(size)] && ![self CGSizeIsNaN:(size)];
}

/// 将一个 CGSize 像素对齐
+(CGSize)CGSizeFlatted:(CGSize)size {
    return CGSizeMake([self flat:(size.width)], [self flat:(size.height)]);
}

/// 将一个 CGSize 以 pt 为单位向上取整
+(CGSize)CGSizeCeil:(CGSize)size {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

/// 将一个 CGSize 以 pt 为单位向下取整
+(CGSize)CGSizeFloor:(CGSize)size {
    return CGSizeMake(floor(size.width), floor(size.height));
}

+(CGSize)CGSizeToFixed:(CGSize)size precision:(NSUInteger)precision {
    CGSize result = CGSizeMake([self CGFloatToFixed:size.width precision:precision], [self CGFloatToFixed:size.height precision:precision]);
    return result;
}

+(CGSize)CGSizeRemoveFloatMin:(CGSize)size {
    CGSize result = CGSizeMake([self removeFloatMin:(size.width)], [self removeFloatMin:(size.height)]);
    return result;
}

+(CGSize)CGSizePixelRound:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

+(CGFloat)CGFloatPixelRound:(CGFloat)value {
    CGFloat scale = [UIScreen mainScreen].scale;
    return round(value * scale) / scale;
}

/// floor point value for pixel-aligned
+(CGFloat)CGFloatPixelFloor:(CGFloat)value {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

/// floor UIEdgeInset for pixel-aligned
+(UIEdgeInsets)UIEdgeInsetPixelFloor:(UIEdgeInsets)insets {
    insets.top = [self CGFloatPixelFloor:(insets.top)];
    insets.left = [self CGFloatPixelFloor:(insets.left)];
    insets.bottom = [self CGFloatPixelFloor:(insets.bottom)];
    insets.right = [self CGFloatPixelFloor:(insets.right)];
    return insets;
}
#pragma mark - CGRect
/// 判断一个 CGRect 是否存在 NaN
+(BOOL)CGRectIsNaN:(CGRect)rect {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

/// 系统提供的 CGRectIsInfinite 接口只能判断 CGRectInfinite 的情况，而该接口可以用于判断 INFINITY 的值
+(BOOL)CGRectIsInf:(CGRect)rect {
    return isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height);
}

/// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
+(BOOL)CGRectIsValidated:(CGRect)rect  {
    return !CGRectIsNull(rect) && !CGRectIsInfinite(rect) && ![self CGRectIsNaN:(rect)] && ![self CGRectIsInf:(rect)];
}

/// 检测某个 CGRect 如果存在数值为 NaN 的则将其转换为 0，避免布局中出现 crash
+(CGRect)CGRectSafeValue:(CGRect)rect  {
    return CGRectMake([self CGFloatSafeValue:(CGRectGetMinX(rect))], [self CGFloatSafeValue:(CGRectGetMinY(rect))], [self CGFloatSafeValue:(CGRectGetWidth(rect))], [self CGFloatSafeValue:(CGRectGetHeight(rect))]);
}

/// 创建一个像素对齐的CGRect
+(CGRect)CGRectFlatMake:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    return CGRectMake([self flat:(x)], [self flat:(y)], [self flat:(width)], [self flat:(height)]);
}

/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
+(CGRect)CGRectFlatted:(CGRect)rect {
    return CGRectMake([self flat:(rect.origin.x)], [self flat:(rect.origin.y)], [self flat:(rect.size.width)], [self flat:(rect.size.height)]);
}

/// 计算目标点 targetPoint 围绕坐标点 coordinatePoint 通过 transform 之后此点的坐标
+(CGPoint)CGPointApplyAffineTransformWithCoordinatePoint:(CGPoint)coordinatePoint targetPoint:(CGPoint)targetPoint t:(CGAffineTransform)t {
    CGPoint p;
    p.x = (targetPoint.x - coordinatePoint.x) * t.a + (targetPoint.y - coordinatePoint.y) * t.c + coordinatePoint.x;
    p.y = (targetPoint.x - coordinatePoint.x) * t.b + (targetPoint.y - coordinatePoint.y) * t.d + coordinatePoint.y;
    p.x += t.tx;
    p.y += t.ty;
    return p;
}

/// 系统的 CGRectApplyAffineTransform 只会按照 anchorPoint 为 (0, 0) 的方式去计算，但通常情况下我们面对的是 UIView/CALayer，它们默认的 anchorPoint 为 (.5, .5)，所以增加这个函数，在计算 transform 时可以考虑上 anchorPoint 的影响
+(CGRect)CGRectApplyAffineTransformWithAnchorPoint:(CGRect)rect t:(CGAffineTransform)t anchorPoint:(CGPoint)anchorPoint {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint oPoint = CGPointMake(rect.origin.x + width * anchorPoint.x, rect.origin.y + height * anchorPoint.y);
    
    CGPoint top_left = [self CGPointApplyAffineTransformWithCoordinatePoint:oPoint targetPoint:CGPointMake(rect.origin.x, rect.origin.y) t:t];
    CGPoint bottom_left = [self CGPointApplyAffineTransformWithCoordinatePoint:oPoint targetPoint:CGPointMake(rect.origin.x, rect.origin.y+height) t:t];
    CGPoint top_right = [self CGPointApplyAffineTransformWithCoordinatePoint:oPoint targetPoint:CGPointMake(rect.origin.x+width, rect.origin.y) t:t];
    CGPoint bottom_right = [self CGPointApplyAffineTransformWithCoordinatePoint:oPoint targetPoint:CGPointMake(rect.origin.x+width, rect.origin.y+height) t:t];;
    CGFloat minX = MIN(MIN(MIN(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat maxX = MAX(MAX(MAX(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat minY = MIN(MIN(MIN(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat maxY = MAX(MAX(MAX(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat newWidth = maxX - minX;
    CGFloat newHeight = maxY - minY;
    CGRect result = CGRectMake(minX, minY, newWidth, newHeight);
    return result;
}

/// 为一个CGRect叠加scale计算
+(CGRect)CGRectApplyScale:(CGRect)rect scale:(CGFloat)scale {
    return [self CGRectFlatted:(CGRectMake(CGRectGetMinX(rect) * scale, CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale))];
}

/// 计算view的水平居中，传入父view和子view的frame，返回子view在水平居中时的x值
+(CGFloat)CGRectGetMinXHorizontallyCenterInParentRect:(CGRect)parentRect childRect:(CGRect)childRect {
    return [self flat:((CGRectGetWidth(parentRect) - CGRectGetWidth(childRect)) / 2.0)];
}

/// 计算view的垂直居中，传入父view和子view的frame，返回子view在垂直居中时的y值
+(CGFloat)CGRectGetMinYVerticallyCenterInParentRect:(CGRect)parentRect childRect:(CGRect)childRect {
    return [self flat:((CGRectGetHeight(parentRect) - CGRectGetHeight(childRect)) / 2.0)];
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持垂直居中时，layoutingRect的originY
+(CGFloat)CGRectGetMinYVerticallyCenter:(CGRect)referenceRect layoutingRect:(CGRect)layoutingRect {
    return CGRectGetMinY(referenceRect) + [self CGRectGetMinYVerticallyCenterInParentRect:referenceRect childRect:layoutingRect];
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持水平居中时，layoutingRect的originX
+(CGFloat)CGRectGetMinXHorizontallyCenter:(CGRect)referenceRect layoutingRect:(CGRect)layoutingRect {
    return CGRectGetMinX(referenceRect) + [self CGRectGetMinXHorizontallyCenterInParentRect:referenceRect childRect:layoutingRect];
}

/// 为给定的rect往内部缩小insets的大小（系统那个方法的命名太难联想了，所以定义了一个新函数）
+(CGRect)CGRectInsetEdges:(CGRect)rect insets:(UIEdgeInsets)insets {
    return UIEdgeInsetsInsetRect(rect, insets);
}

/// 传入size，返回一个x/y为0的CGRect
+(CGRect)CGRectMakeWithSize:(CGSize)size {
    return CGRectMake(0, 0, size.width, size.height);
}

+(CGRect)CGRectFloatTop:(CGRect)rect top:(CGFloat)top {
    rect.origin.y = top;
    return rect;
}

+(CGRect)CGRectFloatBottom:(CGRect)rect bottom:(CGFloat)bottom {
    rect.origin.y = bottom - CGRectGetHeight(rect);
    return rect;
}

+(CGRect)CGRectFloatRight:(CGRect)rect right:(CGFloat)right {
    rect.origin.x = right - CGRectGetWidth(rect);
    return rect;
}

+(CGRect)CGRectFloatLeft:(CGRect)rect left:(CGFloat)left {
    rect.origin.x = left;
    return rect;
}

/// 保持rect的左边缘不变，改变其宽度，使右边缘靠在right上
+(CGRect)CGRectLimitRight:(CGRect)rect rightLimit:(CGFloat)rightLimit {
    rect.size.width = rightLimit - rect.origin.x;
    return rect;
}

/// 保持rect右边缘不变，改变其宽度和origin.x，使其左边缘靠在left上。只适合那种右边缘不动的view
/// 先改变origin.x，让其靠在offset上
/// 再改变size.width，减少同样的宽度，以抵消改变origin.x带来的view移动，从而保证view的右边缘是不动的
+(CGRect)CGRectLimitLeft:(CGRect)rect leftLimit:(CGFloat)leftLimit {
    CGFloat subOffset = leftLimit - rect.origin.x;
    rect.origin.x = leftLimit;
    rect.size.width = rect.size.width - subOffset;
    return rect;
}

/// 限制rect的宽度，超过最大宽度则截断，否则保持rect的宽度不变
+(CGRect)CGRectLimitMaxWidth:(CGRect)rect maxWidth:(CGFloat)maxWidth {
    CGFloat width = CGRectGetWidth(rect);
    rect.size.width = width > maxWidth ? maxWidth : width;
    return rect;
}

+(CGRect)CGRectSetX:(CGRect)rect x:(CGFloat)x {
    rect.origin.x = [self flat:(x)];
    return rect;
}

+(CGRect)CGRectSetY:(CGRect)rect y:(CGFloat)y {
    rect.origin.y = [self flat:(y)];
    return rect;
}

+(CGRect)CGRectSetXY:(CGRect)rect x:(CGFloat)x y:(CGFloat)y {
    rect.origin.x = [self flat:(x)];
    rect.origin.y = [self flat:(y)];
    return rect;
}

+(CGRect)CGRectSetWidth:(CGRect)rect width:(CGFloat)width {
    if (width < 0) {
        return rect;
    }
    rect.size.width = [self flat:(width)];
    return rect;
}

+(CGRect)CGRectSetHeight:(CGRect)rect height:(CGFloat)height {
    if (height < 0) {
        return rect;
    }
    rect.size.height = [self flat:(height)];
    return rect;
}

+(CGRect)CGRectSetSize:(CGRect)rect size:(CGSize)size {
    rect.size = [self CGSizeFlatted:(size)];
    return rect;
}

+(CGRect)CGRectToFixed:(CGRect)rect precision:(NSUInteger)precision {
    CGRect result = CGRectMake([self CGFloatToFixed:CGRectGetMinX(rect) precision:precision],
                                [self CGFloatToFixed:CGRectGetMinY(rect) precision:precision],
                                 [self CGFloatToFixed:CGRectGetWidth(rect) precision:precision],
                                  [self CGFloatToFixed:CGRectGetHeight(rect) precision:precision]);
    return result;
}

+(CGRect)CGRectRemoveFloatMin:(CGRect)rect {
    CGRect result = CGRectMake([self removeFloatMin:(CGRectGetMinX(rect))],
                                [self removeFloatMin:(CGRectGetMinY(rect))],
                                [self removeFloatMin:(CGRectGetWidth(rect))],
                                [self removeFloatMin:(CGRectGetHeight(rect))]);
    return result;
}

/// outerRange 是否包含了 innerRange
+(BOOL)NSContainingRanges:(NSRange)outerRange innerRange:(NSRange)innerRange {
    if (innerRange.location >= outerRange.location && outerRange.location + outerRange.length >= innerRange.location + innerRange.length) {
        return YES;
    }
    return NO;
}

@end
