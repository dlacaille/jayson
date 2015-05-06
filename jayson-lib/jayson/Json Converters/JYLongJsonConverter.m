//
//  JYLongJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYLongJsonConverter.h"

@implementation JYLongJsonConverter

- (NSString *)toString:(id)obj {
    return [(long)obj stringValue];
}

- (id)fromString:(NSString *)string {
    @try {
        return [string longLongValue];
    }
    @catch (NSException *exception) {
        [NSException raise:@"Json Converter Error" format:@"%s is not a valid value for a long", string];
    }
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [long class];
}

@end
