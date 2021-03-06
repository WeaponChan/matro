//
//  MLShopCartCollectionViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPStepper.h"
#import "MLShopingCartlistModel.h"
#import "MLCheckBoxButton.h"
#import "OffLlineShopCart.h"


typedef void(^ShopCartDelBlock)();
typedef void(^ShopCartCheckBoxBlock)(BOOL);
#define kShopCartCollectionViewCell   @"shopCartCollectionViewCell"
@interface MLShopCartCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet CPStepper *countField;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;


@property (nonatomic,strong)MLProlistModel *prolistModel;
@property (nonatomic,copy)ShopCartCheckBoxBlock shopCartCheckBoxBlock;
@property (nonatomic,copy)ShopCartDelBlock shopCartDelBlock;
@property (nonatomic,strong)OffLlineShopCart *offlineCart;


@property (weak, nonatomic) IBOutlet UIView *line;


@property (weak, nonatomic) IBOutlet UILabel *manjianLabel;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImgL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodNameL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodDescL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsTop;

@end
