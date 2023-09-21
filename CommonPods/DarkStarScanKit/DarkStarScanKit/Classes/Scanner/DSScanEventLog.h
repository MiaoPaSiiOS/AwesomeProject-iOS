//
//  DSScanEventLog.h
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, DSScanEventLogType) {
    DSScanEventLogTypeScan, // 扫码
    DSScanEventLogTypeDetector, // 图片识别
};
NS_ASSUME_NONNULL_BEGIN

@interface DSScanEventLog : NSObject
/**
 扫码埋点
 
 @param type 扫码类型
 @param subType 暂时没用
 @param dict 自定义参数
 @param desc 描述
 */
+ (void)scanLogWithType:(DSScanEventLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
