//
//  AmenFeedTool.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import "AmenFeedTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@implementation AmenFeedTool

+ (NSBundle *)AssetsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarFeedKit" inPod:@"DarkStarFeedKit"];
    });
    return bundle;
}

+ (NSBundle *)AssetsTwitterBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarFeedKit-Twitter" inPod:@"DarkStarFeedKit"];
    });
    return bundle;
}

+ (NSBundle *)AssetsWeiboBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle ds_bundleName:@"DarkStarFeedKit-Weibo" inPod:@"DarkStarFeedKit"];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name{
    if (!name) return nil;
    NSBundle *addBundle = [self AssetsBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:addBundle compatibleWithTraitCollection:nil];
    return image;
}



+ (NSString *)qmui_md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
