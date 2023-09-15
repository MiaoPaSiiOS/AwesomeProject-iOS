
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



#pragma mark - 裁剪
/// 裁剪图片中的一块区域
/// @param clipRect 裁剪区域
- (UIImage *)ds_imageClipRect:(CGRect)clipRect;

/// 图片裁剪
/// @param radius 圆角值
/// @param corners 圆角位置，可 | 多个圆角
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @param borderLineJoin 边界线相交类型
- (nullable UIImage *)ds_imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin;


- (nullable UIImage *)ds_imageByRoundCornerRadius:(CGFloat)radius;

/// 图片裁剪，默认全圆角
/// @param radius 圆角值
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (nullable UIImage *)ds_imageByRoundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;

/// 图片裁剪，默认圆形，长宽不同自动截取中间部分
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (nullable UIImage *)ds_circleImageByBorderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;

/// 拉伸图片
/// @param edgeInsets 不进行拉伸的区域
/// @param resizingMode 处理方式
- (UIImage *)ds_resizableImage:(UIEdgeInsets)edgeInsets resizingMode:(UIImageResizingMode)resizingMode;


/// 创建一个内容可拉伸，而边角不拉伸的图片，例如，leftCapHeight为6，topCapHeight为8。那么，图片左边的6个像素，上边的8个像素。不会被拉伸，而左边的第7个像素，上边的第9个像素这一块区域将会被拉伸。剩余的部分也不会被拉伸。***这个方法只能拉伸1x1的区域***
/// @param left 左边不拉伸区域的宽度
/// @param top 上面不拉伸的高度
- (UIImage *)ds_stretchableImage:(NSInteger)left top:(NSInteger)top;

/// 改变图片尺寸
/// @param newSize 新尺寸
/// @param isScale 是否按照比例转换
- (UIImage *)ds_imageChangeSize:(CGSize)newSize isScale:(BOOL)isScale;



#pragma mark - 颜色图片
+ (UIImage *)ds_imageWithColor:(UIColor *)color;

+ (UIImage *)ds_imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

#pragma mark - 生成渐变色的图片
/// 生成渐变色的UIImage
/// @param size 尺寸
/// @param colors 颜色数组
/// @param startP 开始坐标
/// @param endP 结束坐标
+ (UIImage *)ds_gradientColorImageWithSize:(CGSize)size andColors:(NSArray *)colors startPoint:(CGPoint)startP endPoint:(CGPoint)endP;


#pragma mark - 生成带圆角的颜色图片
/**
 生成带圆角的颜色图片

 @param tintColor 图片颜色
 @param targetSize 生成尺寸
 @param cornerRadius 圆角大小
 @param backgroundColor 背景颜色
 */
+ (UIImage *)ds_cornerRadiusImageWithColor:(UIColor *)tintColor targetSize:(CGSize)targetSize corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor;

/**
 生成矩形的颜色图片

 @param color 图片颜色
 @param targetSize 生成尺寸
 */
+ (UIImage *)ds_squareImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize;

/**
 生成带圆角的颜色图片,背景默认白色

 @param color 图片颜色
 @param targetSize 生成尺寸
 @param cornerRadius 圆角大小
 */
+ (UIImage *)ds_cornerRadiusImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize cornerRadius:(CGFloat)cornerRadius;


#pragma mark - 图片圆角处理
- (UIImage *)ds_circleImageWithRadius:(CGFloat)radius;
- (UIImage *)ds_circleImage;
- (UIImage *)ds_circleHDImage;




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





#pragma mark - Effect
/// 使用CoreImage技术使图片模糊
/// @param blurNum 模糊数值 0~100 （默认100）
- (UIImage *)ds_blurImageWithCoreImageBlurNumber:(CGFloat)blurNum;

/// 使用Accelerate技术模糊图片，模糊效果比CoreImage效果更美观，效率要比CoreImage要高，处理速度快
/// @param blurValue 模糊数值 0 ~ 1.0，默认0.1
- (UIImage *)ds_blurImageWithAccelerateBlurValue:(CGFloat)blurValue;

/// 高亮模糊
-(UIImage *)ds_applyLightEffect;

/// 轻度亮模糊
-(UIImage *)ds_applyExtraLightEffect;

/// 暗色模糊
-(UIImage *)ds_applyDarkEffect;

/// 自定义颜色模糊图片
/// @param tintColor 影响颜色
-(UIImage *)ds_applyTintEffectWithColor:(UIColor*)tintColor;

/// 模糊图片
/// @param blurRadius 模糊半径
/// @param tintColor 颜色
/// @param saturationDeltaFactor 饱和增量因子 0 图片色为黑白 小于0颜色反转 大于0颜色增深
/// @param maskImage 遮罩图像
-(UIImage*)ds_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage*)maskImage;



#pragma mark - 其他
/// 图像绘制block
/// @param size 尺寸
/// @param drawBlock 绘制回调
+ (nullable UIImage *)ds_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;



/**
 Create a square image from apple emoji.
 
 @discussion It creates a square image from apple emoji, image's scale is equal
 to current screen's scale. The original emoji image in `AppleColorEmoji` font
 is in size 160*160 px.
 
 @param emoji single emoji, such as @"😄".
 
 @param size  image's size.
 
 @return Image from emoji, or nil when an error occurs.
 */
+ (nullable UIImage *)imageWithEmoji:(NSString *)emoji size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
