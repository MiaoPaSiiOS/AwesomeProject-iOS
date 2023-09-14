
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSKeepAliveBGTool : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *_tool;
}

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
