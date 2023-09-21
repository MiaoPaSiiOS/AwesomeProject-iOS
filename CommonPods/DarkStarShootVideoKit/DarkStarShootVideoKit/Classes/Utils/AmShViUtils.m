//
//  AmShViUtils.m
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import "AmShViUtils.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@implementation AmShViUtils
+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarShootVideoKit" inPod:@"DarkStarShootVideoKit"];
    });
    return bundle;
}

+ (NSBundle *)AssetsBundleExt {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarShootVideoKitExt" inPod:@"DarkStarShootVideoKit"];
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
        cache.name = @"AmenShootVideoImageCache";
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

+ (NSString *)jsonPathWithJsonNamed:(NSString *)jsonName{
    if (!jsonName) return nil;
    NSString *path;
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Jsons"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    
    NSString *pass = [NSString stringWithFormat:@"%@.%@",jsonName,@"json"];
    path = [addBundle.bundlePath stringByAppendingPathComponent:pass];
    if (!path) return nil;
    return path;
}

+ (NSString *)musicPathWithMusicNamed:(NSString *)musicName{
    if (!musicName) return nil;
    NSString *path;
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Musics"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    
    NSString *pass = [NSString stringWithFormat:@"%@.%@",musicName,@"mp3"];
    path = [addBundle.bundlePath stringByAppendingPathComponent:pass];
    if (!path) return nil;
    return path;
}

+ (NSString *)videoPathWithVideoNamed:(NSString *)videoName{
    if (!videoName) return nil;
    NSString *path;
    NSBundle *addBundle = [self AssetsBundle];
    NSString *addBundlePath = [[self AssetsBundle].bundlePath stringByAppendingPathComponent:@"Videos"];
    addBundle = [NSBundle bundleWithPath:addBundlePath];
    
    NSString *pass = [NSString stringWithFormat:@"%@.%@",videoName,@"mp4"];
    path = [addBundle.bundlePath stringByAppendingPathComponent:pass];
    if (!path) return nil;
    return path;
}
@end
