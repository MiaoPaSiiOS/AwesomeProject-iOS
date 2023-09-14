//
//  NrAppUpdateManager.h
//  IU_UpdateSDK
//
//

#import <Foundation/Foundation.h>

@class NrAppUpdateConfig;
@class NrAppUpdateResponseModel;

typedef void (^AppUpdateCallback)(NrAppUpdateResponseModel * _Nonnull response);

NS_ASSUME_NONNULL_BEGIN

@interface NrAppUpdateManager : NSObject

+ (instancetype)share;

- (void)checkAppUpdate:(NrAppUpdateConfig *)config;

- (void)checkAppUpdate:(NrAppUpdateConfig *)config
               success:(AppUpdateCallback _Nullable)successCallback
              failture:(AppUpdateCallback _Nullable)failtureCallback;

@end

NS_ASSUME_NONNULL_END
