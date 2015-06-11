//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"
#import "JYUtf8Helper.h"

@implementation JYStringJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (id)serialize:(id)obj {
    return obj;
}

- (id)deserialize:(NSString *)string {
    return [self deserialize:string withClass:[NSString class]];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass {
    if ([string isEqual:@"null"])
        return nil;
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"Value '%@' is invalid for string", string];
    NSString *trimmed = [string substringWithRange:NSMakeRange(1, [string length] - 2)];
    return [JYUtf8Helper stringByReplacingUTF8Escapes:trimmed];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSString class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string length] > 1 && [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

@end
