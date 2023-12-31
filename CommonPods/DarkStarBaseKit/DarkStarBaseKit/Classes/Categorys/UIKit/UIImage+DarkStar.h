
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DarkStar)

@property (nonatomic,readonly) BOOL ds_hasAlphaChannel; // 图片是否有透明
@property (nonatomic, readonly) NSString *ds_base64String; // 转换图片为png格式的base64编码


/// 更新图片的方向，直立显示
- (UIImage *)ds_updateImageOrientation;

/// 返回一个旋转图像
/// @param radians 逆时针旋转弧度
/// @param fitSize true：扩展新图像的大小以适合所有内容。false：图像的大小不会改变，内容可能会被剪切。
- (nullable UIImage *)ds_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/// 压缩图片（压缩质量）压缩图片质量的优点在于，尽可能保留图片清晰度，图片不会明显模糊；缺点在于，不能保证图片压缩后小于指定大小。
/// @param maxSize 图片大小 需要32kb直接传入32即可
- (NSData *)ds_compressImageDataDichotomyWith:(int)maxSize;

/// 压缩图片(压缩大小) 压缩后图片明显比压缩质量模糊
/// @param maxSize 图片大小 需要32kb直接传入32即可
- (NSData *)ds_compressImageDataWith:(int)maxSize;

/// 压缩图片(两种方法结合)
/// @param maxSize 图片大小 需要32kb直接传入32即可
- (NSData *)ds_compressImageCombineWith:(int)maxSize;

/// 拼接长图
/// @param headImage 头图
/// @param footImage 尾图
/// @param masterImgArr 主视图数组
/// @param edgeMargin 四周边距
/// @param imageSpace 图片间距
/// @param success 成功回调
+ (void)ds_generateLongPictureWithHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage masterImages:(NSArray <UIImage *>*)masterImgArr edgeMargin:(UIEdgeInsets)edgeMargin imageSpace:(CGFloat)imageSpace success:(void(^)(UIImage *longImage,CGFloat totalHeight))success;

/// 根据图片url获取网络图片尺寸
+ (CGSize)ds_getImageSizeWithURL:(id)URL;

/// 使用GIF数据创建动画图像。 创建后，可以通过属性“ .images”访问图像。 如果数据不是动态gif，则此功能与[UIImage imageWithData：data scale：scale]相同；
/// @param data gif 数据
/// @param scale 比例
+ (nullable UIImage *)ds_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

/// 数据是否为GIF动画。
/// @param data 数据
+ (BOOL)ds_isAnimatedGIFData:(NSData *)data;

/// 文件路径数据是否为GIF动画。
/// @param path 路径
+ (BOOL)ds_isAnimatedGIFFile:(NSString *)path;

/// 从PDF文件数据或路径创建图像。如果PDF有多页，则仅返回第一页的内容。 图像的比例等于当前屏幕的比例，尺寸与PDF的原始尺寸相同。
/// @param dataOrPath 数据或者路径
+ (nullable UIImage *)ds_imageWithPDF:(id)dataOrPath;

/// 从PDF文件数据或路径创建图像。如果PDF有多页，则仅返回第一页的内容。 图像的比例等于当前屏幕的比例，尺寸与PDF的原始尺寸相同。
/// @param dataOrPath 数据或者路径
/// @param size 尺寸
+ (nullable UIImage *)ds_imageWithPDF:(id)dataOrPath size:(CGSize)size;





#pragma mark - QRCode
/// 生成二维码
/// @param content 内容
/// @param outputSize 生成尺寸
/// @param tintColor 颜色，设置颜色时背景会变为透明
/// @param logo logo图
/// @param logoFrame logo位置
/// @param isHighLevel 是否高清，设置颜色和logo默认高清
+ (UIImage *)ds_qrHUDImageByContent:(NSString *)content outputSize:(CGFloat)outputSize tintColor:(nullable UIColor *)tintColor logo:(nullable UIImage *)logo logoFrame:(CGRect)logoFrame isCorrectionHighLevel:(BOOL)isHighLevel;

/// 生成高清二维码图片（默认大小为430*430）
/// @param content 内容
+ (UIImage *)ds_qrImageByContent:(NSString *)content;

/// 生成高清二维码
/// @param content 内容
/// @param outputSize 输出尺寸
+ (UIImage *)ds_qrHUDImageByContent:(NSString *)content outputSize:(CGFloat)outputSize;

/// 生成高清二维码
/// @param content 内容
/// @param outputSize 输出尺寸
/// @param color 颜色
+ (UIImage *)ds_qrImageByContent:(NSString *)content outputSize:(CGFloat)outputSize color:(nullable UIColor *)color;

/// 生成高清二维码
/// @param content 内容
/// @param logo logo，默认放在中间位置
+ (UIImage *)ds_qrImageWithContent:(NSString *)content outputSize:(CGFloat)outputSize logo:(nullable UIImage *)logo;

/**
 获取二维码内内容
 */
- (NSString *)ds_getQRCodeContentString;




@end

NS_ASSUME_NONNULL_END
