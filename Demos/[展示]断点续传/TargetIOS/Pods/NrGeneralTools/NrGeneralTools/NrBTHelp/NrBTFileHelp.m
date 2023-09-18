//
//  NrBTFileHelp.m
//  NrDataStoreFramework
//
//  Created by zhuyuhui on 2021/11/5.
//

#import "NrBTFileHelp.h"

@interface NrBTFileHelp()

@end


@implementation NrBTFileHelp

#pragma mark - 沙盒目录相关
+ (nullable NSString *)homeDir {
    return NSHomeDirectory();
}

+ (nullable NSString *)documentsDir {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (nullable NSString *)libraryDir {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];;
}

+ (nullable NSString *)preferencesDir {
    NSString *libraryDir = [self libraryDir];
    return [libraryDir stringByAppendingPathComponent:@"Preferences"];
}

+ (nullable NSString *)cachesDir {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (nullable NSString *)tmpDir {
    return NSTemporaryDirectory();
}
#pragma mark - 遍历文件夹
+ (nullable NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

+ (nullable NSArray *)listFilesInHomeDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self homeDir] deep:deep];
}

+ (nullable NSArray *)listFilesInLibraryDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self libraryDir] deep:deep];
}

+ (nullable NSArray *)listFilesInDocumentDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self documentsDir] deep:deep];
}

+ (nullable NSArray *)listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self tmpDir] deep:deep];
}

+ (nullable NSArray *)listFilesInCachesDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self cachesDir] deep:deep];
}

#pragma mark - 获取文件属性
+ (nullable id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key {
    return [[self attributesOfItemAtPath:path] objectForKey:key];
}

+ (nullable NSDictionary *)attributesOfItemAtPath:(NSString *)path{
    NSError *error;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"获取文件属性集合：Error:\n%@",error);
    }
    return attr;
}

#pragma mark - 创建文件(夹)
+ (BOOL)createDirectoryAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"创建文件(夹)：Error:\n%@",error);
    }
    return isSuccess;
}

+ (void)asyncCreateDirectoryAtPath:(NSString *)path
                          complete:(void(^_Nullable)(BOOL success))complete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [self createDirectoryAtPath:path];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isSuccess);
            });
        }
    });
}

+ (BOOL)createFileAtPath:(NSString *)path {
    return [self createFileAtPath:path content:nil overwrite:YES];
}

+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:nil overwrite:overwrite];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(id _Nullable)content {
    return [self createFileAtPath:path content:content overwrite:YES];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(id _Nullable)content overwrite:(BOOL)overwrite {
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *directoryPath = [self directoryAtPath:path];//根据path获取所在文件夹
    if (![self isExistsAtPath:directoryPath]) {
        // 创建文件夹
        if (![self createDirectoryAtPath:directoryPath]) {
            return NO;
        }
    }
    // 如果文件存在，并不想覆盖，那么直接返回YES。
    if (!overwrite) {
        if ([self isExistsAtPath:path]) {
            return YES;
        }
    }
    // 创建文件
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (content) {
        [self syncSaveFile:content path:path name:nil encrypt:NO];
    }
    return isSuccess;
}

+ (void)asyncCreateFileAtPath:(NSString *)path
                      content:(id _Nullable)content
                    overwrite:(BOOL)overwrite
                     complete:(void(^_Nullable)(BOOL success))complete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [self createFileAtPath:path content:content overwrite:overwrite];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isSuccess);
            });
        }
    });
}

+ (NSDate *)creationDateOfItemAtPath:(NSString *)path {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate];;
}

+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileModificationDate];
}

#pragma mark - 删除文件(夹)
+ (BOOL)removeItemAtPath:(NSString *)path {
    if (![self isExistsAtPath:path]) {
        NSLog(@"删除文件(夹)：文件不存在%@",path);
        return YES;
    }
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"删除文件(夹)：Error:\n%@",error);
    }
    return isSuccess;
}

+ (void)asyncRemoveItemAtPath:(NSString *)path
                     complete:(void(^_Nullable)(BOOL success))complete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [self removeItemAtPath:path];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isSuccess);
            });
        }
    });
}

+ (BOOL)clearCachesDirectory {
    NSArray *subFiles = [self listFilesInCachesDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self cachesDir] stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

+ (BOOL)clearTmpDirectory {
    NSArray *subFiles = [self listFilesInTmpDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self tmpDir] stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

#pragma mark - 复制文件(夹)
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self copyItemAtPath:path toPath:toPath overwrite:NO];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建复制路径
        if (![self createDirectoryAtPath:toDirPath]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [self removeItemAtPath:toPath];
        }
    }
    // 复制文件
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:&error];
    if (error) {
        NSLog(@"复制文件(夹)：Error:\n%@",error);
    }
    return isSuccess;
}

+ (void)asyncCopyItemAtPath:(NSString *)path
                     toPath:(NSString *)toPath
                  overwrite:(BOOL)overwrite
                   complete:(void(^_Nullable)(BOOL success))complete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         BOOL isSuccess = [self copyItemAtPath:path toPath:toPath overwrite:overwrite];
         if (complete) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 complete(isSuccess);
             });
         }
    });
}

#pragma mark - 移动文件(夹)
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self moveItemAtPath:path toPath:toPath overwrite:NO];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建移动路径
        if (![self createDirectoryAtPath:toDirPath]) {
            return NO;
        }
    }
    // 如果覆盖，那么先删掉原文件
    if ([self isExistsAtPath:toPath]) {
        if (overwrite) {
            [self removeItemAtPath:toPath];
        }else {
            [self removeItemAtPath:path];
            return YES;
        }
    }
    
    // 移动文件
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:&error];
    if (error) {
        NSLog(@"移动文件(夹)：Error:\n%@",error);
    }
    return isSuccess;
}

+ (void)asyncMoveItemAtPath:(NSString *)path
                     toPath:(NSString *)toPath
                  overwrite:(BOOL)overwrite
                   complete:(void(^_Nullable)(BOOL success))complete {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [self moveItemAtPath:path toPath:toPath overwrite:overwrite];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isSuccess);
            });
        }
    });
}

#pragma mark - 根据URL获取文件名
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix {
    NSString *fileName = [path lastPathComponent];
    if (!suffix) {
        fileName = [fileName stringByDeletingPathExtension];
    }
    return fileName;
}

+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

+ (NSString *)suffixAtPath:(NSString *)path {
    return [path pathExtension];
}

#pragma mark - 判断文件(夹)是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)isEmptyItemAtPath:(NSString *)path {
    return ([self isFileAtPath:path] && [[self sizeOfItemAtPath:path] intValue] == 0) ||
    ([self isDirectoryAtPath:path] && [[self listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}

+ (BOOL)isDirectoryAtPath:(NSString *)path {
    return ([self attributeOfItemAtPath:path forKey:NSFileType] == NSFileTypeDirectory);
}

+ (BOOL)isFileAtPath:(NSString *)path {
    return ([self attributeOfItemAtPath:path forKey:NSFileType] == NSFileTypeRegular);
}

+ (BOOL)isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

+ (BOOL)isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}
+ (BOOL)isWritableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

#pragma mark - 获取文件(夹)大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path {
    return (NSNumber *)[self attributeOfItemAtPath:path forKey:NSFileSize];
}

+ (NSNumber *)sizeOfFileAtPath:(NSString *)path {
    if ([self isFileAtPath:path]) {
        return [self sizeOfItemAtPath:path];
    }
    return nil;
}

+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path {
    if ([self isDirectoryAtPath:path]) {
        NSNumber *size = [self sizeOfItemAtPath:path];
        double sizeValue = [size doubleValue];
        
        NSArray *subPaths = [self listFilesInDirectoryAtPath:path deep:YES];
        for (NSUInteger i = 0; i < subPaths.count; i++) {
            NSString *subPath = [subPaths objectAtIndex:i];
            NSNumber *subPathSize = [self sizeOfItemAtPath:subPath];
            sizeValue += [subPathSize doubleValue];
        }
        return [NSNumber numberWithDouble:sizeValue];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path {
    NSNumber *size = [self sizeOfItemAtPath:path];
    if (!size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path {
    NSNumber *size = [self sizeOfFileAtPath:path];
    if (!size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path {
    NSNumber *size = [self sizeOfDirectoryAtPath:path];
    if (!size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

#pragma mark - 写入文件内容
/**
 同步存储文件
 
 @param content 文件内容, 支持基本数据类型, 字符串、数组、字典
 @param path 文件存储位置
 @param name 文件名称
 @param encrypt 是否加密
 @return 是否成功存储
 */
+ (BOOL)syncSaveFile:(nullable id)content
                path:(nullable NSString *)path
                name:(nullable NSString *)name encrypt:(BOOL)encrypt;
{
    NSMutableDictionary *parmers = [NSMutableDictionary dictionary];
    [parmers setValue:content forKey:@"content"];
    return [parmers writeToFile:path atomically:YES];;
}

/**
 异步存储文件
 
 @param content 文件内容, 支持基本数据类型, 字符串、数组、字典
 @param path 文件存储位置
 @param name 文件名称
 @param encrypt 是否加密
 @param complete 是否成功存储的回调
 */
+ (void)asyncSaveFile:(nullable id)content
                 path:(nullable NSString *)path
                 name:(nullable NSString *)name
              encrypt:(BOOL)encrypt
             complete:(void(^ _Nullable)(BOOL success))complete;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [self syncSaveFile:content path:path name:name encrypt:encrypt];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isSuccess);
            });
        }
    });
}

#pragma mark - 获取文件内容
/**
 同步获取存储的文件内容
 
 @param path 文件路径
 @param name 文件名称
 @return 文件内容
 */
+ (nullable id)syncFetchFile:(nullable NSString *)path name:(nullable NSString *)name;
{
    if (![self isExistsAtPath:path]) {
        return nil;
    }
    NSMutableDictionary *parmers = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    id content = parmers[@"content"];
    return content;
}


/**
 异步获取存储的文件内容
 
 @param path 文件路径
 @param name 文件名称
 @param complete 文件内容回调
 */
+ (void)asyncFetchFile:(nullable NSString *)path
                  name:(nullable NSString *)name
              complete:(void(^ _Nullable)(id _Nullable content))complete;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id content = [self syncFetchFile:path name:name];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(content);
            });
        }
    });
}




#pragma mark - private methods
+ (BOOL)isNotError:(NSError **)error {
    return ((error == nil) || ((*error) == nil));
}

+(NSString *)sizeFormatted:(NSNumber *)size {
    double convertedValue = [size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes", @"KB", @"MB", @"GB", @"TB"];
    
    while(convertedValue > 1024){
        convertedValue /= 1024;
        
        multiplyFactor++;
    }
    
    NSString *sizeFormat = ((multiplyFactor > 1) ? @"%4.2f %@" : @"%4.0f %@");
    
    return [NSString stringWithFormat:sizeFormat, convertedValue, tokens[multiplyFactor]];
}
@end
