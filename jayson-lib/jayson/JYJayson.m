//
//  JYJayson.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJayson.h"

@implementation JYJayson

static JYJsonSerializer *serializer;

+ (void) initialize {
    if (self == [JYJayson class]) {
        serializer = [JYJsonSerializer new];
    }
}

+ (JYJsonSerializer *)defaultSerializer {
    return serializer;
}

+ (NSString *)serializeObject:(id)obj {
    return [serializer serializeObject:obj];
}

+ (id)deserializeObjectArray:(NSString *)json withClass:(Class)objectClass {
    return [serializer deserializeObjectArray:json withClass:objectClass];
}

+ (id)deserializeObject:(NSString *)json withClass:(Class)objectClass {
    return [serializer deserializeObject:json withClass:objectClass];
}

+ (id)deserializeObject:(NSString *)json {
    return [serializer deserializeObject:json];
}

+ (id)deserializeObjectFromData:(NSData *)data {
    return [serializer deserializeObjectFromData:data];
}

+ (id)deserializeObjectFromData:(NSData *)data withClass:(Class)objectClass {
    return [serializer deserializeObjectFromData:data withClass:objectClass];
}

@end
