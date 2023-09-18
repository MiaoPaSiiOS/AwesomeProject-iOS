//
//  NrCGContext.h
//  NrCGContext_Example
//
//  Created by zhuyuhui on 2020/9/4.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NrCGContextConfig.h"
#import "NrGradientColor.h"
@class NrCGContext;


typedef void(^NrCGContextDrawBlock_t)(NrCGContext *contextObject);

@interface NrCGContext : NSObject

/**
 *  操作句柄
 */
@property (nonatomic, readonly) CGContextRef context;

/**
 *  Current context config.
 */
@property (nonatomic, strong, readonly) NrCGContextConfig *currentConfig;

/**
 *  Context config array.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NrCGContextConfig *> *configs;

/**
 *  Init method.
 *
 *  @param context An opaque type that represents a Quartz 2D drawing environment.
 *  @param config  Context config
 *
 *  @return Context config object
 */
- (instancetype)initWithCGContext:(CGContextRef)context config:(NrCGContextConfig *)config;

/**
 *  Use the context config & store as current config.
 *
 *  @param contextConfig   Context config object.
 *  @param asCurrentConfig Yes means store, No means not store.
 */
- (void)useCGContextConfig:(NrCGContextConfig *)contextConfig
      storeAsCurrentConfig:(BOOL)asCurrentConfig;

#pragma mark - 绘制操作流程
/**
 *  开始path
 */
- (void)beginPath;

/**
 *  关闭path
 */
- (void)closePath;

/**
 *  线条绘制
 */
- (void)strokePath;

/**
 *  填充绘制
 */
- (void)fillPath;

/**
 *  Draws the current path using the provided drawing mode.
 *
 *  @param drawingMode A path drawing mode constant—kCGPathFill, kCGPathEOFill, kCGPathStroke, kCGPathFillStroke, or kCGPathEOFillStroke. For a discussion of these constants, see CGPath Reference.
 */
- (void)drawPathWithDrawingMode:(CGPathDrawingMode)drawingMode;

#pragma mark - Path construction convenience functions.

/**
 *  Adds a rectangular path to the current path.
 *
 *  @param rect A rectangle, specified in user space coordinates.
 */
- (void)addRectPath:(CGRect)rect;

/**
 *  Adds an ellipse that fits inside the specified rectangle.
 *
 *  @param rect A rectangle that defines the area for the ellipse to fit in.
 */
- (void)addEllipseInRectPath:(CGRect)rect;

/**
 *  Adds an arc of a circle to the current path, possibly preceded by a straight line segment.
 *
 *  @param point      the center of the arc
 *  @param radius     The radius of the arc, in user space coordinates.
 *  @param startAngle The angle to the starting point of the arc, measured in radians from the positive x-axis.
 *  @param endAngle   The angle to the end point of the arc, measured in radians from the positive x-axis.
 *  @param clockwise  Specify YES to create a clockwise arc or NO to create a counterclockwise arc.
 */
- (void)addArcWithCenterPoint:(CGPoint)point radius:(CGFloat)radius
                   startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
                    clockwise:(BOOL)clockwise;

#pragma mark - Draw construction method.

/**
 *  绘制线条用block (beginPath + closePath + 你绘制的代码 + strokePath)
 *
 *  @param config context config
 *  @param block  draw block
 */
- (void)contextConfig:(NrCGContextConfig *)config drawStrokeBlock:(NrCGContextDrawBlock_t)block;

/**
 *  填充区域用block (beginPath + closePath + 你绘制的代码 + fillPath)
 *
 *  @param config context config
 *  @param block  draw block
 */
- (void)contextConfig:(NrCGContextConfig *)config drawFillBlock:(NrCGContextDrawBlock_t)block;

/**
 *  beginPath + your draw code + drawPathWithDrawingMode
 *
 *  @param config      context config
 *  @param drawingMode A path drawing mode constant—kCGPathFill, kCGPathEOFill, kCGPathStroke, kCGPathFillStroke, or kCGPathEOFillStroke. For a discussion of these constants, see CGPath Reference.
 *  @param block       draw block
 */
- (void)contextConfig:(NrCGContextConfig *)config drawingMode:(CGPathDrawingMode)drawingMode drawBlock:(NrCGContextDrawBlock_t)block;

#pragma mark - 图形绘制API
/**
 *  移动到起始点
 *
 *  @param point start point
 */
- (void)moveToStartPoint:(CGPoint)point;

/**
 *  添加一个点(与上一个点直线相连)
 *
 *  @param point end point
 */
- (void)addLineToPoint:(CGPoint)point;

/**
 *  Start point and points, it's a combine by moveToStartPoint: & addLineToPoint:
 *
 *  @param points array with point's value.
 */
- (void)addLinePoints:(NSArray <NSValue *> *)points;

/**
 *  添加二次贝塞尔曲线
 *
 *  @param point              end point
 *  @param firstControlPoint  first control point
 *  @param secondControlPoint second control point
 */
- (void)addCurveToPoint:(CGPoint)point firstControlPoint:(CGPoint)firstControlPoint secondControlPoint:(CGPoint)secondControlPoint;

/**
 *  添加一次贝塞尔曲线
 *
 *  @param point        end point
 *  @param controlPoint control point
 */
- (void)addQuadCurveToPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint;

#pragma mark - 绘制图片API
/**
 *  Draws the image at the specified point in the current context.
 *
 *  @param image the image
 *  @param point The point at which to draw the top-left corner of the image.
 */
- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point;

/**
 *  Draws the entire image at the specified point using the custom compositing options.
 *
 *  @param image     The image
 *  @param point     The point at which to draw the top-left corner of the image.
 *  @param blendMode The blend mode to use when compositing the image.
 *  @param alpha     The desired opacity of the image, specified as a value between 0.0 and 1.0. A value of 0.0 renders the image totally transparent while 1.0 renders it fully opaque. Values larger than 1.0 are interpreted as 1.0.
 */
- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

/**
 *  Draws the entire image in the specified rectangle, scaling it as needed to fit.
 *
 *  @param image The image
 *  @param rect  The rectangle (in the coordinate system of the graphics context) in which to draw the image.
 */
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect;

/**
 *  Draws the entire image in the specified rectangle and using the specified compositing options.
 *
 *  @param image     The image
 *  @param rect      The rectangle (in the coordinate system of the graphics context) in which to draw the image.
 *  @param blendMode The blend mode to use when compositing the image.
 *  @param alpha     The desired opacity of the image, specified as a value between 0.0 and 1.0. A value of 0.0 renders the image totally transparent while 1.0 renders it fully opaque. Values larger than 1.0 are interpreted as 1.0.
 */
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

/**
 *  Draws a tiled Quartz pattern using the receiver’s contents as the tile pattern.
 *
 *  @param image The image
 *  @param rect  The rectangle (in the coordinate system of the graphics context) in which to draw the image.
 */
- (void)drawImage:(UIImage *)image asPatternInRect:(CGRect)rect;

#pragma mark - 保存操作
/**
 *  将当前设置存取到栈区中(入栈操作)
 */
- (void)saveGState;

/**
 *  从栈区中取出之前保存的设置(出栈操作)
 */
- (void)restoreGState;

/**
 *  saveGState + restoreGState
 *
 *  @param block draw block
 */
- (void)drawInCurrentSpecialState:(NrCGContextDrawBlock_t)block;

#pragma mark - String related.

/**
 *  将string绘制在指定的点上
 *
 *  @param string     字符串
 *  @param point      点.
 *  @param attributes 富文本设置（可以为空）
 */
- (void)drawString:(NSString *)string atPoint:(CGPoint)point withAttributes:(NSDictionary *)attributes;

/**
 *  将string绘制在制定的区域
 *
 *  @param string     The string
 *  @param rect       The bounding rectangle in which to draw the string.
 *  @param attributes A dictionary of text attributes to be applied to the string. These are the same attributes that can be applied to an NSAttributedString object, but in the case of NSString objects, the attributes apply to the entire string, rather than ranges within the string.
 */
- (void)drawString:(NSString *)string inRect:(CGRect)rect withAttributes:(NSDictionary *)attributes;

/**
 *  将富文本绘制在制定的点上
 *
 *  @param string The attributedString
 *  @param point  The point in the current graphics context where you want to start drawing the string. The coordinate system of the graphics context is usually defined by the view in which you are drawing.
 */
- (void)drawAttributedString:(NSAttributedString *)string atPoint:(CGPoint)point;

/**
 *  将富文本绘制在制定的矩形中
 *
 *  @param string The attributedString
 *  @param rect   The bounding rectangle in which to draw the string.
 */
- (void)drawAttributedString:(NSAttributedString *)string inRect:(CGRect)rect;

#pragma mark - 绘制渐变色.

/**
 *  在指定的区域填充彩色的矩形（此为直接绘制）
 *
 *  @param rect          指定的区域
 *  @param gradientColor 渐变颜色数组
 *  @param startPoint     渐变起点的坐标
 *  @param endPoint       渐变终点的坐标
 */
- (void)drawLinearGradientAtClipToRect:(CGRect)rect
                         gradientColor:(NrGradientColor *)gradientColor
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint;

@end




/*
 #import "CRJDrawGradientColorView.h"

 #import <LDZFCGContextObject/LDZFCGContextObject.h>

 @interface CRJDrawGradientColorView ()

 @property (nonatomic, strong)  LdzfCGContext  *contextObject;

 @end

 @implementation CRJDrawGradientColorView

 - (instancetype)initWithFrame:(CGRect)frame {
     
     if (self = [super initWithFrame:frame]) {
         
         self.backgroundColor = [UIColor clearColor];
     }
     
     return self;
 }

 - (void)drawRect:(CGRect)rect {
     CGFloat height = self.frame.size.height;
     //获取操作句柄
     _contextObject = [[LdzfCGContext alloc] initWithCGContext:UIGraphicsGetCurrentContext()
                                                          config:[LdzfCGContextConfig new]];
     
     //开始绘图
     for (int count = 0; count < 7; count++) {
         CGFloat lineHeight = arc4random() % (int)(height - 20);
         //绘制矩形
         [_contextObject contextConfig:nil drawFillBlock:^(LdzfCGContext *contextObject) {
             contextObject.currentConfig.fillColor = [LdzfRGBColor randomColor];
             [contextObject addRectPath:CGRectMake(count * 30, height - lineHeight, 15, lineHeight)];
         }];
         //绘制文字
         [_contextObject drawString:[NSString stringWithFormat:@"%.f",lineHeight / 10.f]
                            atPoint:CGPointMake(2 + count * 30, height - lineHeight - 20) withAttributes:nil];
     }
     
     
     
     
     
     
 //    {
 //        size_t  count             = 3;
 //        CGFloat locations[]       = {0.0, 0.5, 1.0};
 //        CGFloat colorComponents[] = {
 //            //red, green, blue, alpha
 //            0.254, 0.599, 0.82,  1.0,
 //            0.192, 0.525, 0.75,  1.0,
 //            0.096, 0.415, 0.686, 1.0};
 //
 //        LdzfGradientColor *gradientColor = [LdzfGradientColor gradientColorWithLocations:locations
 //                                                                      components:colorComponents
 //                                                                           count:count];
 //
 //        [_contextObject drawLinearGradientAtClipToRect:CGRectMake(0, 0, 10, self.frame.size.height)
 //                                         gradientColor:gradientColor
 //                                            startPoint:CGPointMake(0, 0)
 //                                              endPoint:CGPointMake(0, self.frame.size.height)];
 //    }
 //
 //    {
 //        size_t  count             = 4;
 //        CGFloat locations[]       = {0.0, 0.3, 0.7, 1.0};
 //        CGFloat colorComponents[] = {
 //            //red, green, blue, alpha
 //            [self randomValue], [self randomValue], [self randomValue], 1.0,
 //            [self randomValue], [self randomValue], [self randomValue], 1.0,
 //            [self randomValue], [self randomValue], [self randomValue], 1.0,
 //            [self randomValue], [self randomValue], [self randomValue], 1.0};
 //
 //        LdzfGradientColor *gradientColor = [LdzfGradientColor gradientColorWithLocations:locations
 //                                                                      components:colorComponents
 //                                                                           count:count];
 //
 //        [_contextObject drawLinearGradientAtClipToRect:CGRectMake(20, 0, 10, self.frame.size.height)
 //                                         gradientColor:gradientColor
 //                                            startPoint:CGPointMake(0, 0)
 //                                              endPoint:CGPointMake(0, self.frame.size.height)];
 //    }
 }

 - (CGFloat)randomValue {

     CGFloat value = arc4random() % 101 / 100.f;
     return value;
 }

 @end


 */


