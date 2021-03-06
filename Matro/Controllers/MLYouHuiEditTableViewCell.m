//
//  MLYouHuiEditTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLYouHuiEditTableViewCell.h"
#import "HFSConstants.h"
#import "NSString+GONMarkup.h"

static NSInteger k;
@implementation MLYouHuiEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dic1 = [NSMutableDictionary dictionary];
    self.dic2 = [NSMutableDictionary dictionary];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.cornerRadius = 4.f;
    self.editField.layer.masksToBounds = YES;
    self.editField.layer.cornerRadius = 4.f;
    self.editBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.editBtn.layer.borderWidth = 1.f;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2,25)];
    self.editField.leftView = leftView;
    self.editField.leftViewMode = UITextFieldViewModeAlways;
    self.editField.delegate = self;
}

- (void)setYouHuiQuan:(MLYouHuiQuanModel *)youHuiQuan{
    
    if (_youHuiQuan != youHuiQuan) {
        _youHuiQuan = youHuiQuan;
        NSString *attr =[NSString stringWithFormat:@"<font size=\"14\"><color value=\"#999999\">可用余额</><color value=\"#FF4E25\">￥%.2f</></>",_youHuiQuan.payable];
        self.yuLabel.attributedText = [attr createAttributedString];
        self.nameLabel.text = _youHuiQuan.name;
        if (self.isSubback == YES) {
            if (_youHuiQuan.useSum > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_youHuiQuan.useSum];
            }
        }else{
            if (_youHuiQuan.useSum > 0) {
                self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_youHuiQuan.useSum];
            }else{
                self.editField.text = @""; //清空之前输入的金额
                self.editField.hidden= NO;
                self.priceLabel.text = @"￥";
                [self.editBtn setTitle:@"使用" forState:UIControlStateNormal];
            }
        }
        
    }
}


- (IBAction)useClick:(id)sender { //使用按钮
    UIButton *btn = (UIButton *)sender;
        if ([btn.titleLabel.text isEqualToString:@"使用"]) {//点击使用的时候事件
            if( ![self isPureFloat:self.editField.text]){
                if (self.youhuiWarning) {
                    self.youhuiWarning(@"含非法字符，请输入数字");
                }
                return;
            }
            
            float useMoney = [self.editField.text floatValue];
            
            
            if (useMoney > self.youHuiQuan.payable ) { //小于等于可支付金额时
                if (self.youhuiWarning) {
                    self.youhuiWarning(@"不能超过优惠券使用金额");
                }
                return;
            }
            
            if (useMoney > self.cartModel.realYouHuiQuan) {//如果超过 直接提示错误 退出
                if (self.youhuiWarning) {
                    self.youhuiWarning(@"优惠券金额不能超过商品金额");
                }
                return;
            }
            
                self.youHuiQuan.useSum = useMoney;
                self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_youHuiQuan.useSum];
                self.editField.hidden = YES;
                [btn setTitle:@"取消" forState:UIControlStateNormal];

           
    }else{ //点击取消时
            self.editField.text = @""; //清空之前输入的金额
            self.editField.hidden= NO;
            self.youHuiQuan.useSum = 0;
            self.priceLabel.text = @"￥";
            [btn setTitle:@"使用" forState:UIControlStateNormal];
        }
    if (self.changeBlock) {
        self.changeBlock();
    }

}

//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//if( )
//{
//    resultLabel.textColor = [UIColor redColor];
//    resultLabel.text = @"警告:含非法字符，请输入纯数字！";
//    return;
//}


- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
        
    }
    return _array;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField===%@",textField.text);    
    if (textField == self.editField) {
        float useMoney = [self.editField.text floatValue];
        if (useMoney > self.youHuiQuan.payable){
            self.editField.text = [NSString stringWithFormat:@"%.1f",self.youHuiQuan.payable];
            
            return;
        }
    }
}

@end
