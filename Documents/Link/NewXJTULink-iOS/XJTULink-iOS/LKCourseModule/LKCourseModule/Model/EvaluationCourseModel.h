//
//  EvaluationCourseModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "Mantle.h"


@interface EvaluationCourseModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isEvluted;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *college;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger count;

@end


typedef EvaluationCourseModel EvaluationCourseViewModel;
