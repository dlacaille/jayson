//
//  JYJsonSerializer.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonSerializer.h"
#import "JYJsonConverter.h"
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
    return (NSArray<JYJsonConverter> *)@[
             [JYStringJsonConverter new]
             ];
}

- (NSString *)serializeObject:(id)obj {
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:[obj class]])
            return [jsonConverter toString:obj];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:objectClass])
            return [jsonConverter fromString:json];
    }
    return nil;
}

@end
