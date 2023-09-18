//
//  CLScrollerViewLinerController.m
//  scrollTest
//
//  Created by stonemover on 2017/6/21.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "CLScrollerViewLinerController.h"
#import "TestTableViewCell.h"
#import "UIScrollView+ScrollAnimation.h"

static CGFloat const kCellHeight = 44.f;
static NSInteger const kRowNUM = 10;
@interface CLScrollerViewLinerController ()<UIScrollViewDelegate>
@end

@implementation CLScrollerViewLinerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.recylerView registerNib:[UINib nibWithNibName:@"TestTableViewCell" bundle:nil] forCellReuseIdentifier:@"TestTableViewCellId"];
    [self clickBtn:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBtn:(id)sender {
    NSLog(@"clickBtn tableView.contentOffset.y = %f",self.recylerView.contentOffset.y);
    CAMediaTimingFunction * timing=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [self.tableView setContentOffset:CGPointMake(0, 100)animated:YES];
    //设置tableview 1秒内走完kCellHeight距离
    [self.recylerView setContentOffset:CGPointMake(0, self.recylerView.contentOffset.y+kCellHeight) withTimingFunction:timing duration:1];
}

#pragma mark tableView data delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kRowNUM;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"TestTableViewCellId"];
    cell.backgroundColor = kRandomColor;
    cell.label.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"%@",@"scrollViewDidEndScrollingAnimation");
    
    CAMediaTimingFunction * timing=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSLog(@"clickBtn tableView.contentOffset.y = %f",self.recylerView.contentOffset.y);
    if (self.recylerView.contentOffset.y<kRowNUM*kCellHeight) {
        //设置tableview 1秒内走完kCellHeight距离
        [self.recylerView setContentOffset:CGPointMake(0, self.recylerView.contentOffset.y+44) withTimingFunction:timing duration:1];
    }
}

@end
