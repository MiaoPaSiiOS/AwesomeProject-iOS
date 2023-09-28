//
//  DSTemplateTableViewController.m
//  DarkStarUIKit
//
//  Created by zhuyuhui on 2023/9/17.
//

#import "DSTemplateTableViewController.h"
@interface DSTemplateTableViewController ()

@end

@implementation DSTemplateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([DSCommonMethods isArrayEmptyOrNil:(self.templates)]) {
        return 0;
    }
    return self.templates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    DSTemplateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DSTemplateTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (![DSCommonMethods isArrayEmptyOrNil:(self.templates)]) {
        cell.model = [self.templates ds_objectWithIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![DSCommonMethods isArrayEmptyOrNil:(self.templates)]) {
        DSTemplate *model = [self.templates ds_objectWithIndex:indexPath.row];
        if (![DSCommonMethods isStringEmptyOrNil:(model.classStr)]) {
            Class cla = NSClassFromString(model.classStr);
            if (!cla) return;
            if ([cla isSubclassOfClass:DSViewController.class]) {
                NSLog(@"'cla' 是 DSViewController 或其子类的类");
                DSViewController *vc = [[cla alloc] init];
                vc.extParmers = model.extParmers;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([cla isSubclassOfClass:UIViewController.class]) {
                NSLog(@"'cla' 是 UIViewController 或其子类的类");
                UIViewController *vc = [[cla alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

@end
