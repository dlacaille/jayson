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

+ (NSString *)serializeObject:(id)obj withSettings:(JYSerializerSettings *)settings {
    JYJsonSerializer *serializer = [[JYJsonSerializer alloc] initWithSettings:settings];
    return [serializer serializeObject:obj];
}

+ (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass {
    return [_serializer deserializeObjectArray:json withClass:objectClass];
}

+ (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    return [_serializer deserializeObject:json withClass:objectClass];
}

+ (id)deserializeObject:(NSString *)json {
    return [_serializer deserializeObject:json];
}

+ (id)deserializeObjectFromData:(NSData *)data {
    return [_serializer deserializeObjectFromData:data];
}

+ (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass {
    return [_serializer deserializeObjectFromData:data withClass:objectClass];
}

+ (NSDictionary *)toDictionary:(NSString *)json {
    return [_serializer deserializeObject:json withClass:[NSDictionary class]];
}


@end
