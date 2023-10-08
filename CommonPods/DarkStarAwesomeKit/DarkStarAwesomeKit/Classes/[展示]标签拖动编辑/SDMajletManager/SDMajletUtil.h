//
//  SDMajletUtil.h
//  DarkStarAwesomeKit
//
//  Created by zhuyuhui on 2023/10/7.
//

#import <Foundation/Foundation.h>
#import "SDMajletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SDMajletUtil : NSObject

+ (void)saveMyApplicationInfo:(NSDictionary *)infoDict;

+ (void)clearMyApplicationInfo;

+ (SDMajletModel *)createMyApplyModel;


+ (void)fetchApplicationListHandler:(void (^)(NSArray<SDMajletModel *> *))completionHandler;
@end

NS_ASSUME_NONNULL_END
