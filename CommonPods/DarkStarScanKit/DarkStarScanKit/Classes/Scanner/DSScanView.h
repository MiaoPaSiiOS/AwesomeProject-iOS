//
//  DSScanView.h
//  NrScanKit
//
//  Created by zhuyuhui on 2021/11/18.
//

#import <UIKit/UIKit.h>

#import "DSScanner.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^DSScanViewResult)(NSString *result);


@interface DSScanView : UIView


/**
 可自定义的蒙版View，可在上面添加自定义控件,也可以改变背景颜色，透明度
 默认为70%透明度黑色，遮盖区域依赖scanRect,需先指定scanRect，否则为默认
 */
@property (nonatomic, strong) UIView *maskView;

// 扫描框背景图片
@property (nonatomic, strong) UIImageView *middleIcon;
@property (nonatomic, strong) UIImageView *scanLine;
@property (nonatomic, strong) UILabel *infolabel;

/**
 是否显示上下移动的扫描线，默认为YES
 */
@property (nonatomic, assign, getter=isShowScanLine) BOOL showScanLine;

/// 扫码识别结果  !!!子线程回调，如果更新UI需要回到主线程!!!
@property (nonatomic, copy) DSScanViewResult resultBlock;

/// 扫码类型 默认 DSScannerTypeQRCode
@property (nonatomic, assign, readonly) DSScannerType scannerType;


/**
 scanRect 识别 区域
 scanTime 扫描线动画一次时间
 scanLineHeight 扫描线高度
 type 扫码类型
 */
- (instancetype)initWithFrame:(CGRect)frame
                 withScanRect:(CGRect)scanRect
                 withScanTime:(CGFloat)scanTime
            withScanLineHeight:(CGFloat)scanLineHeight
                     withType:(DSScannerType)type;

/**
 scanTime 默认 3 秒
 scanLineHeight 扫描线高度 默认11
 type 扫码类型

 
 二维码:
 type == DSScannerTypeQRCode
 scanRect 默认 宽高 265 ，位置view中心点
 
 条形码：
 type == DSScannerTypeBarCode
 scanRect 默认 宽 265  高 132，位置view中心点

 二维码&条形码：
 type == DSScannerTypeAllCode
 scanRect 默认 宽高 265 ，位置view中心点

 
 */
- (instancetype)initWithFrame:(CGRect)frame
                     withType:(DSScannerType)type;

/**
 10004  未实现代理
 10003  代理返回数据错误
 10002  正在识别中
 10001  相机不支持或者没有相机权限
 */
- (NSError *)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
