//
//  KDS_TagCell.h
//  YHTagMenu
//
//  Created by yehao on 16/4/13.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDS_TagModel.h"



@interface KDS_TagCell : UICollectionViewCell

- (void)setModel:(KDS_TagModel *)model withEditor:(BOOL)isEditing;

@end
