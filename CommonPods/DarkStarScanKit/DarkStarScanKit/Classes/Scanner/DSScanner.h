//
//  DSScanner.h
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef enum : NSUInteger {
    DSScannerTypeQRCode,
    DSScannerTypeBarCode,
    DSScannerTypeAllCode,
} DSScannerType;
NS_ASSUME_NONNULL_BEGIN

@protocol DSScannerDelegate <NSObject>

@required
/// **必须实现**
/// 返回识别范围
- (CGRect)dsScannerRectOfInterest;

/// 返回扫码的预览view, view需要 设置过size
- (UIView *)dsScannerPreviewView;

@optional

/// 扫码结果  !!!子线程回调，如果更新UI需要回到主线程!!!
- (void)dsScannerResult:(NSString * _Nullable)result withSuccess:(BOOL)isSuccess;


@end


@interface DSScanner : NSObject
- (instancetype)initWithDelegate:(id <DSScannerDelegate>)delegate;

/// 扫码类型 默认 DSScannerTypeQRCode
@property (nonatomic, assign) DSScannerType typeCode;
@property (nonatomic, assign, readonly) CGRect scanRect;
@property (nonatomic, weak) id <DSScannerDelegate> delegate;

/**
 10004  未实现代理
 10003  代理返回数据错误
 10002  正在识别中
 10001  相机不支持或者没有相机权限
 */
- (nullable NSError *)startScanner;
- (void)stopScanner;

@end

NS_ASSUME_NONNULL_END
