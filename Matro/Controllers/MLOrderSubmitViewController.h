//
//  MLOrderSubmitViewController.h
//  Matro
//
//  Created by MR.Huang on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLCommitOrderListModel.h"

@interface MLOrderSubmitViewController : MLBaseViewController
@property (nonatomic,strong)MLCommitOrderListModel *order_info;
@property (nonatomic,strong)NSDictionary *params;
@property BOOL isAct;
@end
