//
//  JYCircularRefTestClass.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-29.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircularRefTestClass : NSObject

@property (strong, nonatomic) NSString *test;
@property (strong, nonatomic) CircularRefTestClass *ref;

@end
