//
//  IUFile.h
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUFile : NSObject

/**
 *  Type-A
 *  -------------------------------------
 *  'Hello world.mp3'
 *
 *  fileName           -- Hello world.mp3
 *  name               -- Hello world
 *  filenameExtension  -- mp3
 *
 *  Type-B
 *  -------------------------------------
 *  'configFile'
 *
 *  fileName           -- configFile
 *  name               -- configFile
 *  filenameExtension  -- nil
 */

/**
 *  Full file name.
 */
@property (nonatomic, strong) NSString  *fileName;

/**
 *  File name.
 */
@property (nonatomic, strong) NSString  *name;

/**
 *  File name extension.
 */
@property (nonatomic, strong) NSString  *filenameExtension;

/**
 *  Full file path.
 */
@property (nonatomic, strong) NSString  *filePath;

/**
 *  File url.
 */
@property (nonatomic, strong) NSURL     *fileUrl;

/**
 *  Is directory or not.
 */
@property (nonatomic) BOOL       isDirectory;

/**
 *  Is hiden file or not.
 */
@property (nonatomic) BOOL       isHiden;

/**
 *  File tree level.
 */
@property (nonatomic) NSInteger  level;

/**
 *  Attributes of the file.
 */
@property (nonatomic, strong) NSDictionary  *attributes;

/**
 *  Sub files.
 */
@property (nonatomic, strong) NSMutableArray  <IUFile *>  *subFiles;

/**
 *  All sub files.
 *
 *  @return Sub files array.
 */
- (NSArray <IUFile *> *)allFiles;
@end

