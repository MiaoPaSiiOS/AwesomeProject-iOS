//
//  UIImage+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UIImage+DSGray.h"
#import "DSGrayUtil.h"

@implementation UIImage (DSGray)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass(self);
        
        Method imageNameMethod = class_getClassMethod(class, @selector(imageNamed:));
        Method grayImageNameMethod = class_getClassMethod(class, @selector(grayImageNamed:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(imageNamed:) oriMethod:imageNameMethod swizzledSel:@selector(grayImageNamed:) swizzledMethod:grayImageNameMethod oriClass:class];

        Method imageCGImageMethod = class_getClassMethod(class, @selector(imageWithCGImage:));
        Method grayCGImgNameMethod = class_getClassMethod(class, @selector(grayCGImageWithCGImage:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(imageWithCGImage:) oriMethod:imageCGImageMethod swizzledSel:@selector(grayCGImageWithCGImage:) swizzledMethod:grayCGImgNameMethod oriClass:class];

        Method imageDataMethod = class_getClassMethod(class, @selector(imageWithData:));
        Method grayImageDataMethod = class_getClassMethod(class, @selector(grayImageWithData:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(imageWithData:) oriMethod:imageDataMethod swizzledSel:@selector(grayImageWithData:) swizzledMethod:grayImageDataMethod oriClass:class];
        
        Method imageWithContentsOfFileMethod = class_getClassMethod(class, @selector(imageWithContentsOfFile:));
        Method grayImageWithContentsOfFileMethod = class_getClassMethod(class, @selector(grayImageWithContentsOfFile:));
        //方法替换
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(imageWithContentsOfFile:) oriMethod:imageWithContentsOfFileMethod swizzledSel:@selector(grayImageWithContentsOfFile:) swizzledMethod:grayImageWithContentsOfFileMethod oriClass:class];
    });
}

+ (UIImage *)grayImageNamed:(NSString *)name {
    UIImage *image = [UIImage grayImageNamed:name];
    if (image && [DSGrayManager shared].grayViewEnabled) {
        image = [DSGrayUtil grayImageForUIImage:image];
    }
    return image;
}

+ (UIImage *)grayCGImageWithCGImage:(CGImageRef)imageRef {
    UIImage *image = [UIImage grayCGImageWithCGImage:imageRef];
    if (image && [DSGrayManager shared].grayViewEnabled) {
        image = [DSGrayUtil grayImageForUIImage:image];
    }
    return image;
}

+ (UIImage *)grayImageWithData:(NSData *)data {
    UIImage *image = [UIImage grayImageWithData:data];
    if (image && [DSGrayManager shared].grayViewEnabled) {
        image = [DSGrayUtil grayImageForUIImage:image];
    }
    return image;
}

+ (UIImage *)grayImageWithContentsOfFile:(NSString *)path{
    UIImage *image = [UIImage grayImageWithContentsOfFile:path];
    if (image && [DSGrayManager shared].grayViewEnabled) {
        image = [DSGrayUtil grayImageForUIImage:image];
    }
    return image;
}
@end
