//
//  MLOrderInfoFooterTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"

#define kOrderInfoFooterTableViewCell  @"orderInfoFooterTableViewCell"

typedef void(^LeftCancelAction)();
typedef void(^LeftShouHuoAction)();
typedef void(^LeftPingJiaAction)();
typedef void(^LeftKanPingJiaAction)();
typedef void(^LeftKanTuiHuo)();



typedef void(^RightZhuiZongAction)();
typedef void(^RightTuiHuoAction)();
typedef void(^RightFuKuanAction)();
typedef void (^RightShanchuAction)();
typedef void (^WanshanAction)();



@interface MLOrderInfoFooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)MLPersonOrderModel *orderList;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *wanshanBtn;
@property (weak, nonatomic) IBOutlet UIView *wanshanView;

@property (nonatomic,copy)LeftKanTuiHuo leftKanTuiHuo;
@property (nonatomic,copy)LeftCancelAction cancelAction;
@property (nonatomic,copy)LeftShouHuoAction shouHuoAction;
@property (nonatomic,copy)LeftPingJiaAction pingJiaAction;
@property (nonatomic,copy)LeftKanPingJiaAction kanPingJiaAction;
@property (nonatomic,copy)RightZhuiZongAction zhuiZongAction;
@property (nonatomic,copy)RightTuiHuoAction tuiHuoAction;
@property (nonatomic,copy)RightFuKuanAction fuKuanAction;
@property (nonatomic,copy)RightShanchuAction shanchuAction;
@property (nonatomic,copy)WanshanAction wanshanAction;

@end
