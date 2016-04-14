//
//  ViewController.m
//  YHTagMenu
//
//  Created by yehao on 16/4/13.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "ViewController.h"
#import "KDS_TagMenuView.h"

@interface ViewController () {
    NSMutableArray *_selectedList;
    NSMutableArray *_unSelectedList;
    BOOL _show;
}

@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self.view addSubview:self.btn];
}

#pragma mark - demo

- (void)onShowBtnClick {
    
    KDS_TagMenuView *_menuView = [[KDS_TagMenuView alloc] initWithFrame:self.view.frame];
    _menuView.selectedList = _selectedList;
    _menuView.unSelectedList = _unSelectedList;
    [_menuView showInView:self.view withCompletion:^(BOOL selectSingle, KDS_TagModel *selectItem, BOOL hasChanged, NSArray *selectedList) {
        NSLog(@" %@   %@", selectItem, selectedList);
        if (hasChanged) {
            NSLog(@"数组发生了变化，需要更新界面");
        }
        if (selectItem) { // 点击了单个
            NSLog(@"点击了 %@ ,跳转", selectItem.text);
        }
    }];
}

#pragma mark  data

- (void)initData {

    NSMutableArray *array = @[@"帅气",@"完美大人",@"好给力",@"好厉害",@"编程高手",@"设计师",@"有品位",@"色彩玩家",@"颜值高",@"善于沟通",@"牛逼闪闪",@"哈哈",@"潜力股",@"富二代",@"跑车一族",@"牛叉",@"泡妞高手",@"萝莉控",@"爱喝啤酒",@"外星人",@"妹子",@"妞妞",@"瓦窑",@"丽丽",@"土豪",@"冲锋枪啊",].mutableCopy;
    NSMutableArray *_dataArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        KDS_TagModel *t = [[KDS_TagModel alloc] init];
        t.index = i;
        t.text = array[i];
        [_dataArray addObject:t];
    }
    
    NSMutableArray *selectedList = [NSMutableArray array];
    NSMutableArray *unSelectedList = [NSMutableArray array];
    
    for (int i=0 ; i < _dataArray.count; i++) {
        if (i<8) {
            [selectedList addObject:_dataArray[i]];
        }else{
            [unSelectedList addObject:_dataArray[i]];
        }
    }
    _selectedList = selectedList;
    _unSelectedList = unSelectedList;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
        [_btn addTarget:self action:@selector(onShowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"show" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _btn;
}

@end
