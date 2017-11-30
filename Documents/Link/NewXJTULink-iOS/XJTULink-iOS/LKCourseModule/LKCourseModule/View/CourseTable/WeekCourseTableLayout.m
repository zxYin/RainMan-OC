//
//  WeekCalendarLayout.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import "WeekCourseTableLayout.h"
#import "ViewsConfig.h"
static const NSInteger DaysPerWeek = 7;
static const NSInteger CoursesPerDay = 11;
static const CGFloat HorizontalSpacing = 2;
static const CGFloat VerticalSpacing = 2;
//static const CGFloat HeightPerCourse = 45;
static const CGFloat DayHeaderHeight = 50;
static const CGFloat SideHeaderWidth = 25;
#define HeightPerCourse ((MainScreenSize.height - 64 - DayHeaderHeight - 44)/11)
@interface WeekCourseTableLayout ()

@end

@implementation WeekCourseTableLayout

#pragma mark - UICollectionViewLayout Implementation

- (CGSize)collectionViewContentSize {
    
    
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = DayHeaderHeight + (HeightPerCourse * CoursesPerDay);
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];

    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    NSArray *SideHeaderViewIndexPaths = [self indexPathsOfSideHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in SideHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"SideHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<WeekCourseTableLayoutDataSource> dataSource = (id<WeekCourseTableLayoutDataSource>)self.collectionView.dataSource;
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForCourseViewModel:[dataSource courseViewModelAtIndexPath:indexPath]];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - SideHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(SideHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        attributes.zIndex = -10;
    } else if ([kind isEqualToString:@"SideHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerCourse * indexPath.item - 1, totalWidth, HeightPerCourse);
        attributes.zIndex = -10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Helpers

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleCourse = [self courseIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleCourse = [self courseIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    id<WeekCourseTableLayoutDataSource> dataSource = (id<WeekCourseTableLayoutDataSource>)self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minCourseIndex:minVisibleCourse maxCourseIndex:maxVisibleCourse];
    return indexPaths;
}

- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition {
    CGFloat contentWidth = [self collectionViewContentSize].width - SideHeaderWidth;
    CGFloat widthPerDay = contentWidth / DaysPerWeek;
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)((xPosition - SideHeaderWidth) / widthPerDay));
    return dayIndex;
}

- (NSInteger)courseIndexFromYCoordinate:(CGFloat)yPosition {
    NSInteger courseIndex = MAX((NSInteger)0, (NSInteger)((yPosition - DayHeaderHeight) / HeightPerCourse));
    return courseIndex;
}

- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect {
    if (CGRectGetMinY(rect) > DayHeaderHeight) {
        return [NSArray array];
    }
    
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray *)indexPathsOfSideHeaderViewsInRect:(CGRect)rect {
    if (CGRectGetMinX(rect) > SideHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger mincourseIndex = [self courseIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxcourseIndex = MIN([self courseIndexFromYCoordinate:CGRectGetMaxY(rect)],CoursesPerDay-1);
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = mincourseIndex; idx <= maxcourseIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (CGRect)frameForCourseViewModel:(CourseViewModel *)viewModel {
    CGFloat totalWidth = [self collectionViewContentSize].width - SideHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;

    CGRect frame = CGRectZero;
    frame.origin.x = SideHeaderWidth + widthPerDay * viewModel.dayIndex + 1;
    frame.origin.y = DayHeaderHeight + HeightPerCourse * viewModel.startIndex;
    frame.size.width = widthPerDay;
    frame.size.height = viewModel.length * HeightPerCourse;
    frame = CGRectInset(frame, HorizontalSpacing/2.0, VerticalSpacing/2.0);
    return frame;
}

@end
