//
//  RETools.h
//  LJDemo
//
//  Created by LJ on 15/7/20.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "AppDelegate.h"

@interface RETools : NSObject

#pragma mark  --------  字符串 --------------
/**
 *  判空
 *
 *  @param object 任意id类型
 *  @return BOOL值
 */
+ (BOOL)iSNull:(id)object;
+ (BOOL)iSNotNull:(id)object;

+ (BOOL)stringIsEmpty:(NSString*)str;

//+ (id)safeString:(id)object;

+ (NSString *)forceString:(id)txt;
///**
// *  获取文字高度
// *
// *  @param str        字符串
// *  @param fontSize   字号
// *  @param sizeWidth  文字需要展示的宽度
// *
// *  @return 大小
// */
//+ (CGSize)boundingRectWithStr:(NSString *)str font:(CGFloat)fontSize sizeWidth:(CGFloat)sizeWidth;
//
///**
// *  判断 输入长度
// *
// *  @param inputStr 输入的字符串
// *  @param typeStr  提示类型字符串
// *
// *  @return BOOL值
// */
//+ (BOOL) stringlength:(NSString *)inputStr typeStr:(NSString *)typeStr;
//
//
///**
// *   获取当前应用版本号
// *
// *   return  当前版本号
// */
//+ (NSString *)getCFBundleVersion;
//
///**
// *   获取字符串形式的文件大小
// *
// *   return  文件大小
// */
//+ (NSString *)getFile;
//
///**
// *   OC对象转json字符串
// *
// *   param  obj     OC对象(此对象可以是数组或者字典)
// */
//+ (NSString *)generateJsonString:(id)obj;
//
///**
// *  json字符串转成OC对象
// */
//+ (id)objectWithJsonString:(NSString *)jsonString;
//
//
//
//+(NSMutableAttributedString *)settingAttributeString:(NSRange)rang
//                                            withText:(NSString *)text
//                                   withAttributeName:(NSString *)name
//                                               value:(id)value;
//
//+(NSMutableAttributedString *)settingAttributeString:(NSRange)rang
//                                            withText:(NSString *)text
//                                   withAttributeName:(NSString *)name
//                                               value:(id)value
//                                          valueColor:(UIColor *)valueColor;
//+(NSMutableAttributedString *)settingAttributeString1:(NSRange)rang
//                                             withrang:(NSRange)rang1
//                                             withText:(NSString *)text
//                                    withAttributeName:(NSString *)name
//                                                value:(id)value;
//
//
//#pragma mark  --------  验证 --------------
///**
// *  判断是非是无效的密码。
// *
// *  @param password 字符串
// *
// *  @return BOOL值
// *          YES: 无效密码。
// *           NO: 有效密码。
// */
//+ (BOOL)isInvalidPassword:(NSString *)password;
///**
//    判断是否密码有效
// */
//+ (BOOL)isEffectivePassword:(NSString *)password;
///**
// *  验证固定电话格式。
// */
//+ (BOOL)isValidateTelephone:(NSString *)telephone;
//
///**
// *  检测 输入中是否含有特殊字符
// *
// *  @param str 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)hasSpecialCharacter:(NSString *)str;
//
///**
// *  是否是纯数字判断
// *
// *  @param number 字符串
// *
// *  @return BOOL值
// */
//+(BOOL)checkNumber:(NSString *)number;
//
///**
// *  用户名判断
// *
// *  @param nameStr 字符串
// *
// *  @return BOOl值
// */
//+ (BOOL)checkNameString:(NSString *)nameStr;
//
///**
// *  密码判断
// *
// *  @param PassStr 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)checkPassString:(NSString *)PassStr;
//
/**
 *  手机号码验证
 *
 *  @param mobile 字符串
 *
 *  @return BOOL值
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;
//
///**
// *  验证码验证
// *
// *  @param code 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)validateVCodeWithString:(NSString*)code;
//
///**
// *  邮箱验证
// *
// *  @param email 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)isValidateEmail:(NSString *)email;
//
///**
// *  车牌号验证
// *
// *  @param carNo 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL) validateCarNo:(NSString *)carNo;
//
///**
// *  检测 输入中是否含有特殊字符
// *
// *  @param str 字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)isIncludeSpecialCharact: (NSString *)str;
//
////+ (BOOL)ishasPrefixForURL:(NSString *)string;
//
///**
// *  身份证号验证
// *
// *  @param identityCard 身份证字符串
// *
// *  @return BOOL值
// */
//+ (BOOL)validateIdentityCard: (NSString *)identityCard;
//
///**
//*  url合法校验
//*
//*  @param identityUrl url
//*
//*  @return BOOL值
//*/
//+ (BOOL)validateUrl: (NSString *) identityUrl;
//
//#pragma mark -----   屏幕设备相关 ----------
///**
// *  获取设备型号
// *
// *  @return 设备型号
// */
//+ (NSString*)getDeviceName;
////获取操作系统
//+ (NSString *)getLocalOS;
////获取操作系统版本
//+ (NSString *)getDeviceVersion;
////获取app版本号
//+ (NSString *)getAppVersion;
////获取设备唯一标识
//+ (NSString *)getAppGuid;
//+ (NSString *)getCurrentTimeLong;
////获取频幕尺寸
//+ (NSString *)getScreenSize;
//+ (NSString *)uniqueDeviceIdentifier;
////获取网络连接类型
//+ (NSString *)getNetWorkType;
////获取运营商code
//+ (NSString *)getNetWorkOperator;
////获取设备当前网络IP地址
//+ (NSString *)getIPAddress;
///**
// *  获取屏幕分辨率
// *
// *  @return 屏幕分辨率
// */
//+ (NSString *)getScreenScrale;
///**
// *  获取屏幕宽比例
// *
// *  @return 屏幕宽比例
// */
//+(CGFloat)getScreenWidthscale;
///**
// *  获取屏幕高比例
// *
// *  @return 屏幕高比例
// */
//+(CGFloat)getScreenHightscale;
//
//
//
//#pragma mark --------  字典  ---------------
///**
// *  字符串拆分
// *
// *  @param dict 字符串
// *
// *  @return 字典
// */
//+ (NSDictionary *)getStringWithDict:(NSDictionary *)dict;
///**
// *  字符串转 字典
// *
// *  @param str 字符串
// *
// *  @return 字典
// */
//+(NSDictionary *)stringToDict:(NSString *)str;
//
///**
// *  获取沙盒目录
// */
//+ (NSString *)applicationDocumentsDirectory;
//
///**
// *  获得 文件的大小
// *
// *  @param filePath 文件夹路径字符串
// *
// *  @return 文件大小
// */
//+ (CGFloat) fileSizeAtPath:(NSString*) filePath;
//
///**
// *  取消 模糊背景
// */
//+(void)removeGause:(UIView *)supperView;
//
///**
// *  清楚缓存
// */
//+(void)clearCache;
//
///**
// *  缓存清除成功
// */
//+(void)clearCacheSuccess;
///**
// *
// * 显示提示框
// *
// */
//+(void)showMyMessage:(NSString*)aInfo;
//
//// 扁平json字串。
//+ (NSString *)flatJsonString:(id)obj;
//
//#pragma mark ------------ 动画 -----------
//
///**
// * 在具体的UIView上实现一个缩放的动画
// *@param   view         动画的载体
// *@param   scaleValue   最终缩放值
// *@param   repeat       动画循环次数，0表示无限循环
// *@param   duration     动画运行一次的时间
// */
//+ (void)showScaleAnimationInView:(UIView *)view ScaleValue:(CGFloat)scaleValue Repeat:(CGFloat)repeat Duration:(CGFloat)duration;
//
///**
// *清除具体UIView上的所有动画
// *@param   view   实施清除的对象
// */
//+ (void)clearAnimationInView:(UIView *)view;
//
//
///**
// *  获取通讯录权限
// */
////+ (void)queryAddressBookAuthorization:(void (^)(bool isAuthorized))block;
//
////从内存中递归清除指定视图
//+ (void)recursionView:(UIView *)view;
//
////将十六进制的字符串转换成NSString则可使用如下方式:
//+ (NSString *)convertHexStrToString:(NSString *)str;
//
////将NSString转换成十六进制的字符串则可使用如下方式:
//+ (NSString *)convertStringToHexStr:(NSString *)str;
////白名单
//+ (BOOL)whiteList:(NSString *)str;
//
//#pragma mark ----- image  ----------
//
///**
// *  图片旋转
// *
// *  @param imageView 图片
// *
// *  @return 可旋转的图片
// */
//+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;
//
///**
// *  停止图片旋转
// */
//+ (void)stopRound:(UIView *)view;
///**
// *   获得某个范围内的屏幕图像
// *
// *  @param view  截图的View
// *  @param frame 截图区域大小
// *
// *  @return 截取的图片
// */
//+ (UIImage *)imageFromView:(UIView *)view frame:(CGRect)frame;
//
///**
// *  高斯模糊
// *
// *  @param image 图片
// *
// *  @return 模糊的图片
// */
//+ (UIImage *)gauseImgWithImage:(UIImage *)image;
///**
// *  动态改变图片大小
// *
// *  @param image 传进来的初始图片
// *  @param size  图片比例
// *
// *  @return 图片
// */
//+(UIImage *) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
//
///**
// *  将图片压缩到指定比例
// */
////压缩图片
//+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
///**
// *  剪裁图片
// */
//+ (UIImage *)cutImage:(UIImage*)image headViewHeight:(CGFloat)headViewHeight;
//
///**
// *  改变图片 只拉伸中间点
// *
// *  @param size 拉伸尺寸
// *
// *  @return 拉伸尺寸
// */
//+(UIEdgeInsets)resizeDetail:(CGSize)size;
//
//
///**
// *  从金山云获取指定比例的图片
// *
// *  @param scale 总 大小
// *  @param urlStr 字符串
// *
// *  @return 大小
// */
//+ (NSString *)getTheImgWithScale:(NSInteger)scale withUrlStr:(NSString *)urlStr;
//
//
///**
// *  获取网络图片尺寸
// */
//+ (CGSize)getImageSizeWithURL:(id)imageURL;
//
//
///**
// *  将相册中选中的图片，进行压缩 按图片比例压缩
// */
//+ (UIImage *)handlePhotoLibraryWithOriginalImage:(UIImage *)originalImage;
///**
// 传入需要的占位图尺寸 获取占位图
//
// @param size 需要的站位图尺寸
// @return 占位图
// */
//+ (UIImage *)placeholderImageWithSize:(CGSize)size;
//
///**
// *  剪切图片为正方形
// *
// *  @param image   原始图片
// *  @param newSize 正方形的size
// *
// *  @return 返回正方形图片
// */
//+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
//
//#pragma mark --------  URL 处理 ---------------
///**
// *  删除请求图片字符串中的空格并压缩比例
// *
// *  @param spaceStr 传入的字符串
// *
// *  @param scale 传入的比例参数
// *
// *  @return 返回的没有空格的url
// */
//+ (NSURL *)removeSpace:(NSString *)spaceStr scale:(NSInteger)scale;
//
///**
// *  删除请求图片字符串中的空格
// *
// *  @param spaceStr 传入的字符串
// *
// *  @return 返回的没有空格的url
// */
//+ (NSURL *)removeSpace:(NSString *)spaceStr;
//
+ (NSURL *)urlFromString:(NSString *)string;
//
//#pragma mark --------  时间 ---------------
///**
// *  获取系统时间
// *
// *  @return 系统时间
// */
//+ (NSString *)getSystemtime;
//
//
///**
// 获取系统时间
//
// @return 时间戳
// */
//+ (NSString *)getSystemTimeStamp;
//
////当前时间戳(毫秒）
//+ (NSString *)getNowTimeTimestamp;
//
///**
// *  获取当前日期
// *
// *  @return 日期
// */
//+ (NSString *)getNowDate;
//
///**
// *  获取当前年份
// *
// *  @return 年份
// */
//+ (NSString *)getNowYear;
//
///**
// *  获取当前月份
// *
// *  @return 月份
// */
//+ (NSString *)getNowMonth;
//
//
//
///**
// *  字符串转时间格式
// *
// *  @param timeStr 时间戳字符串
// *
// *  @return  格式化过的时间
// */
//+ (NSString *)stringTransformToTime:(NSString *)timeStr;
//
//+ (NSString *)stringTransformToTimeTwo:(NSString *)timeStr;
//
//+ (NSString *)stringTransformToTimeThree:(NSString *)timeStr;
//
///**
// *  时间转字符串
// *
// *  @param string NSData类型
// *
// *  @return 时间戳
// */
//+(NSString *)timeTransformToString:(NSDate *)string;
//
///**
// 8小时
// */
//+ (NSString *)timeString:(NSDate *)date;
//
///**
// 字符串转时间
// */
//+ (NSDate *)timeFromString:(NSString *)string;
///**
// *  根据传入时间格式将字符串转时间格式
// *
// *  @param timeStr 时间戳字符串
// *
// *  @return  格式化过的时间
// */
//+ (NSString *)stringTransformToTime:(NSString *)timeStr byFixFormatter:(NSDateFormatter *)formatter;
//
//+ (NSString *)stringTransformToTimeTwo:(NSString *)timeStr withFormat:(NSString *)format;
//#pragma mark -  时间戳转为不同的格式
//+(NSString *) dateToTime:(NSString *) timeStampString andforDate:(NSString  *) format;
//
//// 获取多少小时多少秒
//+ (NSString *)getTimeStringWithSecond:(NSInteger)seconds;
//
//+ (NSString *)stringTransformToTimeFour:(NSString *)timeStr;
//
///**
// 获取url中的参数并返回
// @param urlString 带参数的url
// @return NSDictionary:参数字典
// */
//
//+ (NSDictionary*)getParamsWithUrlString:(NSString*)urlString ;
//
//
//#pragma mark -- 对象转 NSDictionary
//+ (NSDictionary*)getObjectData:(id)obj;
//
//
////获取appIconName
//+(NSString*)getAppIconName;
//
//#pragma mark 判断字符串是否为浮点数
//+ (BOOL)isPureFloat:(NSString*)string;
//#pragma mark 判断是否为整形
//+ (BOOL)isPureInt:(NSString*)string;

@end
