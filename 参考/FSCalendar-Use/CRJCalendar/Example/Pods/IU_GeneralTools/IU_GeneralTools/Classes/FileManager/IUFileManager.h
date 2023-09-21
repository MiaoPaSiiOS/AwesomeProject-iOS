//
//  IUFileManager.h
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUFile.h"

@interface IUFileManager : NSObject

/**
 *  Get the file at the related file path.
 *
 *  @param relativeFilePath Relative file path, "~" means sandbox root, "-" means bundle file root.
 *  @param maxTreeLevel     Scan level.
 *
 *  @return File.
 */
+ (IUFile *)scanRelativeFilePath:(NSString *)relativeFilePath maxTreeLevel:(NSInteger)maxTreeLevel;

/**
 *  Transform related file path to real file path.
 *
 *  @param relativeFilePath Relative file path, "~" means sandbox root, "-" means bundle file root.
 *
 *  @return The real file path.
 */
+ (NSString *)absoluteFilePathFromRelativeFilePath:(NSString *)relativeFilePath;

/**
 *  Get the bundle file path by the bundle file name.
 *
 *  @param name Bundle file name.
 *
 *  @return Bundle file path.
 */
+ (NSString *)bundleFileWithName:(NSString *)name;

/**
 *  To check the file at the given file path exist or not.
 *
 *  @param absoluteFilePath The real file path.
 *
 *  @return Exist or not.
 */
+ (BOOL)fileExistWithAbsoluteFilePath:(NSString *)absoluteFilePath;

@end

/**
 *  Transform related file path to real file path.
 *
 *  @param relativeFilePath Relative file path, "~" means sandbox root, "-" means bundle file root.
 *
 *  @return The real file path.
 */
NS_INLINE NSString *CRJAbsoluteFilePathFrom(NSString * relativeFilePath) {
    
    return [IUFileManager absoluteFilePathFromRelativeFilePath:relativeFilePath];
}
