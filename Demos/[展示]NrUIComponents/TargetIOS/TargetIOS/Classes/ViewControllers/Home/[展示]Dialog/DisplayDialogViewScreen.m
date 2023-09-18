//
//  DisplayDialogViewScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/15.
//

#import "DisplayDialogViewScreen.h"
#import <NrUIComponents/NrDateDialog.h>
#import <NrUIComponents/NrSingleChoiceDialog.h>
#import <NrUIComponents/NrMultiChoiceDialog.h>
@interface DisplayDialogViewScreen ()

@end

@implementation DisplayDialogViewScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recylerView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"";
    if (indexPath.row == 0) {
        cell.textLabel.text = @"日期选择器";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"单选选择器";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"多选选择器";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NrDateDialog *dialogView = [[NrDateDialog alloc] init];
        ///视图将要出现时，设置各属性
        [dialogView setDialogWillShow:^(NrBaseDialogView * _Nonnull dialog) {
            UIDatePicker *datePicker = (UIDatePicker *)dialog.picker;
            datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }];
        [dialogView setDidSelectedDate:^(NrDateDialog * _Nonnull dialog, NSDate * _Nonnull date) {
            NSLog(@"date %@",date);
        }];
        [dialogView showInView:self.navigationController.view];
    }
    else if (indexPath.row == 1) {
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [datas addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NrSingleChoiceDialog *dialogView = [[NrSingleChoiceDialog alloc] init];
        dialogView.showDatas = datas;
        dialogView.selectedItem = @"5";
        [dialogView setDidSelectedIndex:^(NrSingleChoiceDialog * _Nonnull dialog, NSInteger selectedIndex) {
            NSLog(@"selectedIndex %ld",(long)selectedIndex);
        }];
        [dialogView showInView:self.navigationController.view];
    }
    else if (indexPath.row == 2) {
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [datas addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NrMultiChoiceDialog *dialogView = [[NrMultiChoiceDialog alloc] init];
        dialogView.info = @"-请选择-";
        dialogView.selectedItem = @"4";
        dialogView.showDatas = datas;
        [dialogView setDialogWillShow:^(NrBaseDialogView * _Nonnull dialog) {
            [((NrMultiChoiceDialog *)dialog).disableItems addObject:@"3"];
            [((NrMultiChoiceDialog *)dialog).tableView reloadData];
        }];
        [dialogView setDidSelectedItems:^(NrMultiChoiceDialog *dialog, NSArray *items) {
            NSLog(@"%@",items);
        }];
        [dialogView showInView:self.navigationController.view];
    }
}
@end
