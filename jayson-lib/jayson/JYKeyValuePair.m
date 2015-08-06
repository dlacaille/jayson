//
//  JYKeyValuePair.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-07-30.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYKeyValuePair.h"

@implementation JYKeyValuePair

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value {
    if (self = [super init]) {
        self.key = key;
        self.value = value;
        return self;
    }
    return nil;
}

@end