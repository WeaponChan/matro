//
//  MLServiceMainController.m
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLServiceMainController.h"
#import "MLReturnsViewController.h"
#import "MLReturnsRecordViewController.h"

@interface MLServiceMainController ()

@end

@implementation MLServiceMainController

- (instancetype)init
{
    if (self = [super init])
    {
        self.menuViewStyle                   = WMMenuViewStyleLine;
        self.titleColorSelected              = RGBA(174, 142, 93, 1);
        self.titleColorNormal                = RGBA(14, 14, 14, 1);
        self.progressColor                   = RGBA(174, 142, 93, 1);
        self.titleSizeSelected               = 15;
        self.pageAnimatable                  = YES;
        self.titleSizeNormal                 = 15;
        self.menuHeight                      = 40;
        self.menuItemWidth                   = MAIN_SCREEN_WIDTH/4;
        self.postNotification                = YES;
        self.itemMargin                      = 0.f;
        self.bounces                         = NO;
        self.menuBGColor                     = [UIColor whiteColor];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 2; i++) {
            Class vcClass;
            NSString *title;
            switch (i%2) {
                case 0:
                    vcClass = [MLReturnsViewController class];
                    title = @"申请退货";
                    break;
                case 1:
                    vcClass = [MLReturnsRecordViewController class];
                    title = @"退货记录";
                    break;
                default:
                    break;
            }
            [viewControllers addObject:vcClass];
            [titles addObject:title];
        }
        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退货";
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
}


- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
