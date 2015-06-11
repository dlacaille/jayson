//
//  JYNumberJsonConverter.m
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYNumberJsonConverter.h"

@implementation JYNumberJsonConverter

NSString *const regex = @"^-?(0|[1-9]\\d*)(\\.\\d+)?([eE][+-]?\\d+)?$";

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
    return [self deserialize:string withClass:[NSNumber class]];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass {
    if ([string isEqual:@"null"])
        return nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    return [formatter numberFromString:string];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSNumber class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [match evaluateWithObject:string];
}

@end
