//
//  MLOrderCommentViewController.h
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import "MLPersonOrderDetail.h"


typedef void(^PingJiaChengGong)();

@interface MLOrderComViewController : MLBaseViewController
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)PingJiaChengGong pingjiachenggong;


@end
