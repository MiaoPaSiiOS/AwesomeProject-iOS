//
//  PHAsset+Nr.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2021/7/3.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (Nr)
/**
 *  获取最新一张图片
 */
+ (PHAsset *)nr_latestAsset;

+ (UIImage *)nr_latestOriginImage;

+ (void)nr_latestImageWithSize:(CGSize)size completeBlock:(void(^)(UIImage *image))block;

@end

NS_ASSUME_NONNULL_END
