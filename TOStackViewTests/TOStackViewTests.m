//
//  TOStackViewTests.m
//  TOStackViewTests
//
//  Created by Tim Oliver on 29/8/21.
//

#import <XCTest/XCTest.h>
#import "TOStackView.h"

@interface TOStackViewTests : XCTestCase

@end

@implementation TOStackViewTests

// For now, test the view is buildable and can be instantiated
- (void)testStackView
{
    TOStackView *view = [[TOStackView alloc] init];
    XCTAssertNotNil(view);
}

@end
