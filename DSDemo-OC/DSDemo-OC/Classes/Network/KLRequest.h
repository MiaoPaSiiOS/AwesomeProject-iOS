//
//  KLRequest.h
//  REWLY
//
//  Created by zhuyuhui on 2023/4/8.
//

#import <Foundation/Foundation.h>
#import "KLUploadFile.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AmenNetworkRequestType) {
    AmenNetworkRequestTypeGET,
    AmenNetworkRequestTypePOST,
    AmenNetworkRequestTypePUT,
    AmenNetworkRequestTypePATCH,
    AmenNetworkRequestTypeDELETE
};


typedef NS_ENUM(NSInteger, AmenNetworkContentType){
    AmenNetworkContentTypeDefault = 0,          //默认
    AmenNetworkContentTypeMultipartFromData,    //multipart/form-data格式
};



@interface KLRequest : NSObject
@property(nonatomic, copy) NSString *urlPath;
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, assign) AmenNetworkRequestType requestType;
@property(nonatomic, strong, nullable) NSDictionary *header;
@property(nonatomic, strong, nullable) NSDictionary *params;
@property(nonatomic, strong, nullable) NSArray<KLUploadFile *>*contents;
@property(nonatomic, assign) AmenNetworkContentType contentType;
/**
 *  功能:初始化方法
 */
+ (instancetype)createReqWithUrl:(NSString *)urlPath
                          header:(NSDictionary *_Nullable)header
                          params:(NSDictionary *_Nullable)params
                     requestType:(AmenNetworkRequestType)requestType;
@end

NS_ASSUME_NONNULL_END
