//
//  LibraryViewModel.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryViewModel.h"
#import "LibraryManager.h"
#import "Foundation+LKTools.h"
#import <BlocksKit/BlocksKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LibraryViewModel()
//@property (nonatomic, copy) NSString *fine;
//@property (nonatomic, copy) NSArray<LibBookViewModel *> *libBookViewModels;
@end

@implementation LibraryViewModel
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    LibraryManager *manager = [LibraryManager sharedInstance];
    RAC(self, libBookViewModels) = [RACObserve(manager, libBookModels) map:^id(id value) {
        return [value bk_map:^id(id model) {
            return [[LibBookViewModel alloc] initWithModel:model];
        }];

    }];
    
    RAC(self, fine) =
    [RACObserve(manager, fine) map:^id(id value) {
        return [NSString isBlank:value]?@"0.00":value;
    }];
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return [[LibraryManager sharedInstance] networkingRAC];
}
@end
