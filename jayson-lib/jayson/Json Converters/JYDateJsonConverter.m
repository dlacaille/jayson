//
//  JYDateJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-11.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYDateJsonConverter.h"

@implementation JYDateJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (id)serialize:(id)obj {
    NSDate *date = (NSDate *)obj;
    return [[self dateFormatter] stringFromDate:date];
}

- (id)deserialize:(NSString *)string {
    return [self deserialize:string withClass:[NSDate class]];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass {
    if ([string isEqual:@"null"])
        return nil;
    NSString *deserialized = [self.jsonSerializer deserializeObject:string withClass:[NSString class]];
    return [[self dateFormatter] dateFromString:deserialized];
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:self.jsonSerializer.dateFormat];
    return dateFormatter;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSDate class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    // This converter should not be used for deserializing when the Class is unknown.
    return false;
}

@end
