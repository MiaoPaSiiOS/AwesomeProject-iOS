//
//  DSGrayUtil.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "DSGrayUtil.h"

@implementation DSGrayUtil
#pragma mark - 获取CGColor的灰度颜色
+ (UIColor *)grayColorForCGColor:(CGColorRef)colorRef {
    
    const CGFloat *components = CGColorGetComponents(colorRef);

    if (!components) {
        return [UIColor colorWithCGColor:colorRef];
    }

    __SIZE_TYPE__ numCount = CGColorGetNumberOfComponents(colorRef);

    //颜色是否属于灰阶
    if (numCount == 2) {
        return [UIColor colorWithCGColor:colorRef];
    }

    return [self getUIColorForComponents:components withNum:numCount];
}

#pragma mark - 获取UIColor的灰度颜色
+ (UIColor *)grayColorForUIColor:(UIColor *)color {
    
    CGColorRef colorRef = [color CGColor];
    const CGFloat *components = CGColorGetComponents(colorRef);

    if (!components) {
        return color;
    }

    __SIZE_TYPE__ numCount = CGColorGetNumberOfComponents(colorRef);

    //颜色是否属于灰阶
    if (numCount == 2) {
        return color;
    }

    return [self getUIColorForComponents:components withNum:numCount];
}

#pragma mark - 获取UIColor的灰度颜色
+ (UIColor *)grayColorFroRed:(CGFloat)r
                       green:(CGFloat)g
                        blue:(CGFloat)b
                       alpha:(CGFloat)a {
    //灰度计算
    CGFloat gray = r * 0.299 + g * 0.587 + b * 0.114;
    
    return [UIColor colorWithWhite:gray alpha:a];
}

#pragma mark - 灰度处理
+ (UIColor *)getUIColorForComponents:(const CGFloat *)components
                             withNum:(__SIZE_TYPE__)numCount {
    
    const int RED = 0;
    const int GREEN = 1;
    const int BLUE = 2;
    const int ALPHA = 3;

    uint32_t red = components[RED];
    uint32_t green = components[GREEN];
    uint32_t blue = components[BLUE];
    
    //灰度计算
    uint32_t gray = (red * 38 + green * 75 + blue * 15) >> 7;

    return [UIColor colorWithWhite:gray alpha:numCount > 3 ? components[ALPHA] : 1];
}

#pragma mark - 获取UIImage的灰度图片
+ (UIImage *)grayImageForUIImage:(UIImage *)image {
    
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;

    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale);

    int width = imageRect.size.width;
    int height = imageRect.size.height;

    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));

    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);

    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y * width + x];
            //灰度计算
            uint32_t gray = (rgbaPixel[RED] * 38 + rgbaPixel[GREEN] * 75 + rgbaPixel[BLUE] * 15) >> 7;

            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);

    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];

    // we're done with image now too
    CGImageRelease(imageRef);

    return resultUIImage;
}

/// 方法替换
/// @param oriSel 被替换的SEL
/// @param oriMethod 被替换的Mehod
/// @param swizzledSel 替换的SEL
/// @param swizzledMethod 替换的Method
/// @param cls 被替换的Class

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                          oriClass:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}
@end
