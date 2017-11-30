//
//  YLGridTableViewCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLGridTableViewCell.h"
#import "Masonry.h"
#import "YLGridItemCell.h"
NSString *const kYLGridItemImage = @"kYLGridItemImage";
NSString *const kYLGridItemTitle = @"kYLGridItemTitle";

NSString *const YLGridTableViewCellIdentifier = @"YLGridTableViewCellIdentifier";
@interface YLGridTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YLGridTableViewCell
- (void)layoutSubviews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    YLGridItemCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:YLGridItemCellIdentifier
                                                                       forIndexPath:indexPath];

    
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item < [self.items count]) {
        cell.imageView.image = self.items[indexPath.item][kYLGridItemImage];
        cell.titleLabel.text = self.items[indexPath.item][kYLGridItemTitle];
        [cell.titleLabel sizeToFit];
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ceil((CGFloat)[self.items count] / self.columnCount) * self.columnCount;
}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < [self.items count]) {
//        UICollectionViewCell * cell  = [collectionView cellForItemAtIndexPath:indexPath];
//        cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < [self.items count]) {
//        UICollectionViewCell * cell  = [collectionView cellForItemAtIndexPath:indexPath];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [self.items count]) {
        [self.delegate gridItemDidClickAtIndex:indexPath.item];
    }
}




#pragma mark - getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
        CGFloat itemWidth =  floor(width / self.columnCount);
        
        layout.itemSize = CGSizeMake(itemWidth, YLGridItemCellHeight);
        _collectionView =  [[UICollectionView alloc]initWithFrame:self.frame
                                             collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.clipsToBounds = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(5, 20, 5, 20);
        [self addSubview:_collectionView];
        [_collectionView registerClass:[YLGridItemCell class] forCellWithReuseIdentifier:YLGridItemCellIdentifier];
    }
    return _collectionView;
}

- (NSInteger)columnCount {
    return MAX(_columnCount, 1);
}
@end
