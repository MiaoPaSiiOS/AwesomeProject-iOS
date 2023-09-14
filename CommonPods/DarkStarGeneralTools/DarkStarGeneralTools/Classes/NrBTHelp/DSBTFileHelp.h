//
//  DSBTFileHelp.h
//  NrDataStoreFramework
//
//  Created by zhuyuhui on 2021/11/5.
//
/*
 默认情况下，每个沙盒含有3个文件夹：Documents, Library 和 tmp和一个应用程序文件（也是一个文件）。因为应用的沙盒机制，应用只能在几个目录下读写文件
 
 Documents：苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
 
 Library：存储程序的默认设置或其它状态信息；
 
 Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 
 tmp：提供一个即时创建临时文件的地方。
 
 iTunes在与iPhone同步时，备份所有的Documents和Library文件。
 
 iPhone在重启时，会丢弃所有的tmp文件。
 
 */
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DSBTFileHelp : NSObject

#pragma mark - 沙盒目录相关
// 沙盒的主目录路径
+ (nullable NSString *)homeDir;
// 沙盒中Documents的目录路径
+ (nullable NSString *)documentsDir;
// 沙盒中Library的目录路径
+ (nullable NSString *)libraryDir;
// 沙盒中Libarary/Preferences的目录路径
+ (nullable NSString *)preferencesDir;
// 沙盒中Library/Caches的目录路径
+ (nullable NSString *)cachesDir;
// 沙盒中tmp的目录路径
+ (nullable NSString *)tmpDir;

#pragma mark - 遍历文件夹
/**
 文件遍历
 @param path 目录的绝对路径
 @param deep 是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
                       2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 @return 遍历结果数组
 */
+ (nullable NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;
// 遍历沙盒主目录
+ (nullable NSArray *)listFilesInHomeDirectoryByDeep:(BOOL)deep;
// 遍历Documents目录
+ (nullable NSArray *)listFilesInDocumentDirectoryByDeep:(BOOL)deep;
// 遍历Library目录
+ (nullable NSArray *)listFilesInLibraryDirectoryByDeep:(BOOL)deep;
// 遍历Caches目录
+ (nullable NSArray *)listFilesInCachesDirectoryByDeep:(BOOL)deep;
// 遍历tmp目录
+ (nullable NSArray *)listFilesInTmpDirectoryByDeep:(BOOL)deep;

#pragma mark - 获取文件属性
// 根据key获取文件某个属性
+ (nullable id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;
// 获取文件属性集合
+ (nullable NSDictionary *)attributesOfItemAtPath:(NSString *)path;

#pragma mark - 创建文件(夹)
// 创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)path;
// 创建文件夹（异步）
+ (void)asyncCreateDirectoryAtPath:(NSString *)path
                          complete:(void(^ _Nullable)(BOOL success))complete;

// 创建文件
+ (BOOL)createFileAtPath:(NSString *)path;
// 创建文件，是否覆盖
+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;
// 创建文件，文件内容
+ (BOOL)createFileAtPath:(NSString *)path content:(id _Nullable)content;
// 创建文件，文件内容，是否覆盖
+ (BOOL)createFileAtPath:(NSString *)path content:(id _Nullable)content overwrite:(BOOL)overwrite;
// 创建文件（异步）
+ (void)asyncCreateFileAtPath:(NSString *)path
                      content:(id _Nullable)content
                    overwrite:(BOOL)overwrite
                     complete:(void(^_Nullable)(BOOL success))complete;

// 获取创建文件时间
+ (NSDate *)creationDateOfItemAtPath:(NSString *)path;
// 获取文件修改时间
+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path;

#pragma mark - 删除文件(夹)
// 删除文件
+ (BOOL)removeItemAtPath:(NSString *)path;
// 删除文件（异步）
+ (void)asyncRemoveItemAtPath:(NSString *)path
                     complete:(void(^_Nullable)(BOOL success))complete;

// 清空Caches文件夹
+ (BOOL)clearCachesDirectory;
// 清空tmp文件夹
+ (BOOL)clearTmpDirectory;

#pragma mark - 复制文件(夹)
// 复制文件
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath;
// 复制文件，是否覆盖
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
// 复制文件（异步）
+ (void)asyncCopyItemAtPath:(NSString *)path
                     toPath:(NSString *)toPath
                  overwrite:(BOOL)overwrite
                   complete:(void(^_Nullable)(BOOL success))complete;

#pragma mark - 移动文件(夹)
// 移动文件
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;
// 移动文件，是否覆盖
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
// 移动文件（异步）
+ (void)asyncMoveItemAtPath:(NSString *)path
                     toPath:(NSString *)toPath
                  overwrite:(BOOL)overwrite
                   complete:(void(^_Nullable)(BOOL success))complete;

#pragma mark - 根据URL获取文件名
// 根据文件路径获取文件名称，是否需要后缀
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix;
// 获取文件所在的文件夹路径
+ (NSString *)directoryAtPath:(NSString *)path;
// 根据文件路径获取文件扩展类型
+ (NSString *)suffixAtPath:(NSString *)path;

#pragma mark - 判断文件(夹)是否存在
// 判断文件路径是否存在
+ (BOOL)isExistsAtPath:(NSString *)path;
// 判断路径是否为空(判空条件是文件大小为0，或者是文件夹下没有子文件)
+ (BOOL)isEmptyItemAtPath:(NSString *)path;
// 判断目录是否是文件夹
+ (BOOL)isDirectoryAtPath:(NSString *)path;
// 判断目录是否是文件
+ (BOOL)isFileAtPath:(NSString *)path;
// 判断目录是否可以执行
+ (BOOL)isExecutableItemAtPath:(NSString *)path;
// 判断目录是否可读
+ (BOOL)isReadableItemAtPath:(NSString *)path;
// 判断目录是否可写
+ (BOOL)isWritableItemAtPath:(NSString *)path;

#pragma mark - 获取文件(夹)大小
// 获取目录大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path;
// 获取文件大小
+ (NSNumber *)sizeOfFileAtPath:(NSString *)path;
// 获取文件夹大小
+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path;
// 获取目录大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path;
// 获取文件大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path;
// 获取文件夹大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path;

#pragma mark - 获取文件内容
/**
 同步获取存储的文件内容
 
 @param path 文件路径
 @param name 文件名称
 @return 文件内容
 */
+ (nullable id)syncFetchFile:(nullable NSString *)path name:(nullable NSString *)name;

/**
 异步获取存储的文件内容
 
 @param path 文件路径
 @param name 文件名称
 @param complete 文件内容回调
 */
+ (void)asyncFetchFile:(nullable NSString *)path
                  name:(nullable NSString *)name
              complete:(void(^ _Nullable)(id _Nullable content))complete;

@end

NS_ASSUME_NONNULL_END
/*
 
 static NSString * const kUIDataPageFold = @"UI_Data_Page_Cache";

 @interface AMENUIDataManager()

 @end

 @implementation AMENUIDataManager

 + (void)achieveJSONCacheDataWithJsonUrl:(NSString *)jsonUrl
              completeHandler:(void(^)(BOOL success, NSDictionary *datas))completeHandler {
     NSString *fileName = [jsonUrl qmui_md5];
     NSString *filePath = [self jsonCacheDataPath:fileName];
     [DSBTFileHelp asyncFetchFileAsString:filePath complete:^(id  _Nullable content) {
         if (!content || ![content isKindOfClass:[NSString class]]) {
             if (completeHandler) {
                 completeHandler(NO, nil);
             }
             // 删除缓存数据
             [DSBTFileHelp asyncRemoveItemAtPath:filePath complete:nil];
             return;
         }
         NSDictionary *dictionary = [self dictionaryWithJsonString:content];
         if (completeHandler) {
             completeHandler(YES, dictionary);
         }
     }];
 }

 + (void)achieveJSONDataWithJsonUrl:(NSString *)jsonUrl
              completeHandler:(void(^)(BOOL success, NSDictionary *datas))completeHandler {
     NSString *fileName = [jsonUrl qmui_md5];
     NSString *filePath = [self jsonCacheDataPath:fileName];
     [[AMENNetWorkManager sharedInstance] dataTaskWithUrlPath:jsonUrl requestType:AmenNetworkRequestTypeGET header:@{} params:@{} completionHandler:^(AMENResponse *response) {
         if (response.success) {
             if (response.responseObject && [response.responseObject isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *responseObject = response.responseObject;
                 NSString *encoding = responseObject[@"encoding"];
                 NSString *content = responseObject[@"content"];
                 if ([encoding isEqualToString:@"base64"]) {
                     NSString *JSONString = [AMENUIDataManager base64Dencode:content];
                     NSDictionary *dictionary = [AMENUIDataManager dictionaryWithJsonString:JSONString];
                     if (dictionary) {
                         if (![DSBTFileHelp isExistsAtPath:filePath]) {
                             [DSBTFileHelp createFileAtPath:filePath];
                         }
                         [DSBTFileHelp asyncWriteFileAtPath:filePath content:[self JSONString:dictionary] complete:nil];
                         if (completeHandler) {
                             completeHandler(YES, dictionary);
                         }
                     } else {
                         if (completeHandler) {
                             completeHandler(NO, nil);
                         }
                     }
                 } else {
                     if (completeHandler) {
                         completeHandler(NO, nil);
                     }
                 }
             } else {
                 if (completeHandler) {
                     completeHandler(NO, nil);
                 }
             }
         } else {
             if (completeHandler) {
                 completeHandler(NO, nil);
             }
         }
     }];
 }




 #pragma mark - Private Method
 + (NSString *)cacheJSONDataFoldPath {
     if (![DSBTFileHelp isExistsAtPath:[[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold]]) {
         [DSBTFileHelp createDirectoryAtPath:[[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold]];
     }
     return [[DSBTFileHelp documentsDir] stringByAppendingPathComponent:kUIDataPageFold];
 }

 /// page
 + (NSString *)jsonCacheDataPath:(NSString *)fileName {
     if (!fileName || fileName.length <= 0) return @"";
     return [[self cacheJSONDataFoldPath] stringByAppendingPathComponent:fileName];
 }

 + (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
     if (jsonString == nil) {
         return nil;
     }
     NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     NSError *err;
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
     if(err) {
         NSLog(@"json解析失败：%@",err);
         return nil;

     }
     return dic;
 }

 + (NSString *)JSONString:(NSDictionary *)dict {
     if (dict && [dict isKindOfClass:[NSDictionary class]] && [NSJSONSerialization isValidJSONObject:dict]) {
         NSError *error;
         NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
         if (!error) {
             NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if (str.length) {
                 return str;
             }
         }
     }
     return @"";
 }

 + (NSString *)base64Encode:(NSString *)data{
     if (!data) {
         return nil;
     }
     NSData *sData = [data dataUsingEncoding:NSUTF8StringEncoding];
     NSData *base64Data = [sData base64EncodedDataWithOptions:0];
     NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
     return baseString;
 }
  
 + (NSString *)base64Dencode:(NSString *)data{
     if (!data) {
         return nil;
     }
     NSData *sData = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
     NSString *dataString = [[NSString alloc]initWithData:sData encoding:NSUTF8StringEncoding];
     return dataString;
 }

 @end

 */
