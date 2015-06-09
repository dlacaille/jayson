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
#import "JYCamelCaseConverter.h"

@interface JYJsonSerializer()

@property (nonatomic, strong) NSMutableArray *history;

@end

@implementation JYJsonSerializer

- (instancetype)init {
    if (self = [super init]) {
        self.jsonConverters = [self defaultConverters];
        self.caseConverter = [JYCamelCaseConverter new];
        self.jsonFormatter = [[JYJsonFormatter alloc] initWithSerializer:self];
        self.history = [NSMutableArray new];
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
        {
            // Do not serialize an object that is his own ancestor.
            if (obj == nil || [self hasAncestor:obj])
                return [jsonConverter toString:nil];
            // Add the object to history for circular reference checking.
            [self.history addObject:obj];
            // Serialize the object.
            NSString *result = [jsonConverter toString:obj];
            // Remove the object from history as it has been serialized.
            [self.history removeObject:obj];
            return result;
        }
    }
    return nil;
}

- (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)hasAncestor:(id)obj {
    for (id ancestor in self.history)
        if (ancestor == obj) // Check for pointer equality instead of isEqual:
            return true;
    return false;
}

- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass {
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:[NSArray class]])
            return [jsonConverter fromArrayString:trimmed withClass:objectClass];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    if (objectClass == nil)
        return [self deserializeObject:json];
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:objectClass])
            return [jsonConverter fromString:trimmed withClass:objectClass];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json {
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvertJson:trimmed])
            return [jsonConverter fromString:trimmed];
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
