//
//  DSEnvironment.h
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSEnvironment : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *H5Host;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *fornumUrl;
@end

NS_ASSUME_NONNULL_END
