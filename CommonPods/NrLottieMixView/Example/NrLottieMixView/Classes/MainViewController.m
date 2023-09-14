//
//  MainViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry/Masonry.h>
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Lottie Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initSourceDatas];
    [self initSubViews];
}

- (void)initSourceDatas {
    self.dataSource = @[
        @{
            @"textStr":@"动画默认展示",
            @"classNameStr":@"IUDefaultViewController"
        },
        @{
            @"textStr":@"修改颜色",
            @"classNameStr":@"IU002ViewController"
        },
        @{
            @"textStr":@"红包展示",
            @"classNameStr":@"IU003ViewController"
        },
        @{
            @"textStr":@"替换View，添加点击事件",
            @"classNameStr":@"IU004ViewController"
        },
        @{
            @"textStr":@"启动页展示",
            @"classNameStr":@"IU005ViewController"
        }
    ];
}

- (void)initSubViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *datas = self.dataSource[indexPath.row];
    cell.textLabel.text = datas[@"textStr"];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *datas = self.dataSource[indexPath.row];
    NSString *textStr = datas[@"textStr"];
    NSString *classNameStr = datas[@"classNameStr"];
    if(classNameStr){
        Class class = NSClassFromString(classNameStr);
        if(class){
            UIViewController *vc = [[class alloc] init];
            vc.title = textStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
