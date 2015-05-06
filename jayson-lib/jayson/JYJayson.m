//
//  JYJayson.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYJayson.h"
#import "JYJsonSerializer.h"

@implementation JYJayson

static JYJsonSerializer *serializer;

+ (void) initialize {
    if (self == [JYJayson class]) {
        serializer = [JYJsonSerializer new];
    }
}

+ (NSString *)serializeObject:(id)obj {
    return [serializer serializeObject:obj];
}

+ (id)deserializeObject:(NSString *)json withClass:(Class *)objectClass {
    return [serializer deserializeObject:json withClass:objectClass];
}

@end
