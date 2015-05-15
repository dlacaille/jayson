//
//  JYJsonSerializer.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJsonSerializer.h"
#import "JYJsonConverter.h"
#import "JYJsonFormatter.h"
#import "JYNullJsonConverter.h"
#import "JYStringJsonConverter.h"
#import "JYNumberJsonConverter.h"
#import "JYDateJsonConverter.h"
#import "JYDataJsonConverter.h"
#import "JYArrayJsonConverter.h"
#import "JYDictionaryJsonConverter.h"
#import "JYObjectJsonConverter.h"

@implementation JYJsonSerializer

- (instancetype)init {
    if (self = [super init]) {
        self.jsonConverters = [self defaultConverters];
        self.jsonFormatter = [[JYJsonFormatter alloc] initWithSerializer:self];
        self.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        return self;
    }
    return nil;
}

- (NSArray<JYJsonConverter> *)defaultConverters {
    return (NSArray<JYJsonConverter> *)@[
             [[JYNullJsonConverter alloc] initWithSerializer:self],
             [[JYStringJsonConverter alloc] initWithSerializer:self],
             [[JYNumberJsonConverter alloc] initWithSerializer:self],
             [[JYDateJsonConverter alloc] initWithSerializer:self],
             [[JYDataJsonConverter alloc] initWithSerializer:self],
             [[JYArrayJsonConverter alloc] initWithSerializer:self],
             [[JYDictionaryJsonConverter alloc] initWithSerializer:self],
             [[JYObjectJsonConverter alloc] initWithSerializer:self]
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

- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass {
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:[NSArray class]])
            return [jsonConverter fromArrayString:json withClass:objectClass];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    if (objectClass == nil)
        return [self deserializeObject:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:objectClass])
            return [jsonConverter fromString:json withClass:objectClass];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json {
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvertJson:json])
            return [jsonConverter fromString:json];
    }
    return nil;
}

- (id)deserializeObjectFromData:(NSData *)data {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self deserializeObject:json];
}

- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self deserializeObject:json withClass:objectClass];
}

@end
