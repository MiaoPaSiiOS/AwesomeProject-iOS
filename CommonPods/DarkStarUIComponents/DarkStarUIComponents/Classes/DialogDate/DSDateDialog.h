//
//  DSDateDialog.h
//  NrUIComponents
//
//  Created by zhuyuhui on 2022/8/11.
//

#import "DSBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSDateDialog : DSBaseDialogView
@property(nonatomic, copy) void (^didSelectedDate)(DSDateDialog *dialog, NSDate *date);
@end

NS_ASSUME_NONNULL_END
/*
 DSDateDialog *dialogView = [[DSDateDialog alloc] init];
 ///视图将要出现时，设置各属性
 [dialogView setDialogWillShow:^(DSBaseDialogView * _Nonnull dialog) {
     UIDatePicker *datePicker = (UIDatePicker *)dialog.picker;
     datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
 }];
 [dialogView setDidSelectedDate:^(DSDateDialog * _Nonnull dialog, NSDate * _Nonnull date) {
     NSLog(@"date %@",date);
 }];
 [dialogView showInView:self.navigationController.view];
 */
