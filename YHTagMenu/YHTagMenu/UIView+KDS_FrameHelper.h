//
//  UIView+KDS_FrameHelper.h
//  KDS_Phone
//
//  Created by yehot on 15/10/14.
//  Copyright (c) 2015年 kds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KDS_FrameHelper)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

/**
 *  中心点的x
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *  中心点的y
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 *  底部y
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 *  右侧x
 */
@property (nonatomic, assign) CGFloat right;

/**
 *  起点（x:y）
 */
@property (nonatomic, assign) CGPoint origin;

/**
 *  与指定view等高
 *
 *  @param view 目标view
 */
- (void)heightEqualToView:(UIView *)view;
- (void)widthEqualToView:(UIView *)view;
- (void)sizeEqualToView:(UIView *)view;

/**
 *  与superview等宽
 */
- (void)fillWidth;
- (void)fillHeight;
- (void)fill;

@end
