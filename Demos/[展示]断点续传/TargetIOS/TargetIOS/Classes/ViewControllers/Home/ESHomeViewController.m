//
//  ESHomeViewController.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "ESHomeViewController.h"
#import "ESSettingViewController.h"
#import "DisplayHWHomeViewScreen.h"
#import "DisplayHWCacheViewScreen.h"
#import "DisplayHWDownloadingViewScreen.h"

@interface ESHomeViewController ()

@end

@implementation ESHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新品";
    
    NR_CREATE_UI({
        NR_BUTTON_WITH_ACTION(@"查看文件列表", showBigFileList)
        NR_BUTTON_WITH_ACTION(@"查看已缓存文件列表", showCachedList)
        NR_BUTTON_WITH_ACTION(@"查看正在下载文件列表", showDownloadingList)
    }, self.nrView);
}

- (void)showBigFileList {
    DisplayHWHomeViewScreen *screen = [[DisplayHWHomeViewScreen alloc] init];
    screen.title = @"文件列表";
    [self.navigationController pushViewController:screen animated:YES];
}

- (void)showCachedList {
    DisplayHWCacheViewScreen *screen = [[DisplayHWCacheViewScreen alloc] init];
    screen.title = @"已缓存文件";
    [self.navigationController pushViewController:screen animated:YES];
}

- (void)showDownloadingList {
    DisplayHWDownloadingViewScreen *screen = [[DisplayHWDownloadingViewScreen alloc] init];
    screen.title = @"正在下载文件";
    [self.navigationController pushViewController:screen animated:YES];
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
