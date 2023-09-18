//
//  HWGlobeConst.h
//  HWProject
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 wangqibin. All rights reserved.
//
#import "HWToolBox.h"


#ifdef DEBUG
#define HWLog(format, ...) printf("[%s] %s [第%d行] %s\n", [[HWToolBox currentTimeCorrectToMillisecond] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define HWLog(format, ...)
#endif
