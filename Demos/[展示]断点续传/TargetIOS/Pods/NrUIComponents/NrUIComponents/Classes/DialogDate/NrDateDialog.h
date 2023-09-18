//
//  NrDateDialog.h
//  NrUIComponents
//
//  Created by zhuyuhui on 2022/8/11.
//

#import "NrBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NrDateDialog : NrBaseDialogView
@property(nonatomic, copy) void (^didSelectedDate)(NrDateDialog *dialog, NSDate *date);
@end

NS_ASSUME_NONNULL_END
/*
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
 */
