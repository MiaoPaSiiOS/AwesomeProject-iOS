
#import "UIView+ConvenientMethod.h"

@implementation UIView (ConvenientMethod)

+ (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color {
    
    UIView *line         = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    return line;
}

+ (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color tag:(NSInteger)tag {

    UIView *line         = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    line.tag             = tag;
    
    return line;
}

@end
