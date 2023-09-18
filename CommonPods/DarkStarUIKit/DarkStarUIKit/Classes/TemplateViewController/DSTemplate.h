//
//  DSTemplate.h
//  DarkStarUIKit
//
//  Created by zhuyuhui on 2023/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTemplate : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *classStr;
@property(nonatomic, strong) NSDictionary *extParmers;
@end

NS_ASSUME_NONNULL_END
