//
//  AECResouce.m
//  AmenEnjoyCamera
//
//  Created by zhuyuhui on 2021/6/23.
//

#import "AECResouce.h"
#import <YYCache/YYCache.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@implementation AECResouce
+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarEnjoyCameraKit" inPod:@"DarkStarEnjoyCameraKit"];
    });
    return bundle;
}

+ (NSBundle *)AssetsExtBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarEnjoyCameraKitExt" inPod:@"DarkStarEnjoyCameraKit"];
    });
    return bundle;
}


///
+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"AmenEnjoyCameraImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name{
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path;
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Images"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    
    NSString *pass = [NSString stringWithFormat:@"%@.%@",name,ext];
    path = [addBundle.bundlePath stringByAppendingPathComponent:pass];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;

}

+ (UINib *)nibWithNibName:(NSString *)name {
    return [UINib nibWithNibName:name bundle:[self AssetsExtBundle]];
}

+ (NSBundle *)Config{
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Config"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    return addBundle;
}

+ (NSBundle *)Filters{
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Filters"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    return addBundle;
}

+ (NSBundle *)Frames{
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Frames"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    return addBundle;
}

@end
