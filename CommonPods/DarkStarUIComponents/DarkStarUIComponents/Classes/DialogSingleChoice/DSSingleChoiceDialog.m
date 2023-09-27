

#import "DSSingleChoiceDialog.h"
#import "DSSingleChoiceDialogReusingView.h"

@interface DSSingleChoiceDialog ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation DSSingleChoiceDialog

#pragma mark -
#pragma mark - UI

- (void)setupView {
#pragma mark - 顶部
    UIView *topBarView = [[UIView alloc] init];
    [self.container addSubview:topBarView];
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请选择";
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [topBarView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_offset(0);
    }];
    if (self.info && [self.info isKindOfClass:[NSString class]]) {
        titleLabel.text = self.info;
    }
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topBarView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.centerY.mas_offset(0);
    }];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [topBarView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-12);
        make.centerY.mas_offset(0);
    }];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    // 顶部线条
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [topBarView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(line.superview).offset(0);
        make.height.mas_equalTo(0.5);
    }];
#pragma mark - 其他
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.delegate   = self;
    pickView.dataSource = self;
    [self.container addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topBarView.mas_bottom).offset(0);
        make.height.mas_equalTo(250);
    }];
    self.picker = pickView;
    
    [self setupInitialData];
}

- (void)setupInitialData {
    UIPickerView *pickView = self.picker;
    NSUInteger selectIndex = [self.showDatas indexOfObject:self.selectedItem];
    if (selectIndex != NSNotFound) {
        [pickView selectRow:selectIndex inComponent:0 animated:YES];
    }
}


#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return isArrayEmptyOrNil(self.showDatas) ? 0 : self.showDatas.count;
}

#pragma mark - UIPickerViewDelegate
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return DSCommonMethods.screenWidth - 20;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    DSSingleChoiceDialogReusingView *customView = (DSSingleChoiceDialogReusingView *)view;
    if (customView == nil) {
        customView = [[DSSingleChoiceDialogReusingView alloc] initWithFrame:CGRectMake(0, 0,DSCommonMethods.screenWidth - 20,44.f)];
    }
    
    customView.row       = row;
    customView.component = component;
    customView.data      = [self.showDatas ds_objectWithIndex:row];
    [customView loadContent];
    return customView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow %@",[NSString stringWithFormat:@"component = %ld ; row = %ld",(long)component,row]);
}



#pragma mark -
#pragma mark - clickEvent

- (void)clickCancel {
    [self dismisView];
}

- (void)clickConfirm {
    UIPickerView *pickView = self.picker;
    NSInteger selectedRow = [pickView selectedRowInComponent:0];
    if (self.didSelectedIndex) {
        self.didSelectedIndex(self,selectedRow);
    }
    [self dismisView];
}


@end
