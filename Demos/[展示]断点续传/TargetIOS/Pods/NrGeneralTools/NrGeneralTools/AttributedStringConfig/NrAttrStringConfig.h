//
//  NrAttrStringConfig.h
//  NrAttributedStringConfig
//
//  Created by zhuyuhui on 2020/9/2.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NrAttrStringConfig : NSObject
@property (nonatomic, strong, readonly) NSString *attributeName;
@property (nonatomic, strong, readonly) id        attributeValue;
@property (nonatomic)                   NSRange   effectiveStringRange;
@end

NS_ASSUME_NONNULL_END
