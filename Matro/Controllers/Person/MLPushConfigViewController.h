//
//  MLPushConfigViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"


typedef void(^RemoveAllMessage)();

@interface MLPushConfigViewController : MLBaseViewController
@property (nonatomic,copy)RemoveAllMessage removeAllMessage;

@end
