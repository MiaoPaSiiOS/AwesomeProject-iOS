
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DSAudioRecorderStatus) {
    DSAudioRecorderStatusInitFailure,      /// 初始化失败
    DSAudioRecorderStatusNoApplyAuthority, /// 未申请麦克风权限
    DSAudioRecorderStatusNoAuthorized,     /// 无麦克风权限
    DSAudioRecorderStatusSuccess,          /// 录音成功
    DSAudioRecorderStatusFailure           /// 录音失败
};

typedef void (^AudioRecordCompleteHandler) (DSAudioRecorderStatus status, NSData * _Nullable data);
typedef void (^RecorderPower) (float power);

@interface DSAudioRecorder : NSObject

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

/** 初始化方法
* 可以使用 init 方法初始化, 使用默认的录音设置
* 使用此方法初始化使用使用默认的录音设置
* @param completeHandler 完成后的回调
*/
- (nullable instancetype)initWithCompleteHandler:(nonnull AudioRecordCompleteHandler)completeHandler;
+ (nullable instancetype)audioRecorderWithCompleteHandler:(nonnull AudioRecordCompleteHandler)completeHandler;


/** 初始化方法
 * 使用此方法初始化可以使用自定义的录音设置
 * @param settings 录音设置
 * @param completeHandler 完成后的回调
 */
- (nullable instancetype)initWithSettings:(nonnull NSDictionary<NSString *, id> *)settings
                          completeHandler:(nullable AudioRecordCompleteHandler)completeHandler;
+ (nullable instancetype)audioRecordWithSettings:(nonnull NSDictionary<NSString *, id> *)settings
                                 completeHandler:(nullable AudioRecordCompleteHandler)completeHandler;

/// 临时文件名称, 需要加上类型 e.g. temp.wav/temp.pcm ...
@property (nullable, nonatomic, copy) NSString *recorderFileName;


@property (nullable, nonatomic, copy) RecorderPower recorderPower;

// 开始录音
- (void)startRecorder;

// 结束录音
- (void)stopRecorder;

@end

