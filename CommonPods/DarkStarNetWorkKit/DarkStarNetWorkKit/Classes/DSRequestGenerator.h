//
//  DSRequestGenerator.h
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "DSUploadFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface DSRequestGenerator : NSObject
@property(nonatomic, strong) AFHTTPRequestSerializer *requestSerialize;

- (NSMutableURLRequest *)generateRequestWithUrlPath:(NSString *)urlPath
                                             method:(NSString *)method
                                             params:(NSDictionary *)params
                                             header:(NSDictionary *)header;

//下载
- (NSMutableURLRequest *)generateDownloadRequestWithUrlPath:(NSString *)urlPath
                                             method:(NSString *)method
                                             params:(NSDictionary *)params
                                             header:(NSDictionary *)header;

//上传
- (NSMutableURLRequest *)generateUploadRequestUrlPath:(NSString *)urlPath
                                               params:(NSDictionary *)params
                                             contents:(NSArray<DSUploadFile *> *)contents
                                               header:(NSDictionary *)header;

@end

NS_ASSUME_NONNULL_END
