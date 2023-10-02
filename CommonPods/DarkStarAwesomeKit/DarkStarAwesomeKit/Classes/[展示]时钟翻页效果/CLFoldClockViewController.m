

#import "CLFoldClockViewController.h"
#import "XLFoldClock.h"
@interface CLFoldClockViewController ()
{
    NSTimer *_timer;
    XLFoldClock *_foldClock;
}
@end

@implementation CLFoldClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"[展示]时钟翻页效果";
    
    _foldClock = [[XLFoldClock alloc] init];
    _foldClock.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    [_foldClock updateDate:[NSDate date] animated:false];
    _foldClock.font = [UIFont fontWithName:@"AmericanTypewriter-Condensed" size:100];
    [self.dsView addSubview:_foldClock];
    
    [self createTimer];
}

- (void)createTimer {
    __weak __typeof(self)weakSelf = self;
    _timer = [DSHelper timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        [weakSelf updateTimeLabel];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimeLabel {
    [_foldClock updateDate:[NSDate date] animated:true];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
