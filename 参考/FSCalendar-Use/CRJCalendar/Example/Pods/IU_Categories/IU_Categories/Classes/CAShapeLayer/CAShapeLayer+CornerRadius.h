
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (CornerRadius)

+ (CAShapeLayer *)shapeLayerWithFrame:(CGRect)frame corners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
