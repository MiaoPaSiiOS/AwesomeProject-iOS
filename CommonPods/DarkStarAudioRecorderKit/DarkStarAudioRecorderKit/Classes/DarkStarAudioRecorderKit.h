//
//  DarkStarAudioRecorderKit.h
//  Pods
//
//  Created by zhuyuhui on 2021/11/10.
//

#ifndef DarkStarAudioRecorderKit_h
#define DarkStarAudioRecorderKit_h

#import "DSAudioRecorder.h"

#endif /* DarkStarAudioRecorderKit_h */

/*
 
 #import "IUViewController.h"
 #import <NrAudioRecorderKit/NrAudioRecorderKit.h>
 #import <NrAuthorityKit/NrAuthorityKit.h>
 #import <NrBaseCoreKit/NrBaseCoreKit.h>
 #import <Masonry/Masonry.h>

 @interface IUViewController ()
 @property (nonatomic, strong) NrAudioRecorder *recorder;
 @property (nonatomic, copy) NSString *startTimeStamp;
 @property (nonatomic, copy) NSString *endTimeStamp;
 @property (nonatomic, copy) NSString *changeTimeStamp;
 @property (nonatomic, strong) UIView *gestureView;
 @property (nonatomic, strong) UILabel *msgL;
 @end

 @implementation IUViewController

 - (void)viewDidLoad
 {
     [super viewDidLoad];
     // Do any additional setup after loading the view, typically from a nib.
     [self.view addSubview:self.gestureView];
     [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.centerY.equalTo(self.view);
         make.size.mas_equalTo(CGSizeMake(100, 100));
     }];
     
     [self.view addSubview:self.msgL];
     [self.msgL mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
         make.left.right.equalTo(self.view);
         make.bottom.equalTo(self.gestureView.mas_top).offset(-20);
     }];
     
     UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
     longPress.minimumPressDuration = 0.000001;
     [self.gestureView addGestureRecognizer:longPress];
 }


 - (void)longPress:(UILongPressGestureRecognizer *)longPress {
     if (longPress.state == UIGestureRecognizerStateBegan) {
         _startTimeStamp = [self getNowTimeTimestamp];
         [self.recorder startRecorder];
         [UIView animateWithDuration:0.1 animations:^{
             self.gestureView.scale = 0.8;
         }];
     }
     if (longPress.state == UIGestureRecognizerStateEnded) {
         _endTimeStamp = [self getNowTimeTimestamp];
         long long space = [_endTimeStamp longLongValue] - [_startTimeStamp longLongValue];
         [self.recorder stopRecorder];
         [UIView animateWithDuration:0.1 animations:^{
             self.gestureView.scale = 1;
         }];
         NSLog(@"UIGestureRecognizerStateEnded %lld",space);
         if (space < 6000) {
             NSLog(@"UIGestureRecognizerStateEnded<6000");
             if (space < 1000) {//小于1000毫秒(时间太短)
                 self.msgL.text = @"录音时间太短，请重新录制";
                 self.msgL.textColor = kHexColor(0xFF4D29);
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     self.msgL.textColor = kHexColor(0x666666);
                     self.msgL.text = @"请按住按钮，用普通话匀速读出文字";
                 });
             }
         }
     }
 //    if (longPress.state == UIGestureRecognizerStateChanged) {
 //        NSLog(@"UIGestureRecognizerStateChanged");
 //        _changeTimeStamp = [self getNowTimeTimestamp];
 //        long long space = [_changeTimeStamp longLongValue] - [_startTimeStamp longLongValue];
 //        if (space >= 6000) {//大于等于6000毫秒
 //            [self.recorder stopRecorder];
 //        }
 //    }
 }


 //当前时间戳(毫秒）
 - (NSString *)getNowTimeTimestamp{
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
     [formatter setDateStyle:NSDateFormatterMediumStyle];
     [formatter setTimeStyle:NSDateFormatterShortStyle];
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
     //时区
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
     [formatter setTimeZone:timeZone];
     NSDate *datenow = [NSDate date];
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
     return timeSp;
 }

 - (void)didReceiveMemoryWarning
 {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
 }

 - (NrAudioRecorder *)recorder {
     if (!_recorder) {
         __weak __typeof(self)weakSelf = self;
         _recorder = [[NrAudioRecorder alloc] initWithSettings:@{
             AVSampleRateKey: [NSNumber numberWithFloat:16000], //采样率
             AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatLinearPCM],
             AVLinearPCMBitDepthKey: [NSNumber numberWithInt:16],//采样位数 8/16 默认 16
             AVNumberOfChannelsKey: [NSNumber numberWithInt:1]//通道的数目
         } completeHandler:^(NrAudioRecorderStatus status, NSData *_Nullable data) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             switch (status) {
                 case NrAudioRecorderStatusInitFailure:
                     NSLog(@"录音失败，请稍后再试");
                     break;
                 case NrAudioRecorderStatusNoApplyAuthority:
                     NSLog(@"");
                     [NrMediaManger requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                     }];
                     break;
                 case NrAudioRecorderStatusNoAuthorized:
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"麦克风未开启:请到设置-隐私-麦克风里允许使用麦克风");
                     });
                     break;
                 case NrAudioRecorderStatusFailure:
                     NSLog(@"录音失败，请重新录制");
                     break;
                 case NrAudioRecorderStatusSuccess: {
                     strongSelf.msgL.text = @"录制结束";
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         strongSelf.msgL.text = @"请按住按钮，用普通话匀速读出文字";
                     });
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *documetsDirectory = [paths objectAtIndex:0];
                     NSLog(@"%@",documetsDirectory);
                     
 //                    long long space = [strongSelf.endTimeStamp longLongValue] - [strongSelf.startTimeStamp longLongValue];
 //                    long long changeSpace = [strongSelf.changeTimeStamp longLongValue] - [strongSelf.startTimeStamp longLongValue];
 //                    if ((changeSpace >= 6000) || (space >= 1000)) {
 //                        [strongSelf doVocalLogin:base64Content];
 //                    }
                 }
                     break;
                 default:
                     break;
             }
         }];
     }
     return _recorder;
 }

 - (UIView *)gestureView {
     if (!_gestureView) {
         _gestureView = [[UIView alloc] init];
         _gestureView.backgroundColor = [UIColor grayColor];
     }
     return _gestureView;
 }

 - (UILabel *)msgL {
     if (!_msgL) {
         _msgL = [[UILabel alloc] init];
         _msgL.backgroundColor = [UIColor whiteColor];
         _msgL.textAlignment = NSTextAlignmentCenter;
         _msgL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
         _msgL.textColor = kHexColor(0x666666);
         _msgL.text = @"请按住按钮，用普通话匀速读出文字";
         _msgL.numberOfLines = 3;
         _msgL.lineBreakMode = NSLineBreakByCharWrapping;
     }
     return _msgL;
 }

 @end
 */
