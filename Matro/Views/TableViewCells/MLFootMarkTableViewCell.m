//
//  MLFootMarkTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFootMarkTableViewCell.h"
#import "Masonry.h"


@implementation MLFootMarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:right];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:left];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

/*
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (!_showDel) {
            [UIView animateWithDuration:0.2 animations:^{
                self.countL.constant = 8 + 80;
                self.checkBoxL.constant = 16 - 80;
                self.actL.constant = 39 - 80;
                
            } completion:^(BOOL finished) {
                _showDel = YES;
            }];
        }
        
    }
    else{//收齐
        [UIView animateWithDuration:0.2 animations:^{
            self.countL.constant = 8;
            self.checkBoxL.constant = 16;
            self.actL.constant = 39;
        } completion:^(BOOL finished) {
            _showDel = NO;
        }];
    }
}
*/


- (void)leftAction:(UISwipeGestureRecognizer *)sender{
    
    [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImageView.mas_right);
        make.right.equalTo(self.mas_right);
    }];
    
    
    
    
}

- (void)rightAction:(UISwipeGestureRecognizer *)sender{
    
    [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.mas_right);
    }];
}



- (IBAction)addCartClick:(id)sender {
    if (self.footMarkAddCartBlock) {
        self.footMarkAddCartBlock();
    }
}

- (IBAction)delAction:(id)sender {
    if (self.footMarkDeleteBlock) {
        self.footMarkDeleteBlock();
    }
    
}


/**
 *  拦截frame的设置
 */
/*
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 8;
    frame.origin.x = 8;
    frame.size.width -= 2 * 8;
    frame.size.height -= 8;
    [super setFrame:frame];
}
*/

@end
