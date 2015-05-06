//
//  JYJsonSerializer.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonSerializer.h"
#import "JYStringJsonConverter.h"

@implementation JYJsonSerializer

- (instancetype)init {
    if (self = [super init]) {
        self.jsonConverters = [self defaultConverters];
        return self;
    }
    return nil;
}

- (NSArray<JYJsonConverter> *)defaultConverters {
    return @[
            [JYStringJsonConverter new]
             ];
}

@end
