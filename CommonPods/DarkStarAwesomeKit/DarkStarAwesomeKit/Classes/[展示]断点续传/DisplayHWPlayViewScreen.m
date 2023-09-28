//
//  DisplayHWPlayViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/16.
//

#import "DisplayHWPlayViewScreen.h"
#import <AVKit/AVKit.h>

@interface DisplayHWPlayViewScreen ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation DisplayHWPlayViewScreen

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _model.fileName;
    
    [self creatControl];
}

- (void)creatControl
{
    // 进度条
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 400, DSDeviceInfo.screenWidth - 100, 50)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dsView addSubview:slider];
    
    // 创建播放器
    _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_model.localPath]]];

    // 创建显示的图层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, DSDeviceInfo.screenWidth, 400);
    [self.dsView.layer addSublayer:playerLayer];

    // 播放视频
    [_player play];
    
    // 进度回调
    kWeakSelf
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        kStrongSelf
        // 刷新slider
        slider.value = CMTimeGetSeconds(time) / CMTimeGetSeconds(strongSelf.player.currentItem.duration);
    }];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    // 计算时间
    float time = slider.value * CMTimeGetSeconds(_player.currentItem.duration);
    
    // 跳转到指定时间
    [_player seekToTime:CMTimeMake(time, 1.0)];
}

@end

