//
//  MLGoodsLikeCollectionViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGuessLikeModel.h"

#define kGoodsLikeCollectionViewCell  @"goodsLikeCollectionViewCell"
@interface MLGoodsLikeCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)MLGuessLikeModel *likeModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
