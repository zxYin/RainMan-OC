//
//  TranscriptsViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsViewModel.h"
#import "TranscriptsManager.h"
#import <BlocksKit/BlocksKit.h>

@implementation TranscriptsViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
        if (self.transcriptsItemViewModels.count == 0) {
            [[[self networkingRAC] requestCommand] execute:nil];
        }
    }
    return self;
}

- (void)setupRAC {
    TranscriptsManager *manager = [TranscriptsManager sharedInstance];    
    @weakify(self);
    [RACObserve(manager, transcripts) subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *transcriptModels = manager.transcripts;
        NSMutableDictionary *transcriptsItemViewModels = [NSMutableDictionary dictionary];
        [transcriptModels enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
            transcriptsItemViewModels[key] =
            [obj bk_map:^id(id obj) {
                return [[TranscriptsItemViewModel alloc] initWithModel:obj];
            }];
        }];
        self.transcriptsItemViewModels = [transcriptsItemViewModels copy];
    }];
    
    
    
    RAC(self, semesters) = [RACObserve(manager, transcripts) map:^id(id value) {
        NSArray *semesters = [manager.transcripts allKeys];
        return [semesters sortedArrayUsingComparator:^NSComparisonResult(NSString *term1, NSString *term2) {
            NSArray *info1 = [term1 componentsSeparatedByString:@" "];
            NSArray *info2 = [term2 componentsSeparatedByString:@" "];
            NSComparisonResult result = [info1.firstObject compare:info2.firstObject];
            if (result == NSOrderedSame) {
                result = [info1.lastObject compare:info2.lastObject];
            }
            return -result;
        }];
    }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return [[TranscriptsManager sharedInstance] networkingRAC];
}

@end
