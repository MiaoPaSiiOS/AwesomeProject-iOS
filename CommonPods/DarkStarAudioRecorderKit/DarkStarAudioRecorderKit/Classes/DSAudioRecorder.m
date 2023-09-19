
#import "DSAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <DarkStarAuthorityKit/DarkStarAuthorityKit.h>
static NSString * const fileName = @"Nr_audio_recorder_temp.wav";

@interface DSAudioRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, copy) NSDictionary<NSString *, id> *settings;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, copy) AudioRecordCompleteHandler completeHandler;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation DSAudioRecorder
- (instancetype)initWithCompleteHandler:(AudioRecordCompleteHandler)completeHandler {
    NSDictionary *settings = @{
        AVSampleRateKey : [NSNumber numberWithFloat: 16000], //采样率
        AVFormatIDKey : [NSNumber numberWithInt: kAudioFormatLinearPCM],
        AVLinearPCMBitDepthKey : [NSNumber numberWithInt:16],//采样位数 8/16 默认 16
        AVNumberOfChannelsKey : [NSNumber numberWithInt: 1]//通道的数目
    };
    return [self initWithSettings:settings completeHandler:completeHandler];
}

- (instancetype)initWithSettings:(NSDictionary<NSString *,id> *)settings completeHandler:(nullable AudioRecordCompleteHandler)completeHandler {
    if (self = [super init]) {
        _settings = settings;
        _completeHandler = completeHandler;
        _recorderFileName = fileName;
    }
    return self;
}

+ (instancetype)audioRecorderWithCompleteHandler:(AudioRecordCompleteHandler)completeHandler {
    DSAudioRecorder *recorder = [[self alloc] initWithCompleteHandler:completeHandler];
    return recorder;
}

+ (instancetype)audioRecordWithSettings:(NSDictionary<NSString *,id> *)settings completeHandler:(AudioRecordCompleteHandler)completeHandler {
    DSAudioRecorder *recorder = [[self alloc] initWithSettings:settings completeHandler:completeHandler];
    return recorder;
}

- (NSString *)audioFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.recorderFileName];
}

- (void)startRecorder {
    if (!self.completeHandler) return;
    if (self.settings.allKeys.count == 0) {
        self.completeHandler(DSAudioRecorderStatusInitFailure, nil);
        return;
    }
    
    DSMediaStatus status = [DSMediaManger authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == DSMediaStatusNotDetermined) {
        // 未申请过麦克风权限
        self.completeHandler(DSAudioRecorderStatusNoApplyAuthority, nil);
        return;
    } else if (status == DSMediaStatusRestricted || status == DSMediaStatusDenied) {
        // 无麦克风权限
        self.completeHandler(DSAudioRecorderStatusNoAuthorized, nil);
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[self audioFilePath]];
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.settings error:&error];
    if (!self.recorder || error) {
        self.completeHandler(DSAudioRecorderStatusFailure, nil);
        self.recorder = nil;
        return;
    }
    
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;// 允许测量
    [self.recorder prepareToRecord];
    [self startRecorderInfo];
}

- (void)startRecorderInfo {
    //有时候record会打开失败
    //这里重试3次，3次未打开，则返回打开失败
    BOOL record = NO;
    NSInteger count = 3;
    do {
        record = [self.recorder record];
        if (record) break;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        count--;
    } while (count > 0);
    
    if (record) {
        [self startUpdatingMeter];
    }
}

- (void)stopRecorder {
    if (self.recorder && self.recorder.isRecording) {
        [self.recorder stop];
        [self stopUpdatingMeter];
        if (self.completeHandler) {
            NSData *data = [NSData dataWithContentsOfFile:[self audioFilePath]];
            NSUInteger len = [data length];
            if (len > 0) {
                self.completeHandler(DSAudioRecorderStatusSuccess, data);
            } else {
                self.completeHandler(DSAudioRecorderStatusFailure, nil);
            }
        }
        [self.recorder deleteRecording];
        self.recorder.delegate = nil;
        self.recorder = nil;
    }
}

- (void)startUpdatingMeter {
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateMeters {
    float normalizedValue = [self normalizedPowerLevelFromDecibels];
    if(normalizedValue >= 1) {
        normalizedValue = .999f;
    }
    if (self.recorderPower) {
        self.recorderPower(normalizedValue);
    }
}

- (CGFloat)normalizedPowerLevelFromDecibels {
    [self.recorder updateMeters];// 更新数据
    CGFloat decibels = [self.recorder averagePowerForChannel:0];
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

- (void)stopUpdatingMeter {
    [self.displayLink invalidate];
    self.displayLink = nil;
}
@end
