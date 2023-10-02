//
//  DSScannerTool.m
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import "DSScannerTool.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@implementation DSScannerTool
+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [DSHelper findBundleWithBundleName:@"DarkStarScanKit" podName:@"DarkStarScanKit"];
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
