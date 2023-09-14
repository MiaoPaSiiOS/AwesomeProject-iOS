//
//  DSFile.m
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "DSFile.h"

@implementation DSFile

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.subFiles = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray <DSFile *> *)allFiles {
    
    NSMutableArray *subFiles = [NSMutableArray array];
    
    [self rootFile:self array:subFiles];
    
    return subFiles;
}

- (void)rootFile:(DSFile *)file array:(NSMutableArray *)array {
    
    for (DSFile *subFile in file.subFiles) {
        
        [array addObject:subFile];
        
        if (subFile.isDirectory) {
            
            [self rootFile:subFile array:array];
        }
    }
}

- (NSString *)description {

    return [NSString stringWithFormat:@"<%@ : %p> isDirectory[%@] isHiden[%@] %@",
            [self class],
            self,
            (_isDirectory == YES ? @"Y" : @"N"),
            (_isHiden == YES ? @"Y" : @"N"),
            _fileName];
}

@end
