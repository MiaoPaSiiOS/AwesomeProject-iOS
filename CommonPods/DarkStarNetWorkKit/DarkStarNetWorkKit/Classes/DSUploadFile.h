//
//  DSUploadFile.h
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSUploadFile : NSObject
/// fileData
@property (nonatomic, strong) NSData *fileData;
/// 请求字段
@property (nonatomic, copy) NSString *name;
/// 上传文件名
@property (nonatomic, copy) NSString *fileName;
/// 文件mimeType
@property (nonatomic, copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
