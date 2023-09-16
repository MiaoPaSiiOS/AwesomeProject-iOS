
#import "DSKeepAliveBGTool.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
@implementation DSKeepAliveBGTool

#pragma mark - Public
- (void)start
{
    if (_tool && [_tool isPlaying]) {
        return;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    if (session.isOtherAudioPlaying) {//如果有其他应用正在播放则不播放无声音乐
        return;
    }

    if (@available(iOS 10.0, *)) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:(AVAudioSessionCategoryOptionMixWithOthers |
                                                      AVAudioSessionCategoryOptionAllowBluetooth |
                                                      AVAudioSessionCategoryOptionAllowBluetoothA2DP |
                                                      AVAudioSessionCategoryOptionDefaultToSpeaker)
                                               error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:(AVAudioSessionCategoryOptionMixWithOthers |
                                                      AVAudioSessionCategoryOptionAllowBluetooth |
                                                      AVAudioSessionCategoryOptionDefaultToSpeaker)
                                               error:nil];
    }
    /*
     虽然系统会在App启动的时候，激活这个唯一的AVAudioSession，
     但是最好还是在自己ViewController的viewDidLoad里面再次进行激活：
     */
    [session setActive:YES error:nil];
    
    NSURL *url = [[NSBundle ds_bundleName:@"DSKeepAliveManager" inPod:@"DSKeepAliveManager"] URLForResource:@"bg" withExtension:@"mp3"];
    if (url) {
        _tool = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_tool prepareToPlay];
        [_tool setDelegate:self];
        _tool.numberOfLoops = -1;
        BOOL ret = [_tool play];
        if (!ret) {
        }
    }
}

- (void)stop
{
    if (_tool) {
        [_tool stop];
        _tool = nil;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
    }
}

@end

