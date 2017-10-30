//
//  ExchangeAlertController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/28.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ExchangeAlertController.h"
#import "SelectedAddressView.h"
#import "Masonry.h"
#import "AddressViewController.h"
#import "BaseNavigationController.h"

@interface ExchangeAlertController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic , strong)NSArray *dataSourceArr;
@property (nonatomic , strong)UIPickerView *pickerView;

@end

@implementation ExchangeAlertController

#pragma mark - lazy load
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc]init];//WithFrame:CGRectMake(0, 50, width, 180)];
//        pickerView.backgroundColor = [UIColor redColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        [self.view addSubview:pickerView];
        __weak typeof(self) weakself = self;
        [pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.view.mas_left).offset(20);
            make.right.equalTo(weakself.view.mas_right).offset(-20);
            make.bottom.equalTo(weakself.view.mas_bottom).offset(-40);
            make.height.mas_equalTo(@130);
            make.width.mas_equalTo(@270);
        }];
        
        _pickerView = pickerView;
        
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)alertPickerWithTitle:(NSString *)title Separator:(NSString *)separator SourceArr:(NSArray *)sourceArr{
    
    ExchangeAlertController *alertPicker = [self alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@\n\n\n\n\n\n",separator] preferredStyle:UIAlertControllerStyleAlert];
//    alertPicker.separator = separator;
    alertPicker.dataSourceArr = sourceArr;
    [alertPicker.pickerView reloadAllComponents];
//    [alertPicker scrollToMiddleWith:sourceArr];
    
    return alertPicker;
}



- (void)addCompletionAction:(UIAlertAction *)action{
    [self addAction:action];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消兑换" style:UIAlertActionStyleCancel handler:nil];
    
    [self addAction:cancelAction];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataSourceArr.count;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    SelectedAddressView *addressPickerView = [SelectedAddressView getSelectedAddressView];
    addressPickerView.frame = CGRectMake(0, 0, self.view.width-40, 44);
    addressPickerView.model = self.dataSourceArr[row];
    return addressPickerView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSLog(@"---%ld--",row);
    _currRow = row;
}

@end
