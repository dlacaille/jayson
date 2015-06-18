//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"
#import "JYUtf8Helper.h"
#import "JYError.h"

@implementation JYStringJsonConverter

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
    return [self deserialize:string withClass:[NSString class] errors:errors];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass errors:(NSArray **)errors {
    if ([string isEqualToString:@"null"])
        return nil;
    if (![self canConvertJson:string errors:errors])
        [JYError raiseError:JYErrorInvalidFormat withMessage:[NSString stringWithFormat:@"Value '%@' is invalid for string", string] inArray:errors];
    if ([string isEqualToString:@""])
        return @"";
    NSString *trimmed = [string substringWithRange:NSMakeRange(1, [string length] - 2)];
    return [JYUtf8Helper stringByReplacingUTF8Escapes:trimmed];
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass errors:(NSArray *__autoreleasing *)errors {
    return nil;
}

- (BOOL)canConvert:(Class)objectClass errors:(NSArray **)errors {
    return [objectClass isSubclassOfClass:[NSString class]];
}

- (BOOL)canConvertJson:(NSString *)string errors:(NSArray **)errors {
    return [string length] > 1 && [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

@end
