//
//  LKLoginModuleTests.m
//  LKLoginModuleTests
//
//  Created by Yunpeng on 16/9/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CASHTMLFetcher.h"
@interface LKLoginModuleTests : XCTestCase <YLAPIManagerDataSource,YLAPIManagerDelegate>{
    XCTestExpectation *expectation;
}
@property (nonatomic, strong) CASHTMLFetcher *casHTMLFetcher;
@end

@implementation LKLoginModuleTests

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


- (void)testFetchHTML {
    expectation = [self expectationWithDescription:@"YLNetworkingTest"];
    self.casHTMLFetcher.delegate = self;
}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)manager {
    NSLog(@"apiManagerSecond Done");
    [expectation fulfill];
}

- (void)apiManagerLoadDataFail:(YLResponseError *)error {
    NSLog(@"===> %@",error);
    [expectation fulfill];
}


@end
