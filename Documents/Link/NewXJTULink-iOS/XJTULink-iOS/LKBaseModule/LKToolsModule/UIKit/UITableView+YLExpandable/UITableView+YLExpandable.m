//
//  UITableView+YLExpandable.m
//  UITableView+YLExpandable
//
//  Created by Yunpeng on 2016/11/20.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UITableView+YLExpandable.h"
#import <objc/runtime.h>
#import "Aspects.h"

@interface NSIndexPath (_YLExpandable)
- (NSIndexPath *)lastRowIndexPath;
- (NSIndexPath *)nextRowIndexPath;
@end

@implementation NSIndexPath (_YLExpandable)

- (NSIndexPath *)lastRowIndexPath {
    if (self.row == 0) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:self.row-1 inSection:self.section];
}

- (NSIndexPath *)nextRowIndexPath {
    return [NSIndexPath indexPathForRow:self.row+1 inSection:self.section];
}

@end



@implementation UITableViewCell (YLExpandable)

- (void)yl_setExpandable:(BOOL)expandable {
    objc_setAssociatedObject(self, @selector(yl_expandable), @(expandable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yl_expandable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@interface UITableView (_YLExpandable)
@property (nonatomic, strong) NSIndexPath *expandIndexPath;
@end

@implementation UITableView (_YLExpandable)
@dynamic expandIndexPath;

- (void)setExpandIndexPath:(NSIndexPath *)expandIndexPath {
    objc_setAssociatedObject(self, @selector(expandIndexPath), expandIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)expandIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}


@end


@implementation UITableView (YLExpandable)


+ (void)load {
    [UITableView aspect_hookSelector:@selector(setDataSource:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, id<UITableViewDataSource> dataSource) {
        [self tryHookTableView:aspectInfo.instance dataSource:dataSource];
    } error:NULL];
    
    [UITableView aspect_hookSelector:@selector(setDelegate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, id<UITableViewDelegate> delegate) {
        [self tryHookTableView:aspectInfo.instance delegate:delegate];
    } error:NULL];
    
}

+ (void)tryHookTableView:(UITableView *)tableView dataSource:(id<UITableViewDataSource>)dataSource {
    if (!tableView.yl_expandable){ return; }
    
    if (![dataSource isKindOfClass:[NSObject class]]) {
        NSLog(@"[YLExpandable] dataSource CAN NOT be hooked!");
        return;
    }
    
    NSObject<UITableViewDataSource> *dataSourceObj = dataSource;
    
    
    [dataSourceObj aspect_hookSelector:@selector(tableView:numberOfRowsInSection:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>aspectInfo, UITableView *tableView, NSInteger section) {
        NSInteger number;
        NSInvocation *invocation = aspectInfo.originalInvocation;
        [invocation invoke];
        [invocation getReturnValue:&number];
        
        if (tableView.expandIndexPath && tableView.expandIndexPath.section == section) {
            number += 1;
        }
        
        [invocation setReturnValue:&number];
        
    } error:NULL];
    
    
    
    [dataSourceObj aspect_hookSelector:@selector(tableView:cellForRowAtIndexPath:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>aspectInfo, UITableView *tableView, NSIndexPath *indexPath) {
        
        NSInvocation *invocation = aspectInfo.originalInvocation;
        NSIndexPath *expandIndexPath = tableView.expandIndexPath;
        
        if (expandIndexPath && expandIndexPath.section == indexPath.section) {
            if(expandIndexPath.row == indexPath.row) {
                NSIndexPath *hostIndexPath = [indexPath lastRowIndexPath];
                UITableViewCell *expandCell = [tableView.yl_expandableDataSource yl_tableView:tableView expandCellForHostIndexPath:hostIndexPath];
                
                [invocation setReturnValue:&expandCell];
                return;
            } else if (expandIndexPath.row < indexPath.row) {
                NSIndexPath *newIndexPath = [indexPath lastRowIndexPath];
                [invocation setArgument:&newIndexPath atIndex:3];
            }
        }
        [invocation invoke];
        
    } error:NULL];
    
    
    [dataSourceObj aspect_hookSelector:@selector(tableView:heightForRowAtIndexPath:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>aspectInfo, UITableView *tableView, NSIndexPath *indexPath) {
        
        NSInvocation *invocation = aspectInfo.originalInvocation;
        NSIndexPath *expandIndexPath = tableView.expandIndexPath;
        
        if (expandIndexPath && expandIndexPath.section == indexPath.section) {
            if(expandIndexPath.row == indexPath.row) {
                NSIndexPath *hostIndexPath = [indexPath lastRowIndexPath];
                
                CGFloat height = [tableView.yl_expandableDataSource yl_tableView:tableView
                                              heightOfExpandCellForHostIndexPath:hostIndexPath];
                [invocation setReturnValue:&height];
                return;
            } else if (expandIndexPath.row < indexPath.row) {
                NSIndexPath *newIndexPath = [indexPath lastRowIndexPath];
                [invocation setArgument:&newIndexPath atIndex:3];
            }
        }
        [invocation invoke];
        
    } error:NULL];
}


+ (void)tryHookTableView:(UITableView *)tableView delegate:(id<UITableViewDelegate>)delegate {
    if (!tableView.yl_expandable) { return; }
    
    if (![delegate isKindOfClass:[NSObject class]]) {
        NSLog(@"[YLExpandable] delegate CAN NOT be hooked!");
        return;
    }
    
    
    [tableView aspect_hookSelector:@selector(deselectRowAtIndexPath:animated:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>aspectInfo, NSIndexPath *indexPath, BOOL animated) {
        NSInvocation *invocation = aspectInfo.originalInvocation;
        
        if (tableView.expandIndexPath
            && tableView.expandIndexPath.section == indexPath.section
            && tableView.expandIndexPath.row <= indexPath.row) {
            // fix offset
            NSIndexPath *newIndexPath = [indexPath nextRowIndexPath];
            [invocation setArgument:&newIndexPath atIndex:2];
        }
        [invocation invoke];
    } error:NULL];
    
    
    
    NSObject<UITableViewDelegate> *delegateObj = delegate;
    [delegateObj aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>aspectInfo, UITableView *tableView, NSIndexPath *indexPath) {
        
        NSInvocation *invocation = aspectInfo.originalInvocation;
        if (tableView.expandIndexPath
            && tableView.expandIndexPath.section == indexPath.section
            && tableView.expandIndexPath.row < indexPath.row) {
            NSIndexPath *newIndexPath = [indexPath lastRowIndexPath];
            [invocation setArgument:&newIndexPath atIndex:3];
        }
        [invocation invoke];
        
        
        
        NSIndexPath *expandIndexPath = nil;
        NSIndexPath *lastExpandIndexPath = tableView.expandIndexPath;
        if (lastExpandIndexPath) {
            if(indexPath.section == lastExpandIndexPath.section
               && indexPath.row == lastExpandIndexPath.row) return;
            
            tableView.expandIndexPath = nil;
            [tableView deleteRowsAtIndexPaths:@[lastExpandIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            if (indexPath.section != lastExpandIndexPath.section
                || indexPath.row + 1 == lastExpandIndexPath.row) {
                return;
            } else if (indexPath.row + 1 < lastExpandIndexPath.row) {
                expandIndexPath = [indexPath nextRowIndexPath];
            } else if(indexPath.row > lastExpandIndexPath.row) {
                expandIndexPath = indexPath;
            }
            
            if ([tableView.yl_expandableDelegate respondsToSelector:@selector(yl_tableView:didUnexpandForHostIndexPath:)]) {
                [tableView.yl_expandableDelegate yl_tableView:tableView
                                  didUnexpandForHostIndexPath:[lastExpandIndexPath lastRowIndexPath]];
            }
            
        } else {
            expandIndexPath = [indexPath nextRowIndexPath];
        }
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!selectedCell.yl_expandable) {  return; }
        
        if (expandIndexPath) {
            tableView.expandIndexPath = expandIndexPath;
            [tableView insertRowsAtIndexPaths:@[expandIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if ([tableView.yl_expandableDelegate respondsToSelector:@selector(yl_tableView:didExpandForHostIndexPath:)]) {
                [tableView.yl_expandableDelegate yl_tableView:tableView didExpandForHostIndexPath:indexPath];
            }
        }
    } error:NULL];
    
}

#pragma mark - Property
- (void)yl_setExpandable:(BOOL)yl_expandable {
    objc_setAssociatedObject(self, @selector(yl_expandable), @(yl_expandable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yl_expandable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (void)yl_setExpandableDataSource:(id<YLExpandableDataSource>)yl_expandableDataSource {
    objc_setAssociatedObject(self, @selector(yl_expandableDataSource), yl_expandableDataSource, OBJC_ASSOCIATION_ASSIGN);
}

- (id<YLExpandableDataSource>)yl_expandableDataSource {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yl_setExpandableDelegate:(id<YLExpandableDeleagte>)yl_expandableDelegate {
    objc_setAssociatedObject(self, @selector(yl_expandableDelegate), yl_expandableDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<YLExpandableDeleagte>)yl_expandableDelegate {
    return objc_getAssociatedObject(self, _cmd);
}


@end
