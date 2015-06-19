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
#import "JYError.h"

@interface JYJsonSerializer()

@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong, readwrite) JYSerializerSettings *serializerSettings;

@end

@implementation JYJsonSerializer

- (instancetype)init {
    if (self = [self initWithSettings:[JYSerializerSettings defaultSettings]])
        return self;
    return nil;
}

- (instancetype)initWithSettings:(JYSerializerSettings *)settings {
    if (self = [super init]) {
        self.jsonConverters = [self defaultConverters];
        self.caseConverter = [JYCamelCaseConverter new];
        self.jsonFormatter = [[JYJsonFormatter alloc] initWithSerializer:self];
        self.history = [NSMutableArray new];
        self.serializerSettings = settings;
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
    NSArray *errors = nil;
    return [self serializeObject:obj errors:&errors];
}

- (NSString *)serializeObject:(id)obj errors:(NSArray **)errors {
    JYFormatterState *state = [JYFormatterState new];
    [self serializeObject:obj withState:state errors:errors];
    return state.string;
}

- (void)serializeObject:(id)obj withState:(JYFormatterState *)state {
    NSArray *errors = nil;
    return [self serializeObject:obj withState:state errors:&errors];
}

- (void)serializeObject:(id)obj withState:(JYFormatterState *)state errors:(NSArray **)errors {
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:[obj class] errors:errors])
        {
            if ([self hasAncestor:obj]) {
                switch (self.serializerSettings.circularReferenceHandling)
                {
                    case JYCircularReferenceThrow:
                        [JYError errors:errors raiseError:JYErrorCircularReference withMessage:@"Serializer settings do not allow circular references"];
                    case JYCircularReferenceIgnore:
                        [self.jsonFormatter writeObject:nil withState:state errors:errors];
                        return;
                    default:
                        break;
                }
            }
            // Do not serialize an object that is his own ancestor.
            if (obj == nil) {
                [self.jsonFormatter writeObject:nil withState:state errors:errors];
                return;
            }
            // Add the object to history for circular reference checking.
            [self.history addObject:obj];
            // Serialize the object.
            id serialized = [jsonConverter serialize:obj errors:errors];
            [self.jsonFormatter writeObject:serialized withState:state errors:errors];
            // Remove the object from history as it has been serialized.
            [self.history removeObject:obj];
            return;
        }
    }
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
    NSArray *errors = nil;
    return [self deserializeObjectArray:json withClass:objectClass errors:&errors];
}

- (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors {
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:[NSArray class] errors:errors])
            return [jsonConverter deserializeArray:trimmed withClass:objectClass errors:errors];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    NSArray *errors = nil;
    return [self deserializeObject:json withClass:objectClass errors:&errors];
}

- (id)deserializeObject:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors {
    if (objectClass == nil)
        return [self deserializeObject:json errors:errors];
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvert:objectClass errors:errors])
            return [jsonConverter deserialize:trimmed withClass:objectClass errors:errors];
    }
    return nil;
}

- (id)deserializeObject:(NSString *)json {
    NSArray *errors = nil;
    return [self deserializeObject:json errors:&errors];
}

- (id)deserializeObject:(NSString *)json errors:(NSArray **)errors {
    NSString *trimmed = [self trim:json];
    for (NSObject<JYJsonConverter> *jsonConverter in self.jsonConverters)
    {
        if ([jsonConverter canConvertJson:trimmed errors:errors])
            return [jsonConverter deserialize:trimmed errors:errors];
    }
    return nil;
}

- (id)deserializeObjectFromData:(NSData *)data {
    NSArray *errors = nil;
    return [self deserializeObjectFromData:data errors:&errors];
}

- (id)deserializeObjectFromData:(NSData *)data errors:(NSArray **)errors {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self deserializeObject:json errors:errors];
}

- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass {
    NSArray *errors = nil;
    return [self deserializeObjectFromData:data withClass:objectClass errors:&errors];
}

- (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass errors:(NSArray **)errors {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self deserializeObject:json withClass:objectClass errors:errors];
}

- (id)deserializeObjectArrayFromData:(NSData *)data withClass:(Class)objectClass {
    NSArray *errors = nil;
    return [self deserializeObjectArrayFromData:data withClass:objectClass errors:&errors];
}

- (id)deserializeObjectArrayFromData:(NSData *)data withClass:(Class)objectClass errors:(NSArray **)errors {
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self deserializeObjectArray:json withClass:objectClass errors:errors];
}

@end
