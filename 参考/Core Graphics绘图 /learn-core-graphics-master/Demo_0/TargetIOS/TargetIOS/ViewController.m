//
//  ViewController.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/3/1.
//

#import "ViewController.h"
#import "TestCoreGraphicsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TestCoreGraphicsView *view = [[TestCoreGraphicsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}


@end
