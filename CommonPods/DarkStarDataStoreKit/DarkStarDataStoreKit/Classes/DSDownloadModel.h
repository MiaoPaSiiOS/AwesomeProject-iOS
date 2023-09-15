//
//  DSDownloadModel.h
//  AmenSakuraKit_Example
//
//  Created by zhuyuhui on 2022/6/28.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSDownloadManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface DSDownloadModel : NSObject<DSDownloadProtocol>
@property (copy, nonatomic) NSString * remoteURL;
@property (copy, nonatomic) NSString * dirName;
@property (copy, nonatomic) NSString * zipName;
@end

NS_ASSUME_NONNULL_END
