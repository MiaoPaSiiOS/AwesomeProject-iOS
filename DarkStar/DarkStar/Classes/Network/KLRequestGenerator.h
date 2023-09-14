//
//  KLRequestGenerator.h
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "KLRequest.h"
#import "KLUploadFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface KLRequestGenerator : NSObject
@property(nonatomic, strong) AFJSONRequestSerializer *requestSerialize;

- (NSMutableURLRequest *)generateRequestWithRequest:(KLRequest *)requestModel;

//下载
- (NSMutableURLRequest *)generateDownloadRequestWithRequest:(KLRequest *)requestModel;

//上传
- (NSMutableURLRequest *)generateUploadRequestWithRequest:(KLRequest *)requestModel;

@end

NS_ASSUME_NONNULL_END
