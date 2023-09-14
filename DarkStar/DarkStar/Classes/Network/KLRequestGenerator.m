//
//  KLRequestGenerator.m
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import "KLRequestGenerator.h"

@implementation KLRequestGenerator
- (NSString *)urlStringWithPath:(NSString *)path {
    if ([path containsString:@"http"]) {
        return path;
    } else {
        NSString *fullPath = [NSString stringWithFormat:@"%@%@",DEFAULTINTERFACEURLHOST,path];
        return fullPath;
    }
}
#pragma mark - Interface
- (NSString *)methodName:(AmenNetworkRequestType)requestType{
    NSString *method = @"";
    switch (requestType) {
        case AmenNetworkRequestTypeGET:
            method = @"GET";
            break;
        case AmenNetworkRequestTypePOST:
            method = @"POST";
            break;
        case AmenNetworkRequestTypePUT:
            method = @"PUT";
            break;
        case AmenNetworkRequestTypePATCH:
            method = @"PATCH";
            break;
        case AmenNetworkRequestTypeDELETE:
            method = @"DELETE";
            break;
        default:
            break;
    }
    return method;
}
 
- (NSMutableDictionary *)generateRequestParmersWithRequest:(KLRequest *)requestModel {
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    [finalParams addEntriesFromDictionary:requestModel.params];
    if (finalParams[@"ut"] == nil) {
        if (safeString([REDataManagement shared].token).length) {
            finalParams[@"ut"] = safeString([REDataManagement shared].token);
        }
    }
    return finalParams;
}
#pragma mark - Interface

- (NSMutableURLRequest *)generateRequestWithRequest:(KLRequest *)requestModel {
    NSString *method = [self methodName:requestModel.requestType];
    NSString *urlString = [self urlStringWithPath:requestModel.urlPath];
    NSMutableDictionary *finalParams = [self generateRequestParmersWithRequest:requestModel];
    NSMutableURLRequest *request = [self requestWithMethod:method URLString:urlString parameters:finalParams requestModel:requestModel];
    request.timeoutInterval = requestModel.timeoutInterval;
    [self setCommonRequestHeaderForRequest:request requestModel:requestModel];
    [requestModel.header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

- (NSMutableURLRequest *)generateDownloadRequestWithRequest:(KLRequest *)requestModel
{
    NSString *method = [self methodName:requestModel.requestType];
    NSString *urlString = [self urlStringWithPath:requestModel.urlPath];
    NSMutableDictionary *finalParams = [self generateRequestParmersWithRequest:requestModel];
    NSMutableURLRequest *request = [self requestWithMethod:method URLString:urlString parameters:finalParams requestModel:requestModel];
    [self setCommonRequestHeaderForRequest:request requestModel:requestModel];
    [requestModel.header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}


- (NSMutableURLRequest *)generateUploadRequestWithRequest:(KLRequest *)requestModel
{
    
    NSString *method = [self methodName:requestModel.requestType];
    NSString *urlString = [self urlStringWithPath:requestModel.urlPath];
    NSMutableDictionary *finalParams = [self generateRequestParmersWithRequest:requestModel];
    NSMutableURLRequest *request = [self.requestSerialize multipartFormRequestWithMethod:method URLString:urlString parameters:finalParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [requestModel.contents enumerateObjectsUsingBlock:^(KLUploadFile * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
        }];
    } error:nil];
    request.timeoutInterval = 30 * 2;
    [self setCookies];
    [self setCommonRequestHeaderForRequest:request requestModel:requestModel];
    [requestModel.header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return request;
}

#pragma mark - Utils

- (void)setCookies {
    
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                              requestModel:(KLRequest *)requestModel;
{
    if (requestModel.contentType == AmenNetworkContentTypeMultipartFromData) {
        NSString *boundary = @"--------------------------566333353474750544927069";
        //⭐️1.构建URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",URLString]];

        //⭐️2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //(1)请求模式(默认是GET)
        [request setHTTPMethod:method];
        //(2)超时时间
        [request setTimeoutInterval:30];

        //⭐️4.请求Header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

        //⭐️5.请求体数据
        NSMutableData *postData = [[NSMutableData alloc] init];
        for (NSString *key in parameters) {
            //循环参数按照部分1、2、3那样循环构建每部分数据
            NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
            [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
            id value = [parameters objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            }else if ([value isKindOfClass:[NSData class]]){
                [postData appendData:value];
            }
            [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //设置结尾
        [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            request.HTTPBody = postData;
        //设置请求头总数据长度
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        return request;
        
    } else {
        return [self.requestSerialize requestWithMethod:method URLString:URLString parameters:parameters error:nil];
    }
}




- (NSMutableURLRequest *)setCommonRequestHeaderForRequest:(NSMutableURLRequest *)request
                                             requestModel:(KLRequest *)requestModel
{
//    if (requestModel.jsonRequest) {
//        NSString *boundary = @"--------------------------326426358541343271810436";
//        NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
//        for (NSString *key in requestModel.params) {
//            //循环参数按照部分1、2、3那样循环构建每部分数据
//            NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
//            [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
//            id value = [requestModel.params objectForKey:key];
//            if ([value isKindOfClass:[NSString class]]) {
//                [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//            }else if ([value isKindOfClass:[NSData class]]){
//                [postData appendData:value];
//            }
//            [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        }
////
//        //文件部分
//        NSString *filename = [filePath lastPathComponent];
//        NSString *contentType = AFContentTypeForPathExtension([filePath pathExtension]);
//
//        NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"
//    Content-Type=%@\r\n\r\n",boundary,fileKey,filename,contentType];
//        [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
//        [postData appendData:fileData]; //加入文件的数据
//    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

//    如果有多个文件，就重复设置文件部分，使用不同的`name`标识。
        
        //设置结尾
//        [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            request.HTTPBody = postData;
//        //设置请求头总数据长度
//        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];

        
        
        
        
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestModel.params options:0 error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        request.timeoutInterval=  10;
//        [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [request setValue:@"zh-CN,zh;q=0.9,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
//        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//        NSString *boundary = @"--------------------------326426358541343271810436";
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
//        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];


//    }
//
    //cookie 设置接口请求cookies
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    
    if (requestModel.params[@"ut"] != nil) {
        [cookieString appendFormat:@"%@=%@;", @"ut", safeString(requestModel.params[@"ut"])];
    } else {
        if (safeString([REDataManagement shared].token).length) {
            [cookieString appendFormat:@"%@=%@;", @"ut", safeString([REDataManagement shared].token)];
        }
    }
//    [cookieString appendFormat:@"%@=%@;", @"locale", [LanguageManager shareInstance].currentLaguage];
//    [cookieString appendFormat:@"%@=%@;", @"companyId", [REGlobal sharedInstance].companyId];
    [request setValue:cookieString forHTTPHeaderField:@"Cookie"];

//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestModel.params options:0 error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return  request;
}

#pragma mark - Getter
- (AFJSONRequestSerializer *)requestSerialize {
    if (!_requestSerialize) {
        _requestSerialize = [AFJSONRequestSerializer serializer];
    }
    return _requestSerialize;
}


@end
