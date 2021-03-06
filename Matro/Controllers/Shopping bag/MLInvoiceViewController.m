//
//  MLInvoiceViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLInvoiceViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"

#import "UIButton+HeinQi.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "MLLoginViewController.h"

@interface MLInvoiceViewController ()
@property (strong, nonatomic) IBOutlet UIButton *kai;
@property (strong, nonatomic) IBOutlet UIButton *bukai;
@property (weak, nonatomic) IBOutlet UIView *gongsilab;
@property (weak, nonatomic) IBOutlet UIButton *geren;
@property (weak, nonatomic) IBOutlet UIButton *gongsi;
@property (weak, nonatomic) IBOutlet UIView *fapiaoInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gongsiLabH;
@property (weak, nonatomic) IBOutlet UITextField *gongsiTitle;

@end

@implementation MLInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self invoiceUI];
    self.title = @"发票信息";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction:)];
    right.tintColor = RGBA(192, 159, 116, 1);
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
//    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.gongsilab.layer.borderWidth = 1.f;
    self.gongsilab.layer.borderColor = RGBA(241, 241, 241, 1).CGColor;
    self.gongsilab.layer.cornerRadius = 4.f;
    self.gongsilab.layer.masksToBounds = YES;
    _gongsiLabH.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _bukai.selected = !_isNeed;
//    _kai.selected = _isNeed;
    if (!self.isNeed) {
        [self invoiceButtonAction:self.bukai];
    }
    else{
         [self invoiceButtonAction:self.kai];
        if (self.isGeren) {
             [self taitouButtonAction:self.geren];
        }
        else{
            [self taitouButtonAction:self.gongsi];
            self.gongsiTitle.text = self.mingxi;
        }
    }
}

- (void)invoiceUI{
    [_kai invoiceselButtonType];
    [_bukai invoiceselButtonType];
    [_geren invoiceselButtonType];
    [_gongsi invoiceselButtonType];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
- (IBAction)taitouButtonAction:(id)sender {
    UIButton *button = ((UIButton *)sender);
    if (button.selected) {
        return;
    }
    button.selected = YES;
    if ([button isEqual:_geren]) {
        _gongsi.selected = NO;
        _gongsiLabH.constant = 0;
        
    }else{
        _geren.selected = NO;
        _gongsiLabH.constant = 44;
        
    }
    
}

- (IBAction)invoiceButtonAction:(id)sender {
    UIButton *button = ((UIButton *)sender);
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if ([button isEqual:_kai]) {
        _bukai.selected = NO;
        self.fapiaoInfo.hidden = NO;
        
    }else{
        _kai.selected = NO;
        self.fapiaoInfo.hidden = YES;
       
    }
    
}
- (void)saveButtonAction:(id)sender {
    
    if (self.bukai.selected) { //不开发票 直接返回
        //开发票
        if (self.invoiceBlock) {
            self.invoiceBlock(NO,_gongsi.selected,@"",@"");
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (_gongsi.selected && !(_gongsiTitle.text.length > 0)) {
        [MBProgressHUD showSuccess:@"请输入公司名称" toView:self.view];
        return;
    }
    if ([HFSUtility isHaveSpaceString:_gongsiTitle.text]) {
        [MBProgressHUD showMessag:@"请不要输入空格" toView:self.view];
        return;
    }
    NSString *titou = nil;
    if (_gongsi.selected) {
        titou = _gongsiTitle.text;
    }else{
        titou = @"明细";
    }
    
    NSDictionary *params = @{@"do":@"1",@"data[content]":@"明细",@"data[type]":@"1",@"data[rise]":_gongsi.selected?titou:@"个人"};
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=invoice",MATROJP_BASE_URL];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    [MLHttpManager post:url params:params m:@"product" s:@"invoice" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *inv_add = data[@"inv_add"];
            if (inv_add.count>0) {
                NSDictionary *info = [inv_add firstObject];
                NSString *ID = info[@"id"];
                if (self.invoiceBlock) {
                    self.invoiceBlock(YES,!_gongsi.selected,titou,ID);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showMessag:@"发票添加失败" toView:self.view];
            }
            
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
            [self loginAction:nil];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
    
   
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}






@end
