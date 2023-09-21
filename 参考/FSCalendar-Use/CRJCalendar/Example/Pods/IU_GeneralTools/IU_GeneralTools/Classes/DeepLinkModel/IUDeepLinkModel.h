//
//  IUDeepLinkModel.h
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*

ajmall://app/home?pager=item_detail&target_id=484515418854260736&source_scene=home_store&source_param=9

scheme    : ajmall
host      : ajmall://app/home
paramsStr : pager=item_detail&target_id=484515418854260736&source_scene=home_store&source_param=9
params    : @{@"pager"        : @"item_detail",
              @"target_id"    : @"484515418854260736",
              @"source_scene" : @"home_store",
              @"source_param" : @"9"};
}

*/
@interface IUDeepLinkModel : NSObject
@property (nonatomic, readonly) NSString     *scheme;
@property (nonatomic, readonly) NSString     *host;
@property (nonatomic, readonly) NSString     *paramsStr;
@property (nonatomic, readonly) NSDictionary *params; // paramsStr转化过来的

+ (instancetype)deepLinkModelWithURLStr:(NSString *)urlString;

+ (instancetype)deepLinkModelWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
