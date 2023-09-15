//
//  AmenFeedTool.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import "DSAccountTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@implementation DSAccountTool

+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarAccountKit" inPod:@"DarkStarAccountKit"];
    });
    return bundle;
}


+ (UIImage *)imageNamed:(NSString *)name{
    if (!name) return nil;
    NSBundle *addBundle = [self AssetsBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:addBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
