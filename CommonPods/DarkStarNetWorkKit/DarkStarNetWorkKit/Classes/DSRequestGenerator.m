//
//  DSRequestGenerator.m
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/6/16.
//

#import "DSRequestGenerator.h"

@implementation DSRequestGenerator
#pragma mark - Interface

- (NSMutableURLRequest *)generateRequestWithUrlPath:(NSString *)urlPath method:(NSString *)method params:(NSDictionary *)params header:(NSDictionary *)header {
    
    NSString *urlString = [self urlStringWithPath:urlPath];
    NSMutableURLRequest *request = [self.requestSerialize requestWithMethod:method URLString:urlString parameters:params error:nil];
    request.timeoutInterval = 30;
    [self setCommonRequestHeaderForRequest:request];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

- (NSMutableURLRequest *)generateDownloadRequestWithUrlPath:(NSString *)urlPath
                                             method:(NSString *)method
                                             params:(NSDictionary *)params
                                             header:(NSDictionary *)header
{
    NSString *urlString = [self urlStringWithPath:urlPath];
    NSMutableURLRequest *request = [self.requestSerialize requestWithMethod:method URLString:urlString parameters:params error:nil];
    request.timeoutInterval = 60;
    [self setCommonRequestHeaderForRequest:request];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}


- (NSMutableURLRequest *)generateUploadRequestUrlPath:(NSString *)urlPath params:(NSDictionary *)params contents:(NSArray<DSUploadFile *> *)contents header:(NSDictionary *)header {
    
    NSString *urlString = [self urlStringWithPath:urlPath];
    NSMutableURLRequest *request = [self.requestSerialize multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [contents enumerateObjectsUsingBlock:^(DSUploadFile * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
        }];
    } error:nil];
    request.timeoutInterval = 30 * 2;
    [self setCookies];
    [self setCommonRequestHeaderForRequest:request];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

#pragma mark - Utils

- (NSString *)urlStringWithPath:(NSString *)path {
    return path;
}

- (void)setCookies {
    
}

- (NSMutableURLRequest *)setCommonRequestHeaderForRequest:(NSMutableURLRequest *)request {
//    在这里设置通用的请求头
//    [request setValue:@"xxx" forHTTPHeaderField:@"xxx"];
//    [request setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Content-Type"];
    
//    [request setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"token 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" forHTTPHeaderField:@"Authorization"];

    return  request;
}

#pragma mark - Getter
- (AFHTTPRequestSerializer *)requestSerialize {
    if (!_requestSerialize) {
        _requestSerialize = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerialize;
}


@end
