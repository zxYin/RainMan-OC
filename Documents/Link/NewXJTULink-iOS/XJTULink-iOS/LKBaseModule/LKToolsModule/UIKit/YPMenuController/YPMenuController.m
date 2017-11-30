//
//  WeekMenuController.m
//  MenuTest
//
//  Created by Yunpeng on 16/4/23.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YPMenuController.h"
#import "YPMenuCell.h"

//static const NSInteger Scale = 0.35;
@interface YPMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign,nonatomic) NSInteger selectedIndex;
@end

@implementation YPMenuController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _hidden = YES;
        _selectedIndex = -1;
    }
    return self;
}

- (instancetype)initWithBlock:(ClickEvent)block {
    self = [super init];
    if (self != nil) {
        _hidden = YES;
        _clickEventBlock = [block copy];
        _selectedIndex = -1;
    }
    return self;
}

- (instancetype)initWithBlock:(ClickEvent)block initialSelections:(NSInteger)index {
    self = [super init];
    if (self != nil) {
        _hidden = YES;
        _clickEventBlock = [block copy];
        _selectedIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = YES; // 默认不显示
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];    
    [self updateSelect];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewDidClick)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UINib *nib = [UINib nibWithNibName:@"YPMenuCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:YPMenuCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)backgroundViewDidClick {
    self.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:YPMenuCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = _items[indexPath.row];
    
    cell.titleLabel.highlightedTextColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = self.highlightedCellColor;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _clickEventBlock(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YPMenuCellHeight;
}
- (void)updateSelect {
    if (_selectedIndex < 0 && _selectedIndex >= _items.count)  {
        _selectedIndex = 0;
    }
    
    NSLog(@"选中%td",_selectedIndex);
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    if (_selectedIndex >= 1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
- (void)selectIndex:(NSInteger)index {
    _selectedIndex = index;
    [self updateSelect];
}

//- (BOOL)isHidden {
//    return self.view.isHidden;
//}

- (void)setHidden:(BOOL)hidden {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (hidden) {
        _hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            self.view.hidden = YES;
            self.view.alpha = 1.0;
        }];
    } else {
        _hidden = NO;
        self.view.hidden = NO;
        if(_selectedIndex >=2 && _selectedIndex < self.items.count - 5) {
            self.tableView.frame = CGRectMake(0, -YPMenuCellHeight * 6, screenSize.width, YPMenuCellHeight * 6);
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex-2 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
            
            [UIView animateWithDuration:1.0
                                  delay:0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionTransitionFlipFromTop
                             animations:^{
                                 self.tableView.frame = CGRectMake(0, -YPMenuCellHeight, screenSize.width, YPMenuCellHeight * 6);
                             } completion:^(BOOL finished) {
                                 if(_selectedIndex >= 1 ) {
                                     [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex-1 inSection:0]
                                                       atScrollPosition:UITableViewScrollPositionTop
                                                               animated:NO];
                                 }
                                 self.tableView.frame = CGRectMake(0, 0, screenSize.width, YPMenuCellHeight * 5);
                             }];
        } else {
            NSInteger maxCount = MIN(self.items.count, 5);
            self.tableView.frame = CGRectMake(0, -YPMenuCellHeight * maxCount, screenSize.width, YPMenuCellHeight * maxCount);
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.frame = CGRectMake(0, 0, screenSize.width, YPMenuCellHeight * maxCount);
            }];
        }
        
    }
}


@end
