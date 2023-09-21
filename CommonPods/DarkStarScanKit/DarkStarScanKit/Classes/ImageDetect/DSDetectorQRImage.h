//
//  DSDetectorQRImage.h
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NrDetectorImageHandle)(NSString *message);

@interface DSDetectorQRImage : NSObject

/**
 *   image 需要识别的图片
 *   NrDetectorImageHandle 识别回调,如果识别失败回调结果是@""，这里在当前线程回调，即在那个线程调用就在哪个线程返回
 */
+ (void)detectorImage:(UIImage *)image withHandle:(NrDetectorImageHandle)handle;

@end

NS_ASSUME_NONNULL_END
