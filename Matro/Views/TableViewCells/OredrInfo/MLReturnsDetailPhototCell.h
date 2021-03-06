//
//  MLReturnsDetailPhototCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kReturnsDetailPhototCell  @"returnsDetailPhototCell"



typedef void(^ReturnPhotoClick)(NSInteger);

@interface MLReturnsDetailPhototCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *imgsArray;
@property (nonatomic,copy)ReturnPhotoClick returnPhotoClick;

@end
