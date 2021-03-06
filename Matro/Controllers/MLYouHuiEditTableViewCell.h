//
//  MLYouHuiEditTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommitOrderListModel.h"


typedef void(^YouHuiEditBlock)();
typedef void(^YouHuiWarningBlock)(NSString*);

#define kYouHuiEditTableViewCell @"youHuiEditTableViewCell"
@interface MLYouHuiEditTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
}
@property (weak, nonatomic) IBOutlet UILabel *yuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *editField;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,copy)YouHuiEditBlock changeBlock;
@property (nonatomic,strong)MLYouHuiQuanModel *youHuiQuan;
@property (nonatomic,strong)MLOrderCartModel *cartModel;
@property (nonatomic,copy)YouHuiWarningBlock youhuiWarning;
@property (strong,nonatomic)NSMutableArray *array;
@property (strong,nonatomic)NSMutableDictionary *dic1;
@property (strong,nonatomic)NSMutableDictionary *dic2;
@property BOOL isSubback;



@end
