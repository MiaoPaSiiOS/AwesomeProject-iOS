//
//  AppDelegate+AMENAdKeyPopups.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AppDelegate+AMENAdKeyPopups.h"

@implementation AppDelegate (AMENAdKeyPopups)


- (void)setupCopyBoardPop {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"粘贴板信息 %@",pasteboard.string);
}

@end
