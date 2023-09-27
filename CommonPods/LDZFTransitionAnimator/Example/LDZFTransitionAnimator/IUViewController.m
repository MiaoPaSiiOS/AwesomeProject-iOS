//
//  IUViewController.m
//  IU_IUBaseLdzfBaseTransitionAnimator
//
//  Created by zhuyuhui434@gmail.com on 06/05/2021.
//  Copyright (c) 2021 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUViewController.h"
#import <LDZFTransitionAnimator/LDZFTransitionAnimator.h>
#import "TestViewController.h"

@interface IUViewController ()
{
    NSArray *_kListDatas;
}
@end

@implementation IUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _kListDatas = @[
        @{@"name": @"Left Translate"},
        @{@"name": @"Right Translate"},
        @{@"name": @"Top Translate"},
        @{@"name": @"Bottom Translate"},
        @{@"name": @"Center Fading"},
        @{@"name": @"Center FromTop"},
        @{@"name": @"Center FromBottom"}
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kListDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[_kListDatas objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LdzfBaseTransitionAnimator *animation = nil;
    if (indexPath.section == 0) {
        TestViewController *testVC = [[TestViewController alloc] init];
        switch (indexPath.row) {
            case 0:
                animation = [[LdzfAnimationLeft alloc] init];
                break;
            case 1:
                animation = [[LdzfAnimationRight alloc] init];
                break;
            case 2:
                animation = [[LdzfAnimationTop alloc] init];
                break;
            case 3:
                animation = [[LdzfAnimationBottom alloc] init];
                break;
            case 4:
                animation = [[LdzfAnimationFade alloc] init];
                break;
            case 5:
                animation = [[LdzfAnimationCenterFromTop alloc] init];
                break;
            default:
                animation = [[LdzfAnimationCenterFromBottom alloc] init];
                break;
        }
        [self presentViewController:testVC animation:animation completion:nil];
    }
}


@end
