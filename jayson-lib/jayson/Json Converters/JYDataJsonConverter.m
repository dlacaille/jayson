//
//  JYDataJsonConverter.m
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYDataJsonConverter.h"
#import "NSData+Base64.h"

@implementation JYDataJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    return [NSString stringWithFormat:@"\"%@\"", [((NSData *)obj) base64EncodedString]];
}

- (id)fromString:(NSString *)string {
    NSString *deserialized = [self.jsonSerializer deserializeObject:string withClass:[NSString class]];
    return  [NSData dataFromBase64String:deserialized];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSData class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    // This converter should not be used for deserializing when the Class is unknown.
    return false;
}

@end
