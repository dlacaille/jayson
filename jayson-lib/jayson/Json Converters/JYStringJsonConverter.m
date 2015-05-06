//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"

@implementation JYStringJsonConverter

- (NSString *)toString:(id)obj {
    return (NSString *)obj;
}

- (id)fromString:(NSString *)string {
    return string;
}

- (BOOL)canConvert:(Class *)objectClass {
    return objectClass == [NSString class];
}

@end
