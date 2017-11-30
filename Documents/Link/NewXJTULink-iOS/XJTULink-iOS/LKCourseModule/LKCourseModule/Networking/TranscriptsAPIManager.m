//
//  TranscriptsAPIManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsAPIManager.h"

@implementation TranscriptsAPIManager
- (NSString *)path {
    return @"stuInfo/getStuScore/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return YES;
}

- (NSString *)keyOfResult {
    return @"score_list";
}

//- (id)fetchDataFromModel:(Class)clazz {
//    NSArray *scoreList = [super fetchData][@"score_list"];
//    NSMutableDictionary *scoreMap = [[NSMutableDictionary alloc] initWithCapacity:scoreList.count];
//    for (NSArray *scores in scoreList) {
//        NSArray *scoreModels = [MTLJSONAdapter modelsOfClass:clazz fromJSONArray:scores error:&error];
//        ScoreModel *score = scoreModels.firstObject;
//        if (score != nil) {
//            NSString *key = [NSString stringWithFormat:@"%@ %@",score.schoolYear,score.semester];
//            [scoreMap setValue:scoreModels forKey:key];
//        }
//    }
//    user.scoreMap = [scoreMap copy];
//    return nil;
//    
//}

@end
