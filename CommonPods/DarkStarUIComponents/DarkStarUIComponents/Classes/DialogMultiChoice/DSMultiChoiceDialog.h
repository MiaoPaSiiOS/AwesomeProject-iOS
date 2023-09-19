/*
 多选：
 可设置选中，不可选中

 */
#import "DSBaseDialogView.h"
#import "DSMultiChoiceDialogCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSMultiChoiceDialog : DSBaseDialogView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *checkedItems;//选中
@property (nonatomic, strong) NSMutableArray *disableItems;//不可选中

@property(nonatomic, copy) void (^didSelectedItems)(DSMultiChoiceDialog *dialog, NSArray *items);
@property(nonatomic, copy) void (^didSelectRowAtIndexPath)(DSMultiChoiceDialog *dialog, NSIndexPath *indexPath);

@property(nonatomic, strong) Class cellClass;//DSMultiChoiceDialogCell 子类
#pragma mark - Useful Method
- (void)enableItem:(id)item enable:(BOOL)enable;
- (void)checkedItem:(id)item check:(BOOL)check;

@end

NS_ASSUME_NONNULL_END
/*
 Example:
 
 NSMutableArray *datas = [NSMutableArray array];
 for (int i = 0; i < 10; i++) {
     [datas addObject:[NSString stringWithFormat:@"%d",i]];
 }
 
 DSMultiChoiceDialog *dialog = DSMultiChoiceDialog.build;
 dialog.withInfo(@"-请选择-").withSelectedItem(@"4").withShowDatas(datas);
 [dialog setDialogWillShow:^(AlertBaseDialog *dialog) {
     [((DSMultiChoiceDialog *)dialog).disableItems addObject:@"3"];
     [((DSMultiChoiceDialog *)dialog).tableView reloadData];
 }];
 [dialog setDidSelectedItems:^(DSMultiChoiceDialog *dialog, NSArray *items) {
     NSLog(@"%@",items);
     IUViewController *vc = [[IUViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
 }];
 [self presentViewController:dialog animated:NO completion:nil];
 
 */
