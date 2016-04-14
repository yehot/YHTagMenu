//
//  KDS_TagMenuView.h
//  YHTagMenu
//
//  Created by yehao on 16/4/13.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDS_TagModel.h"


/**
 *  menu 收起时的回调
 *
 *  @param selectSingle 是否是选择了单个的item
 *  @param selectItem   选择的单个item
 *  @param hasChanged   是否顺序、内容有修改
 *  @param selectedList 修改后的数据list
 */
typedef void(^KSelectCompletion)(BOOL selectSingle ,KDS_TagModel *selectItem, BOOL hasChanged, NSArray *selectedList);

// 内部添加一个 bool 的 flag； 添加一个编辑按钮
// 普通状态下， section1 点击了就 dismiss，并且把点击的 index 传出

// 编辑状态下，点击了删除 （第一组 可见，第二组、mid tip 都不可见；第一组 加 x）
// 从 section1 中移除一个

// 编辑状态下，拖动排序

@interface KDS_TagMenuView : UIView

// 上半栏数据源
@property (strong, nonatomic) NSMutableArray *selectedList;

// 下半栏数据源
@property (strong, nonatomic) NSMutableArray *unSelectedList;

- (void)showInView:(UIView *)superView withCompletion:(KSelectCompletion)completion;


@end
