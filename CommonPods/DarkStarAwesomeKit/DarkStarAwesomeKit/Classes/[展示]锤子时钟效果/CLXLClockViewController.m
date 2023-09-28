
#import "CLXLClockViewController.h"
#import "XLClock.h"

@interface CLXLClockViewController (){
    XLClock *_clock;
}
@property(nonatomic, assign) BOOL isFirst;
@end

@implementation CLXLClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    self.title = @"新品";
    _clock = [[XLClock alloc] initWithFrame:CGRectMake(0, 64, 300, 300)];
    _clock.centerX = DSDeviceInfo.screenWidth/2;
    [self.dsView addSubview:_clock];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirst) {
        self.isFirst = NO;
        [_clock showStartAnimation];
    }
    
}

@end
