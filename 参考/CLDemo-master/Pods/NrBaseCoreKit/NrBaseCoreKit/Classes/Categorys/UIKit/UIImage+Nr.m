

#import "UIImage+Nr.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Nr)

- (BOOL)nr_hasAlphaChannel
{
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *)nr_base64String
{
    NSData *data = UIImagePNGRepresentation(self);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return encodedImageStr;
}

- (UIImage *)nr_updateImageOrientation
{
    if (self != nil) {
        // 如果方向已经正确，则不进行操作
        if (self.imageOrientation == UIImageOrientationUp){
            return self;
        } else {
            // 我们需要计算出正确的变换，使图像直立。
            CGAffineTransform transform = CGAffineTransformIdentity;
            UIImageOrientation orientation=self.imageOrientation;
            switch (orientation) {
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                    transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                    transform = CGAffineTransformRotate(transform, M_PI);
                    break;
                    
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                    break;
                    
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                    break;
                default:
                    break;
            }
            
            switch (orientation) {
                case UIImageOrientationDownMirrored:
                    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                    break;
                    
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:
                    transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                    transform = CGAffineTransformScale(transform, -1, 1);
                    break;
                default:
                    break;
            }
            
            // 现在我们将底层的CGImage绘制到一个新的上下文中，应用变换
            CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                     CGImageGetBitsPerComponent(self.CGImage), 0,
                                                     CGImageGetColorSpace(self.CGImage),
                                                     CGImageGetBitmapInfo(self.CGImage));
            CGContextConcatCTM(ctx, transform);
            switch (self.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    // Grr...
                    CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
                    break;
                    
                default:
                    CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
                    break;
            }
            // 从绘图环境中创建一个新的UIImage
            CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
            UIImage *img = [UIImage imageWithCGImage:cgimg];
            CGContextRelease(ctx);
            CGImageRelease(cgimg);
            return img;
        }
    }
    return nil;
}
- (UIImage *)nr_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize
{
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}
/**
 拼接长图
 */
+ (void)nr_generateLongPictureWithHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage masterImages:(NSArray <UIImage *>*)masterImgArr edgeMargin:(UIEdgeInsets)edgeMargin imageSpace:(CGFloat)imageSpace success:(void(^)(UIImage *longImage,CGFloat totalHeight))success
{
    NSAssert(masterImgArr.count != 0, @"主视图不能为空");
    // 总高度
    CGFloat totalH = edgeMargin.top;
    CGFloat headH = 0;
    CGFloat footH = 0;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - edgeMargin.left - edgeMargin.right;
    if (headImage) {
        // 有头图
        CGFloat headScale = headImage.size.height / headImage.size.width;
        headH = headScale * width;
        totalH += headH;
    }
    if (masterImgArr.count != 0) {
        // 主视图
        for (int i = 0; i < masterImgArr.count; i++) {
            UIImage *masterImage = masterImgArr[i];
            CGFloat masterImgScale = masterImage.size.height / masterImage.size.width;
            CGFloat masterImgH = masterImgScale * width;
            
            totalH += masterImgH;
        }
        totalH += masterImgArr.count * imageSpace;
    }
    
    if (footImage) {
        // 底图
        totalH += imageSpace;
        CGFloat footScale = footImage.size.height / footImage.size.width;
        footH = footScale * width;
        totalH += footH;
    }
    totalH += edgeMargin.bottom;
    totalH = floor(totalH);
    
    // 绘制画布
    CGFloat maxY = edgeMargin.top;
    CGSize contextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, totalH);
    UIGraphicsBeginImageContextWithOptions(contextSize, false, [UIScreen mainScreen].scale);
    if (headImage) {
        [headImage drawInRect:CGRectMake(edgeMargin.left, maxY, width, headH)];
        maxY += headH;
    }
    if (masterImgArr.count != 0) {
        // 主视图
        for (int i = 0; i < masterImgArr.count; i++) {
            UIImage *masterImage = masterImgArr[i];
            CGFloat masterImgScale = masterImage.size.height / masterImage.size.width;
            CGFloat masterImgH = masterImgScale * width;
            
            maxY += imageSpace;
            [masterImage drawInRect:CGRectMake(edgeMargin.left, maxY, width, masterImgH)];
            maxY += masterImgH;
        }
    }
    if (footImage) {
        maxY += imageSpace;
        [footImage drawInRect:CGRectMake(edgeMargin.left, maxY, width, footH)];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (success) {
        success(resultImage,totalH);
    }
}
- (NSData *)nr_compressImageDataDichotomyWith:(int)maxSize
{
//    CGFloat maxFileSize = imageDataSize*1024;
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    NSData *compressedData = UIImageJPEGRepresentation(self, compression);
//    while ([compressedData length] > maxFileSize && compression > maxCompression) {
//        compression -= 0.1;
//        compressedData = UIImageJPEGRepresentation(self, compression);
//    }
//    return compressedData;
    
    // 二分法
    CGFloat compression = 1;
    CGFloat maxFileSize = maxSize*1024;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxFileSize) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxFileSize * 0.9) {
            min = compression;
        } else if (data.length > maxFileSize) {
            max = compression;
        } else {
            break;
        }
    }

    return data;
}

- (NSData *)nr_compressImageDataWith:(int)maxSize
{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    CGFloat maxFileSize = maxSize*1024;
    while (data.length > maxFileSize && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = maxFileSize / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        // 使用图像绘制(drawInRect:)，图像较大，但压缩时间更长
        // 使用结果图像绘制，图像更小，但压缩时间更短
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

- (NSData *)nr_compressImageCombineWith:(int)maxSize
{
    CGFloat maxFileSize = maxSize*1024;
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxFileSize) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxFileSize * 0.9) {
            min = compression;
        } else if (data.length > maxFileSize) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxFileSize) return data;
    
    // Compress by size
    UIImage *resultImage = [UIImage imageWithData:data];
    NSUInteger lastDataLength = 0;
    while (data.length > maxFileSize && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = maxFileSize / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

/**
 根据URL获取尺寸
 */
+ (CGSize)nr_getImageSizeWithURL:(id)URL
{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

+ (UIImage *)nr_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [self.class imageWithData:data scale:scale];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = [self p_CGImageSourceGetGIFFrameDelayAtIndex:source index:i];
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [self.class animatedImageWithImages:array duration:totalTime];
    return image;
}

+ (BOOL)nr_isAnimatedGIFData:(NSData *)data
{
    if (data.length < 16) return NO;
    UInt32 magic = *(UInt32 *)data.bytes;
    // http://www.w3.org/Graphics/GIF/spec-gif89a.txt
    if ((magic & 0xFFFFFF) != '\0FIG') return NO;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
    if (!source) return NO;
    size_t count = CGImageSourceGetCount(source);
    CFRelease(source);
    return count > 1;
}

+ (BOOL)nr_isAnimatedGIFFile:(NSString *)path
{
    if (path.length == 0) return NO;
    const char *cpath = path.UTF8String;
    FILE *fd = fopen(cpath, "rb");
    if (!fd) return NO;
    
    BOOL isGIF = NO;
    UInt32 magic = 0;
    if (fread(&magic, sizeof(UInt32), 1, fd) == 1) {
        if ((magic & 0xFFFFFF) == '\0FIG') isGIF = YES;
    }
    fclose(fd);
    return isGIF;
}

+ (UIImage *)nr_imageWithPDF:(id)dataOrPath {
    return [self p_imageWithPDF:dataOrPath resize:NO size:CGSizeZero];
}

+ (UIImage *)nr_imageWithPDF:(id)dataOrPath size:(CGSize)size {
    return [self p_imageWithPDF:dataOrPath resize:YES size:size];
}



#pragma mark - private
+ (NSTimeInterval)p_CGImageSourceGetGIFFrameDelayAtIndex:(CGImageSourceRef)source index:(size_t)index
{
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    if (delay < 0.02) delay = 0.1;
    return delay;
}

+ (UIImage *)p_imageWithPDF:(id)dataOrPath resize:(BOOL)resize size:(CGSize)size {
    CGPDFDocumentRef pdf = NULL;
    if ([dataOrPath isKindOfClass:[NSData class]]) {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataOrPath);
        pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
    } else if ([dataOrPath isKindOfClass:[NSString class]]) {
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:dataOrPath]);
    }
    if (!pdf) return nil;
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    if (!page) {
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGRect pdfRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGSize pdfSize = resize ? size : pdfRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, pdfSize.width * scale, pdfSize.height * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!ctx) {
        CGColorSpaceRelease(colorSpace);
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -pdfRect.origin.x, -pdfRect.origin.y);
    CGContextDrawPDFPage(ctx, page);
    CGPDFDocumentRelease(pdf);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    UIImage *pdfImage = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    return pdfImage;
}



#pragma mark - 裁剪
- (UIImage *)nr_imageClipRect:(CGRect)clipRect
{
    CGSize imageSize = self.size;
    if (clipRect.origin.x > imageSize.width || clipRect.origin.y > imageSize.height) {
        return nil;
    }
    if (clipRect.origin.x + clipRect.size.width > imageSize.width) {
        clipRect.size.width = imageSize.width - clipRect.origin.x;
    }
    if (clipRect.origin.y + clipRect.size.height > imageSize.height) {
        clipRect.size.height = imageSize.height - clipRect.origin.y;
    }
    UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([self CGImage], clipRect)];
    return newImage;
}

- (nullable UIImage *)nr_imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin
{
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        // 先绘制图片
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth/2, borderWidth/2) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        // 再绘制边框
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale/2;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (nullable UIImage *)nr_imageByRoundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor
{
    return [self nr_imageByRoundCornerRadius:radius
                                     corners:UIRectCornerAllCorners
                                 borderWidth:borderWidth
                                 borderColor:borderColor
                              borderLineJoin:kCGLineJoinMiter];
}

- (nullable UIImage *)nr_circleImageByBorderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor
{
    if (self.size.width == self.size.height) {
        return [self nr_imageByRoundCornerRadius:self.size.width/2 borderWidth:borderWidth borderColor:borderColor];
    } else {
        CGFloat min = MIN(self.size.width, self.size.height);
        CGFloat pointX = (self.size.width - min) / 2;
        CGFloat pointY = (self.size.height - min) / 2;
        UIImage *newImage = [self nr_imageClipRect:CGRectMake(pointX, pointY, min, min)];
        return [newImage nr_imageByRoundCornerRadius:min/2 borderWidth:borderWidth borderColor:borderColor];
    }
}

- (UIImage *)nr_resizableImage:(UIEdgeInsets)edgeInsets resizingMode:(UIImageResizingMode)resizingMode
{
    //    edgeInsets.top < 1 ? edgeInsets.top = 12 : 0;
    //    edgeInsets.left  < 1 ? edgeInsets.left = 12 : 0;
    //    edgeInsets.bottom < 1 ? edgeInsets.bottom = 12 : 0;
    //    edgeInsets.right  < 1 ? edgeInsets.right = 12 : 0;
    /*
     UIImageResizingModeTile  -  平铺
     UIImageResizingModeStretch  -  拉伸
     */
    UIImage *image = [self resizableImageWithCapInsets:edgeInsets resizingMode:resizingMode];
    return image;
}

- (UIImage *)nr_stretchableImage:(NSInteger)left top:(NSInteger)top
{
    UIImage *image = [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    return image;
}

- (UIImage *)nr_imageChangeSize:(CGSize)newSize isScale:(BOOL)isScale
{
    UIImage *newImage;
    if (isScale) {
        CGFloat width = CGImageGetWidth(self.CGImage);
        CGFloat height = CGImageGetHeight(self.CGImage);
        
        float verticalRadio = newSize.height*1.0/height;
        float horizontalRadio = newSize.width*1.0/width;
        
        float radio = 1;
        if(verticalRadio>1 && horizontalRadio>1)
        {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
        }
        
        width = width*radio;
        height = height*radio;
        
        int xPos = (newSize.width - width)/2;
        int yPos = (newSize.height-height)/2;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(newSize);
        
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(xPos, yPos, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    } else {
        UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];//根据新的尺寸画出传过来的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
        UIGraphicsEndImageContext();//关闭当前环境
    }
    return newImage;
}


#pragma mark - 颜色图片
+ (UIImage *)nr_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - 生成渐变色的图片
+ (UIImage *)nr_gradientColorImageWithSize:(CGSize)size andColors:(NSArray *)colors startPoint:(CGPoint)startP endPoint:(CGPoint)endP;
{
    if (colors == nil || colors.count == 0) {
        return nil;
    }
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start = startP;
    CGPoint end = endP;
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 生成带圆角的颜色图片
+ (UIImage *)nr_cornerRadiusImageWithColor:(UIColor *)tintColor targetSize:(CGSize)targetSize corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, [UIScreen mainScreen].scale);
    
    CGRect targetRect = (CGRect){0, 0, targetSize.width, targetSize.height};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [tintColor CGColor]);
    CGContextFillRect(context, targetRect);

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (cornerRadius != 0 && cornerRadius > 0) {
        UIGraphicsBeginImageContextWithOptions(targetSize, YES, [UIScreen mainScreen].scale);

        if (backgroundColor) {
            [backgroundColor setFill];
            CGContextFillRect(UIGraphicsGetCurrentContext(), targetRect);
        }

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
        CGContextClip(UIGraphicsGetCurrentContext());
        [finalImage drawInRect:targetRect];
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return finalImage;
}

+ (UIImage *)nr_squareImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize
{
    return [UIImage nr_cornerRadiusImageWithColor:color targetSize:targetSize corners:UIRectCornerAllCorners cornerRadius:0 backgroundColor:[UIColor whiteColor]];
}

+ (UIImage *)nr_cornerRadiusImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize cornerRadius:(CGFloat)cornerRadius
{
    return [UIImage nr_cornerRadiusImageWithColor:color targetSize:targetSize corners:UIRectCornerAllCorners cornerRadius:cornerRadius backgroundColor:[UIColor whiteColor]];
}


#pragma mark - 图片圆角处理
- (UIImage *)nr_circleImageWithRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContext(self.size);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [bezierPath addClip];
    [self drawInRect:rect];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)nr_circleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)nr_circleHDImage
{
    CGFloat side = MIN(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat marginX = -(self.size.width - side) / 2.f;
    CGFloat marginY = -(self.size.height - side) / 2.f;
    [self drawInRect:CGRectMake(marginX, marginY, self.size.width, self.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

#pragma mark - QRCode
+ (UIImage *)nr_qrHUDImageByContent:(NSString *)content outputSize:(CGFloat)outputSize tintColor:(nullable UIColor *)tintColor logo:(nullable UIImage *)logo logoFrame:(CGRect)logoFrame isCorrectionHighLevel:(BOOL)isHighLevel
{
    if (content == nil || content.length == 0) {
        return nil;
    }
    UIImage *resultImage;
    BOOL openHighCorrection = isHighLevel;
    
    if (tintColor != nil || logo != nil) {
        openHighCorrection = true;
    }
    // 创建基础CIImage
    CIImage *ciImage = [UIImage qrByContent:content correctionHighLevel:openHighCorrection];
    // 根据尺寸返回image
    resultImage = [UIImage adjustHDQRCodeImageWith:ciImage output:outputSize];
    // 修改二维码颜色
    if (tintColor != nil) {
        resultImage = [resultImage modifyQRCodeImageTintColor:tintColor];
    }
    // 添加logo
    if (logo != nil && CGRectEqualToRect(logoFrame, CGRectZero)) {
        resultImage = [resultImage addLogoImage:logo logoFrame:logoFrame];
    }
    
    return resultImage;
}

/// 生成二维码图片（默认大小为430*430）
/// @param content 内容
+ (UIImage *)nr_qrImageByContent:(NSString *)content
{
    return [UIImage nr_qrHUDImageByContent:content outputSize:430 tintColor:nil logo:nil logoFrame:CGRectZero isCorrectionHighLevel:true];
}

/// 生成高清二维码
/// @param content 内容
/// @param outputSize 输出尺寸
+ (UIImage *)nr_qrHUDImageByContent:(NSString *)content outputSize:(CGFloat)outputSize
{
    return [UIImage nr_qrHUDImageByContent:content outputSize:outputSize tintColor:nil logo:nil logoFrame:CGRectZero isCorrectionHighLevel:true];
}

/// 生成高清二维码
/// @param content 内容
/// @param outputSize 输出尺寸
/// @param color 颜色
+ (UIImage *)nr_qrImageByContent:(NSString *)content outputSize:(CGFloat)outputSize color:(nullable UIColor *)color
{
    return [UIImage nr_qrHUDImageByContent:content outputSize:outputSize tintColor:color logo:nil logoFrame:CGRectZero isCorrectionHighLevel:true];
}

/// 生成高清二维码
/// @param content 内容
/// @param logo logo，默认放在中间位置
+ (UIImage *)nr_qrImageWithContent:(NSString *)content outputSize:(CGFloat)outputSize logo:(nullable UIImage *)logo;
{
    CGSize logoSize = logo.size;
    if (logoSize.width > outputSize || logoSize.height > outputSize) {
        UIImage *resultImage = [UIImage nr_qrHUDImageByContent:content outputSize:outputSize tintColor:nil logo:nil logoFrame:CGRectZero isCorrectionHighLevel:true];
        return resultImage;
    }
    CGRect frame = CGRectMake((logoSize.width - outputSize)/2, (logoSize.height - outputSize)/2, logoSize.width, logoSize.height);
    UIImage *resultImage = [UIImage nr_qrHUDImageByContent:content outputSize:outputSize tintColor:nil logo:logo logoFrame:frame isCorrectionHighLevel:true];
    return resultImage;
}

/**
 获取二维码内内容
 */
- (NSString *)nr_getQRCodeContentString
{
    if (!self) {
        return nil;
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage]];
    NSMutableString *contentString = [NSMutableString string];
    for (int index = 0 ; index<features.count; index++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *result = feature.messageString;
        [contentString appendString:result];
    }
    return contentString;
}

#pragma mark - 私有
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (CIImage *)qrByContent:(NSString *)content correctionHighLevel:(BOOL)isHighLevel
{
    // 创建滤镜类
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 输出值
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    // 校正级别(L,M,Q,H)
    NSString *levelString = isHighLevel ? @"H":@"M";
    [qrFilter setValue:levelString forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage;
    return image;
}

/// 调整二维码图片尺寸
+ (UIImage *)adjustHDQRCodeImageWith:(CIImage *)ciImage output:(CGFloat)output
{
    // 将原矩形的值变成整数类型返回
    CGRect extent = CGRectIntegral(ciImage.extent);
    
    CGFloat scale = 5;
    if (output > 0) {
       scale = MIN(output/CGRectGetWidth(extent), output/CGRectGetHeight(extent));
    }
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    /**
     data#> 指向要渲染的绘制内存的地址
     width#> bitmap的宽度,单位为像素
     height#> bitmap的高度,单位为像素
     bitsPerComponent#> 内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     bytesPerRow#> bitmap的每一行在内存所占的比特数
     space#> bitmap上下文使用的颜色空间。
     bitmapInfo#> 指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     */
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *qrImage = [UIImage imageWithCGImage:scaledImage];
    return qrImage;
}

/// 修改二维码图片颜色
/// @param color 颜色
- (UIImage *)modifyQRCodeImageTintColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255; //0~255
            ptr[2] = green*255;
            ptr[1] = blue*255;
        } else {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultImage;
}

/// 添加 logo 图像
/// @param logoImage logo图片
/// @param logoFrame logo位置
- (UIImage *)addLogoImage:(UIImage *)logoImage logoFrame:(CGRect)logoFrame
{
    // 添加logo
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [logoImage drawInRect:logoFrame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




#pragma mark - Effect
- (UIImage *)nr_blurImageWithCoreImageBlurNumber:(CGFloat)blurNum
{
    if (self == nil) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:self.CGImage];
    // 创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 设置滤镜输入的图像
    // 注意：这里的key可以写kCIInputImageKey，也可以写@“inputImage”
    [filter setValue:inputImage forKey:kCIInputImageKey];
    // 设置高斯模糊数值
    // 这里的key可以写kCIInputRadiusKey，也可以写@“inputRadius”。
    [filter setValue:@(blurNum) forKey:kCIInputRadiusKey];
    // 处理后图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)nr_blurImageWithAccelerateBlurValue:(CGFloat)blurValue {
    if (self == nil) {
        return nil;
    }
    if (blurValue < 0.f || blurValue > 1.f) {
        blurValue = 0.5f;
    }
    int boxSize = (int)(blurValue * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


-(UIImage *)nr_applyLightEffect
{
    UIColor *tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    return [self nr_applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage *)nr_applyExtraLightEffect
{
    UIColor *tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    return [self nr_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage *)nr_applyDarkEffect
{
    UIColor *tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    return [self nr_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage *)nr_applyTintEffectWithColor:(UIColor*)tintColor
{
    const CGFloat effectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    NSInteger componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount == 2){
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]){
            effectColor =[UIColor colorWithWhite:b alpha:effectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]){
            effectColor =[UIColor colorWithRed:r green:g blue:b alpha:effectColorAlpha];
        }
    }
    return [self nr_applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}
-(UIImage *)nr_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage*)maskImage
{
    // Check pre-conditions.
    if(self.size.width < 1 || self.size.height < 1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",self.size.width,self.size.height,self);
        return nil;
    }
    if(!self.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage && !maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect ={CGPointZero,self.size};
    UIImage *effectImage = self;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange){
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-self.size.height);
        CGContextDrawImage(effectInContext, imageRect,self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext =UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2!=1){
                radius +=1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
        }
        
        if(hasSaturationChange){
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[]={
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize =sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i =0; i < matrixSize;++i){
                saturationMatrix[i]=(int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur){
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext,1.0,-1.0);
    CGContextTranslateCTM(outputContext,0,-self.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect,self.CGImage);
    // Draw effect image.
    if(hasBlur){
        CGContextSaveGState(outputContext);
        if(maskImage){
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if(tintColor){
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage*outputImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}


#pragma mark - 其他
+ (UIImage *)nr_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock
{
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
