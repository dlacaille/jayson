//
//  JYNullJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYNullJsonConverter.h"

@implementation JYNullJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (id)serialize:(id)obj errors:(NSArray **)errors {
    return obj;
}

- (id)deserialize:(NSString *)string errors:(NSArray **)errors {
    return [self deserialize:string withClass:[NSNull class] errors:errors];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    if (![self canConvertJson:string errors:errors])
        [NSException raise:@"Json Converter Error" format:@"Value '%@' is invalid for null", string];
    return [NSNull null];
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray *__autoreleasing *)errors {
    return nil;
}

- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors {
    if (objectClass == nil)
        return YES;
    return [objectClass isSubclassOfClass:[NSNull class]];
}

- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors {
    return [string isEqual:@"null"];
}

@end
