//
//  JYJayson.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJayson.h"

@implementation JYJayson

static JYJsonSerializer *_serializer;

+ (void) initialize {
    if (self == [JYJayson class]) {
        _serializer = [JYJsonSerializer new];
    }
}

+ (JYJsonSerializer *)defaultSerializer {
    return _serializer;
}

+ (NSString *)serializeObject:(id)obj {
    return [_serializer serializeObject:obj];
}

+ (NSString *)serializeObject:(id)obj errors:(NSArray **)errors  {
    return [_serializer serializeObject:obj errors:errors];
}

+ (NSString *)serializeObject:(id)obj withSettings:(JYSerializerSettings *)settings {
    JYJsonSerializer *serializer = [[JYJsonSerializer alloc] initWithSettings:settings];
    return [serializer serializeObject:obj];
}

+ (NSString *)serializeObject:(id)obj withSettings:(JYSerializerSettings *)settings errors:(NSArray **)errors {
    JYJsonSerializer *serializer = [[JYJsonSerializer alloc] initWithSettings:settings];
    return [serializer serializeObject:obj errors:errors];
}

+ (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass {
    return [_serializer deserializeObjectArray:json withClass:objectClass];
}

+ (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors {
    return [_serializer deserializeObjectArray:json withClass:objectClass errors:errors];
}

+ (id)deserializeObjectDictionary:(NSString *)json withClass:(Class)objectClass {
    return [_serializer deserializeObjectDictionary:json withClass:objectClass];
}

+ (id)deserializeObjectDictionary:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors {
    return [_serializer deserializeObjectDictionary:json withClass:objectClass errors:errors];
}

+ (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    return [_serializer deserializeObject:json withClass:objectClass];
}

+ (id)deserializeObject:(NSString *)json withClass:(Class)objectClass errors:(NSArray **)errors {
    return [_serializer deserializeObject:json withClass:objectClass errors:errors];
}

+ (id)deserializeObject:(NSString *)json {
    return [_serializer deserializeObject:json];
}

+ (id)deserializeObject:(NSString *)json errors:(NSArray **)errors {
    return [_serializer deserializeObject:json errors:errors];
}

+ (id)deserializeObjectFromData:(NSData *)data {
    return [_serializer deserializeObjectFromData:data];
}

+ (id)deserializeObjectFromData:(NSData *)data errors:(NSArray **)errors {
    return [_serializer deserializeObjectFromData:data errors:errors];
}

+ (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass {
    return [_serializer deserializeObjectFromData:data withClass:objectClass];
}

+ (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass errors:(NSArray **)errors {
    return [_serializer deserializeObjectFromData:data withClass:objectClass errors:errors];
}

+ (NSDictionary *)toDictionary:(NSString *)json {
    return [_serializer deserializeObject:json withClass:[NSDictionary class]];
}

+ (NSDictionary *)toDictionary:(NSString *)json errors:(NSArray **)errors {
    return [_serializer deserializeObject:json withClass:[NSDictionary class] errors:errors];
}


@end
