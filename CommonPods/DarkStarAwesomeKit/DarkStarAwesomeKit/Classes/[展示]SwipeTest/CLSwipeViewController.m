//
//  CLSwipeViewController.m
//  Base
//
//  Created by whbt_mac on 15/12/29.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import "CLSwipeViewController.h"
#import "SMSwipeView.h"

@interface CLSwipeViewController ()<SMSwipeDelegate>
@property(nonatomic, strong) SMSwipeView *swipe;

@property(nonatomic, strong) NSArray * colors;
@end

@implementation CLSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"滑动效果";
    self.view.backgroundColor = [UIColor whiteColor];
    self.swipe = [[SMSwipeView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88 - 88)];
    self.swipe.delegate = self;
    self.swipe.layer.borderColor = [UIColor blueColor].CGColor;
    self.swipe.layer.borderWidth = 1;
    [self.view addSubview:self.swipe];
    
    self.colors=@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)SMSwipeGetView:(SMSwipeView *)swipe withIndex:(int)index{
    static NSString * identify=@"testIndentify";
    UITableViewCell * cell=[self.swipe dequeueReusableUIViewWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else{
        NSLog(@"%@",@"not nil");
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%d",index];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
    cell.backgroundColor= [UIColor groupTableViewBackgroundColor];;
    cell.layer.borderColor = [UIColor redColor].CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius=10;
    return cell;
}

-(NSInteger)SMSwipeGetTotaleNum:(SMSwipeView *)swipe{
    return 5;
}

@end
