//
//  MLPersonOrderDetailFootView.m
//  Matro
//
//  Created by MR.Huang on 16/6/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderDetailFootView.h"

@implementation MLPersonOrderDetailFootView

+ (MLPersonOrderDetailFootView *)detailFooterView{
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLOrderDetailFootView" owner:self options:nil];
    if (arrayOfViews.count>0) {
        return [arrayOfViews firstObject];
    }
    return nil;
}



- (void)setFooterType:(FooterType)footerType{
    NSLog(@"self.partial_return===%ld",self.partial_return);
    
    if (_footerType != footerType) {
        _footerType = footerType;
        switch (_footerType) {
            case FooterTypeDaifahuo:
            {
                self.orderTime.hidden = NO;
                self.shengyufukuanLb.hidden = NO;
                self.daojishiLb.hidden = YES;
                self.payBtn.hidden = YES;
                self.cancelBtn.hidden = YES;
                self.shenyuLb.hidden = YES;
            }
                break;
            case FooterTypeDaifukuan:
            {
                self.orderTime.hidden = YES;
                self.shengyufukuanLb.hidden = YES;
                self.daojishiLb.hidden = NO;
                self.payBtn.hidden = NO;
                self.cancelBtn.hidden = NO;
                self.shenyuLb.hidden = NO;
                [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self.payBtn setTitle:@"付款" forState:UIControlStateNormal];
                
            }
                break;
            case FooterTypeDaiQueren:
            {
                if (self.partial_return == 0) {
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = NO;
                    self.shenyuLb.hidden = YES;
                    [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                }else if (self.partial_return == 1){
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
//                    [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    
                }else if (self.partial_return == 2){
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
//                    [self.cancelBtn setTitle:@"售后进度" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"售后进度" forState:UIControlStateNormal];
                    
                }else{
                
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
                    // [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                }
                
            }
                break;
            case FooterTypeDaishouhuo:
            {
//                self.orderTime.hidden = YES;
//                self.shengyufukuanLb.hidden = YES;
//                self.daojishiLb.hidden = YES;
//                self.payBtn.hidden = NO;
//                self.cancelBtn.hidden = NO;
//                self.shenyuLb.hidden = YES;
//                [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
//                [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                
                if (self.partial_return == 0) {
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
//                    [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
//                    [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                }else if (self.partial_return == 1){
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = YES;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
//                    [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
//                    [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    
                }else if (self.partial_return == 2){
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
//                    [self.cancelBtn setTitle:@"售后进度" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"售后进度" forState:UIControlStateNormal];
                    
                }
                
            }
                break;
            case FooterTypeJiaoyiguanbi:
            {
                self.orderTime.hidden = YES;
                self.shengyufukuanLb.hidden = YES;
                self.daojishiLb.hidden = YES;
                self.payBtn.hidden = NO;
                self.cancelBtn.hidden = YES;
                self.shenyuLb.hidden = YES;
                [self.payBtn setTitle:@"删除" forState:UIControlStateNormal];
            }
                break;
            case FooterTypeJiaoyichenggong:
            {
                if (self.partial_return == 0) {
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = NO;
                    self.shenyuLb.hidden = YES;
                    [self.cancelBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                }else if (self.partial_return == 1){
                    if (self.return_status == -1) {
                        self.orderTime.hidden = YES;
                        self.shengyufukuanLb.hidden = YES;
                        self.daojishiLb.hidden = YES;
                        self.payBtn.hidden = NO;
                        self.cancelBtn.hidden = NO;
                        self.shenyuLb.hidden = YES;
                        [self.cancelBtn setTitle:@"订单追踪" forState:UIControlStateNormal];
                        [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                    }else{
                        self.orderTime.hidden = YES;
                        self.shengyufukuanLb.hidden = YES;
                        self.daojishiLb.hidden = YES;
                        self.payBtn.hidden = NO;
                        self.cancelBtn.hidden = YES;
                        self.shenyuLb.hidden = YES;
                        [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                    }
                    
                }else if (self.partial_return == 2){
                
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = NO;
                    self.shenyuLb.hidden = YES;
                    [self.cancelBtn setTitle:@"售后进度" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                }else if(self.partial_return == -1){
                
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = NO;
                    self.shenyuLb.hidden = YES;
                    [self.cancelBtn setTitle:@"订单追踪" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                }else {
                
                    self.orderTime.hidden = YES;
                    self.shengyufukuanLb.hidden = YES;
                    self.daojishiLb.hidden = YES;
                    self.payBtn.hidden = NO;
                    self.cancelBtn.hidden = YES;
                    self.shenyuLb.hidden = YES;
                    [self.cancelBtn setTitle:@"订单追踪" forState:UIControlStateNormal];
                    [self.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                }
                
            }
                break;
            case FooterTypeQuxiao:
            {
                self.orderTime.hidden = YES;
                self.shengyufukuanLb.hidden = YES;
                self.daojishiLb.hidden = YES;
                self.payBtn.hidden = NO;
                self.cancelBtn.hidden = YES;
                self.shenyuLb.hidden = YES;
                [self.payBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            default:
                self.hidden = YES;
                break;
        }

    }
}

- (IBAction)leftAction:(id)sender {
    switch (_footerType) {
        case FooterTypeDaifahuo:
        {
        }
            break;
        case FooterTypeDaiQueren:{
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeTuiKuan);
            }
        }
        break;
        case FooterTypeDaifukuan:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeQuxiao);
            }
        }
            break;
        case FooterTypeDaishouhuo:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeTuiKuan);
            }
        }
            break;
        case FooterTypeJiaoyichenggong:{
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeJiaoyichenggong);
            }
        }
        default:
            break;
    }

}
- (IBAction)rightAction:(id)sender {
    switch (_footerType) {
        case FooterTypeDaifahuo:
        {
        }
            break;
        case FooterTypeDaifukuan:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeFukuan);
            }
        }
            break;
        case FooterTypeDaishouhuo:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeQuerenshouhuo);
            }
        }
            break;
        case FooterTypeDaiQueren:{
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeQuerenshouhuo);
            }
        }
           break;
        case FooterTypeJiaoyiguanbi:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeShanchu);
            }
        }
            break;
        case FooterTypeJiaoyichenggong:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypePingJia);
            }
        }
            break;
        case FooterTypeQuxiao:
        {
            if (self.orderDetailButtonActionBlock) {
                self.orderDetailButtonActionBlock(ButtonActionTypeShanchu);
            }
        }
            break;
        default:
            break;
    }
}


@end
