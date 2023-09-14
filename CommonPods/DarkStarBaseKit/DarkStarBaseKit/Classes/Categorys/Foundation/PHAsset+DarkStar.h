//
//  PHAsset+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2021/7/3.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (DarkStar)
/**
 *  获取最新一张图片
 */
+ (PHAsset *)ds_latestAsset;

+ (UIImage *)ds_latestOriginImage;

+ (void)ds_latestImageWithSize:(CGSize)size completeBlock:(void(^)(UIImage *image))block;

@end

NS_ASSUME_NONNULL_END
