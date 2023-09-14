//
//  NrDateDialog.m
//  NrUIComponents
//
//  Created by zhuyuhui on 2022/8/11.
//

#import "NrDateDialog.h"

@implementation NrDateDialog


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
    titleLabel.text = @"选择日期";
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
    UIDatePicker *datePicker  = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerEvent:) forControlEvents:UIControlEventValueChanged];
    [self.container addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topBarView.mas_bottom).offset(0);
        make.height.mas_equalTo(250);
    }];
    self.picker = datePicker;
    
    [self setupInitialData];
}

- (void)setupInitialData {
    UIDatePicker *picker = self.picker;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    picker.locale = locale;
    if (@available(iOS 13.4, *)) {
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        
    } else {
        // Fallback on earlier versions
    }
        
    if (self.selectedItem && [self.selectedItem isKindOfClass:[NSDate class]]) {
        picker.date = self.selectedItem;
    }
}


#pragma mark -
#pragma mark - datePickerEvent
- (void)datePickerEvent:(UIDatePicker *)picker {

}


#pragma mark -
#pragma mark - clickEvent

- (void)clickCancel {
    [self dismisView];
}

- (void)clickConfirm {
    UIDatePicker *picker = self.picker;
    if (self.didSelectedDate) {
        self.didSelectedDate(self, picker.date);
    }
    [self dismisView];
}


@end
