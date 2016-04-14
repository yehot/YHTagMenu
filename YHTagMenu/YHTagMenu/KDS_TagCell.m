//
//  KDS_TagCell.m
//  YHTagMenu
//
//  Created by yehao on 16/4/13.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "KDS_TagCell.h"
#import "KDS_TagMenuConstant.h"

@interface KDS_TagCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIView *bgView;

@property (nonatomic, strong) UIImageView *deleteImageView;

@end

@implementation KDS_TagCell

UIColor * RGBColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deleteImageView];
    }
    return self;
}

#pragma mark - setter

- (void)setModel:(KDS_TagModel *)model withEditor:(BOOL)isEditing{

    self.titleLabel.text = model.text;
    if (model.index < kUnEditorTagCount) {
        self.bgView.backgroundColor = RGBColor(75, 151, 249, 1);
    } else {
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    if (isEditing) {
        self.deleteImageView.hidden = NO;
    } else {
        self.deleteImageView.hidden = YES;
    }
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        
        //TODO: 圆角问题
        _bgView.layer.cornerRadius = 13;
        _bgView.layer.borderColor = RGBColor(237, 237, 237, 1).CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)deleteImageView {
    if (!_deleteImageView) {
        _deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _deleteImageView.image = [UIImage imageNamed:@"tag_delete_Image"];
        _deleteImageView.hidden = YES;
    }
    return _deleteImageView;
}

@end
