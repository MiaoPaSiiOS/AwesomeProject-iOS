
#import "DSBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSingleChoiceDialog : DSBaseDialogView
// returns selected row. -1 if nothing selected
@property(nonatomic, copy) void (^didSelectedIndex)(DSSingleChoiceDialog *dialog, NSInteger selectedIndex);
@end

NS_ASSUME_NONNULL_END
/*
 NSMutableArray *datas = [NSMutableArray array];
 for (int i = 0; i < 10; i++) {
     [datas addObject:[NSString stringWithFormat:@"%d",i]];
 }
 DSSingleChoiceDialog *dialogView = [[DSSingleChoiceDialog alloc] init];
 dialogView.showDatas = datas;
 dialogView.selectedItem = @"5";
 [dialogView setDidSelectedIndex:^(DSSingleChoiceDialog * _Nonnull dialog, NSInteger selectedIndex) {
     NSLog(@"selectedIndex %ld",(long)selectedIndex);
 }];
 [dialogView showInView:self.navigationController.view];
 */
