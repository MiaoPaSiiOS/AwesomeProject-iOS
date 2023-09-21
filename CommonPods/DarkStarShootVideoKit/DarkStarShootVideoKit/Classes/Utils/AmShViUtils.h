//
//  AmShViUtils.h
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>
#import <YYImage/YYImage.h>
NS_ASSUME_NONNULL_BEGIN
#define AmShViImage(name_) [AmShViUtils imageNamed:name_]
#define AmShViMainBundleImage(name_) [UIImage imageNamed:name_]
@interface AmShViUtils : NSObject
+ (NSBundle *)AssetsBundle;
+ (NSBundle *)AssetsBundleExt;
/// Image cache
+ (YYMemoryCache *)imageCache;

+ (UIImage *)imageNamed:(NSString *)name;
+ (NSString *)jsonPathWithJsonNamed:(NSString *)jsonName;
+ (NSString *)musicPathWithMusicNamed:(NSString *)musicName;
+ (NSString *)videoPathWithVideoNamed:(NSString *)videoName;

@end

NS_ASSUME_NONNULL_END
