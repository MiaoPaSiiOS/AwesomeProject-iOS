//
//  FeedappChildQQViewScreen.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "FeedappChildQQViewScreen.h"
#import "Masonry.h"
@interface FeedappChildQQViewScreen ()

@end

@implementation FeedappChildQQViewScreen

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appBar.hidden = YES;
    [self.dsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
    }];
    // Do any additional setup after loading the view.
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
