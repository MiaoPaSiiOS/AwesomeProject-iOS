//
//  ESHomeViewController.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "ESHomeViewController.h"
#import "ESSettingViewController.h"
#import <YYModel/YYModel.h>
#import "NrDisplayOfFunctionCell.h"
#import "NrDisplayOfFunction.h"

@interface ESHomeViewController ()
@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation ESHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新品";
    
    NrBarButtonItem *rightBarButtonItem = [[NrBarButtonItem alloc] initWithTitle:@"设置" target:self action:@selector(showDisplayOfCommonFunctions)];
    rightBarButtonItem.titleColor = [UIColor blackColor];
    self.appBar.rightBarButtonItem = rightBarButtonItem;
}

- (void)showDisplayOfCommonFunctions {
    ESSettingViewController *screen = [[ESSettingViewController alloc] init];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NrDisplayOfFunction *displayOf = [self.dataSource nr_objectWithIndex:indexPath.row];
    return [NrDisplayOfFunctionCell heightForRowAtIndexPath:displayOf];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NrDisplayOfFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NrDisplayOfFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.displayOf = [self.dataSource nr_objectWithIndex:indexPath.row];
    [cell loadContent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NrDisplayOfFunction *displayOf = [self.dataSource nr_objectWithIndex:indexPath.row];
    if (!isStringEmptyOrNil(displayOf.classNameStr)) {
        Class className = NSClassFromString(displayOf.classNameStr);
        if (className) {
            UIViewController *screen = [[className alloc] init];
            screen.title = displayOf.title;
            [self.navigationController pushViewController:screen animated:YES];
        }
    }
}




#pragma makr - 数据
- (NSArray *)dataSource {
    return @[
        [NrDisplayOfFunction yy_modelWithDictionary:@{
            @"title":@"标签展示（宽度不固定）",
            @"gif":@"",
            @"classNameStr":@"DisplayCustomCollectionTagScreen"
        }],
        [NrDisplayOfFunction yy_modelWithDictionary:@{
            @"title":@"NrCardSwitch展示",
            @"gif":@"",
            @"classNameStr":@"DisplayNrCardSwitchScreen"
        }],
        [NrDisplayOfFunction yy_modelWithDictionary:@{
            @"title":@"Dialog展示",
            @"gif":@"",
            @"classNameStr":@"DisplayDialogViewScreen"
        }],
    ];
}

@end
