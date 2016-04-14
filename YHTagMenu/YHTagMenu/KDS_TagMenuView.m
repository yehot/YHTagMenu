//
//  KDS_TagMenuView.m
//  YHTagMenu
//
//  Created by yehao on 16/4/13.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "KDS_TagMenuView.h"
#import "UIView+KDS_FrameHelper.h"
#import "KDS_TagCell.h"
#import "KDS_TagMenuConstant.h"
#import "LewReorderableLayout.h"

static NSString *const kCellID = @"cellID";
static NSString *const kHeaderViewID = @"headView";

// 顶部view高度
static CGFloat const kTopHeaderViewHeight = 80;
// 顶部最右侧 关闭按钮宽度
static CGFloat const kCloseButtonWidth = 50;

static CGFloat const kMinimumLineSpacing = 10;   ///< 每行的间距
static CGFloat const kMinimumInteritemSpacing = 10; ///< cell最小间距

static CGFloat const kSectionEdgeInsetsLeft = 15;
static CGFloat const kSectionEdgeInsetsBottom = 15;
static CGFloat const kSectionEdgeInsetsTop = 15;
static CGFloat const kSectionEdgeInsetsRight = 15;

@interface KDS_TagMenuView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, LewReorderableLayoutDelegate, LewReorderableLayoutDataSource> {
    KSelectCompletion _completionBlock;
}

@property (nonatomic, strong) UIView *topHeaderView;
@property (nonatomic, strong) UILabel *topLeftLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isInEditing; ///< 是否正在编辑中

/**
 *  记录选择了某个选项（点击后，会dismiss）
 */
@property (nonatomic, copy) KDS_TagModel *recoderSelectSingleModel;

/**
 *  记录最初的list，用于比对
 */
@property (nonatomic, strong) NSMutableArray *recoderSelectList;

@end

@implementation KDS_TagMenuView

UIColor * kds_RGBColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kds_RGBColor(244, 242, 242, 0.9);
        [self addSubview:self.topHeaderView];
        [self addSubview:self.collectionView];
        _isInEditing = NO;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - public

- (void)showInView:(UIView *)superView withCompletion:(KSelectCompletion)completion {
    _completionBlock = completion;
    
    [superView addSubview:self];
    self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

#pragma mark - Action

// 编辑按钮点击
- (void)editButtonClick:(UIButton *)sender {

    _isInEditing = !_isInEditing;
    
    if (_isInEditing) { // 编辑中
        
        _topLeftLabel.text = kTopLeftLabelEditingText;
        [sender setTitle:kTopEditButtonEditingText forState:UIControlStateNormal];
        
        //1、更改 section1 cell 样式
        //2、 隐藏 section 2
    } else {
        _topLeftLabel.text = kTopLeftLabelNormalText;
        [sender setTitle:kTopEditButtonNormalText forState:UIControlStateNormal];
    }
    [_collectionView reloadData];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);

                     } completion:^(BOOL finished) {
                         [self sendCallBackBlock];
                         [self removeFromSuperview];
                     }];
}

- (void)sendCallBackBlock {
    // 是否选择了单个 item
    BOOL selectSingle = NO;
    if (_recoderSelectSingleModel) {
        selectSingle = YES;
    }
    
    // 判断是否发生了变化
    BOOL hasChanged = [self compareOldArray:self.recoderSelectList withArray:self.selectedList];
    
    if (_completionBlock) {
        _completionBlock(selectSingle, _recoderSelectSingleModel, hasChanged, _selectedList);
    }
}

#pragma mark - delegate

#pragma mark  CollectionView dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDS_TagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    KDS_TagModel *model;
    if (indexPath.section==0) {
        model = self.selectedList[indexPath.row];
    }else if(indexPath.section == 1){
        model = self.unSelectedList[indexPath.row];
    }
    [cell setModel:model withEditor:_isInEditing];
//    cell.model = model;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger items = 1;
    if (section == 0) {
        items = [self.selectedList count];
    }else if (section == 1){
        items = [self.unSelectedList count];
    }
    return items;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_isInEditing) {
        return 1;
    } else {
        return 2;
    }
}

// 组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            view.hidden = YES;
        }
        if (indexPath.section == 1 && !_isInEditing) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 40)];
            label.text = [NSString stringWithFormat:kMiddleTipString];
            label.textColor = [UIColor blackColor];
            [view addSubview:label];
            view.backgroundColor = kds_RGBColor(225, 225, 225, 0.7);
            view.hidden = NO;
        }
        reusableview = view;
    }
    return reusableview;
    
}

#pragma mark  CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        //TODO: 这里提供接口改由数据源控制
        // 前4个不能编辑
        if (indexPath.row < kUnEditorTagCount) {
            return;
        }
        //insert 到原来的位置
        KDS_TagModel *model = self.selectedList[indexPath.row];
        
        if (!_isInEditing) {    //非编辑中，跳转
            //点击的数据传递出去
            _recoderSelectSingleModel = model;
            [self dismiss];
        } else {    // 编辑中，删除
            NSLog(@"点击了 %@ ,移除", model.text);
            NSInteger index = [self getObjectInListIndex:model];
            [self.unSelectedList insertObject:model atIndex:index];
            [self.selectedList removeObjectAtIndex:indexPath.row];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        
    }else if(indexPath.section == 1){
        [self.selectedList addObject:self.unSelectedList[indexPath.row]];
        [self.unSelectedList removeObjectAtIndex:indexPath.row];
        
        NSIndexPath *newIndexPath =[NSIndexPath indexPathForItem:self.selectedList.count-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

#pragma mark  UICollectionViewDelegateFlowLayout

// section 的边界范围 (每个Section 的 margin )
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets inset = UIEdgeInsetsMake(kSectionEdgeInsetsTop, kSectionEdgeInsetsLeft, kSectionEdgeInsetsBottom, kSectionEdgeInsetsRight);
    return inset;
}

// 每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMinimumLineSpacing;
}

//  每行cell item的 最小 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMinimumInteritemSpacing;
}

// cell 默认 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{    
    return CGSizeMake(80, 26);
}

// footerView的 size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, CGFLOAT_MIN);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
}

#pragma mark  LewReorderableLayoutDelegate

// 能否编辑
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isInEditing) { // 编辑中
        if (indexPath.section == 0 && indexPath.row < kUnEditorTagCount) {
            return NO;
        }
        if ([collectionView numberOfItemsInSection:indexPath.section] <= 1) {
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
    UIImage *image = nil;
    if (fromIndexPath.section == 0) {
        image = self.selectedList[fromIndexPath.item];
        [self.selectedList removeObjectAtIndex:fromIndexPath.item];
    }else{
        image = self.unSelectedList[fromIndexPath.item];
        [self.unSelectedList removeObjectAtIndex:fromIndexPath.item];
    }
    
    if (toIndexPath.section == 0) {
        [self.selectedList insertObject:image atIndex:toIndexPath.item];
    }else{
        [self.unSelectedList insertObject:image atIndex:toIndexPath.item];
    }
}

#pragma mark - private

//查询对象插入到原来合适的位置
- (NSInteger)getObjectInListIndex:(KDS_TagModel *)m{
    //把m丢到List中，然后排序一下，找到str在List中的位置
    if (m) {
        [self.unSelectedList addObject:m];
        [self.unSelectedList sortUsingComparator:^NSComparisonResult(KDS_TagModel *obj1, KDS_TagModel *obj2) {
            NSInteger index1 = obj1.index;
            NSInteger index2 = obj2.index;
            return index1 > index2;
        }];
        NSInteger index = [self.unSelectedList indexOfObject:m];
        [self.unSelectedList removeObject:m];
        return index;
    }
    return [self.unSelectedList count]+1;
}

- (BOOL)compareOldArray:(NSArray *)oldArray withArray:(NSArray *)newArray {
    BOOL hasChanged = NO;
    
    if (oldArray.count != newArray.count) {
        hasChanged = YES;
    } else {
        for (int i = 0; i < oldArray.count; i++) {
            KDS_TagModel *modelOld = oldArray[i];
            KDS_TagModel *modelNew = newArray[i];
            if (![modelOld.text isEqualToString:modelNew.text]) {
                hasChanged = YES;
                break;
            }
        }
    }
    return hasChanged;
}

#pragma mark - getter

- (UIView *)topHeaderView {
    if (!_topHeaderView) {
        _topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTopHeaderViewHeight)];
//        _topHeaderView.backgroundColor = [UIColor yellowColor];
        [_topHeaderView addSubview:self.topLeftLabel];
        [_topHeaderView addSubview:self.editButton];
        [_topHeaderView addSubview:self.closeButton];
    }
    return _topHeaderView;
}

- (UILabel *)topLeftLabel {
    if (!_topLeftLabel) {
        _topLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, kTopHeaderViewHeight)];
        _topLeftLabel.text = kTopLeftLabelNormalText;
    }
    return _topLeftLabel;
}

- (UIButton *)editButton {
    if (!_editButton) {
        CGFloat width = 100;
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topHeaderView.width - kCloseButtonWidth - width, 0, width, 30)];
        _editButton.centerY = self.topHeaderView.centerY;
        [_editButton setTitle:kTopEditButtonNormalText forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.layer.borderWidth = 1;
        _editButton.layer.cornerRadius = 10;
        _editButton.layer.borderColor = [UIColor redColor].CGColor;
        
    }
    return _editButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topHeaderView.width - kCloseButtonWidth, 0, kCloseButtonWidth, kTopHeaderViewHeight)];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LewReorderableLayout *layout = [[LewReorderableLayout alloc] init];
        layout.delegate = self;
        layout.dataSource = self;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topHeaderView.bottom, self.width, self.height - kTopHeaderViewHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[KDS_TagCell class] forCellWithReuseIdentifier:kCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewID];
    }
    return _collectionView;
}

#pragma mark - setter

- (void)setUnSelectedList:(NSMutableArray *)unSelectedList {
    _unSelectedList = unSelectedList.mutableCopy;
}

- (void)setSelectedList:(NSMutableArray *)selectedList {
    _selectedList = selectedList.mutableCopy;
    _recoderSelectList = selectedList.copy;
}

@end
