//
//  LKCardModuleTests.m
//  LKCardModuleTests
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BalanceAPIManager.h"
#import "CardModel.h"
@interface LKCardModuleTests : XCTestCase
@property (nonatomic, strong) BalanceAPIManager *balanceAPIManager;
@end

@implementation LKCardModuleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBalance {
    expectation = [self expectationWithDescription:@"BalanceAPIManager"];
    self.balanceAPIManager = [BalanceAPIManager new];
    [self.balanceAPIManager loadData];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)manager {
    if (manager == self.balanceAPIManager) {
        
    }
}

- (void)apiManagerLoadDataFail:(YLResponseError *)error {
    NSLog(@"===> %@",error);
    [expectation fulfill];
}


@end
