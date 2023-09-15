//
//  AmenFeedTool.h
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AmenFeedTool : NSObject
+ (NSBundle *)AssetsBundle;
+ (NSBundle *)AssetsTwitterBundle;
+ (NSBundle *)AssetsWeiboBundle;

+ (UIImage *)imageNamed:(NSString *)name;

+ (NSString *)qmui_md5:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
