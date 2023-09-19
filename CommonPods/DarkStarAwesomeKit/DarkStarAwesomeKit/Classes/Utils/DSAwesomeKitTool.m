//
//  DSAwesomeKitTool.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import "DSAwesomeKitTool.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@implementation DSAwesomeKitTool

+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarAwesomeKit" inPod:@"DarkStarAwesomeKit"];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name{
    if (!name) return nil;
    NSBundle *addBundle = [self AssetsBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:addBundle compatibleWithTraitCollection:nil];
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name inDirectory:(nullable NSString *)subpath{
    if (!name) return nil;
    // 获取图片资源的路径
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path;
    if ([ext isEqualToString:@"png"]) {
        path = [[self AssetsBundle] pathForScaledResource:name ofType:ext inDirectory:subpath];
    } else {
        // 获取文件名（不包括扩展名）
        NSString *imageName = [name stringByDeletingPathExtension];
        path = [[self AssetsBundle] pathForResource:imageName ofType:ext inDirectory:subpath];
    }
    if (!path) return nil;
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (NSString *)imagePathWithNamed:(NSString *)name inDirectory:(nullable NSString *)subpath {
    if (!name) return nil;
    // 获取图片资源的路径
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path;
    if ([ext isEqualToString:@"png"]) {
        path = [[self AssetsBundle] pathForScaledResource:name ofType:ext inDirectory:subpath];
    } else {
        // 获取文件名（不包括扩展名）
        NSString *imageName = [name stringByDeletingPathExtension];
        path = [[self AssetsBundle] pathForResource:imageName ofType:ext inDirectory:subpath];
    }
    if (!path) return nil;
    return path;
}
@end
