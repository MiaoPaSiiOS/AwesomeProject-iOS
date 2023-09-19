//
//  KLResponse.h
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLResponse : NSObject
/// 成功or失败
@property(nonatomic, assign) BOOL success;
@property(nullable, nonatomic, strong) NSError *error;
@property(nullable, nonatomic, strong) id responseObject;
@property(nullable, nonatomic, copy) NSString *message;
- (instancetype)initWithResponseObject:(nullable id)responseObject
                            parseError:(nullable NSError *)parseError;


@end

NS_ASSUME_NONNULL_END
