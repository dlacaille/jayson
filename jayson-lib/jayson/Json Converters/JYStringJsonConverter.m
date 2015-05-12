//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"

@interface JYStringJsonConverter()
@property (nonatomic) NSDictionary *lookupTable;
@end
@implementation JYStringJsonConverter


- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        self.lookupTable = @{@"\\n":@"    ",@"\r\n": @"\n   "  };
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    NSString *result = [NSString stringWithFormat:@"\"%@\"", obj];
        result = [NSString stringWithCString:[result UTF8String] encoding:NSUTF8StringEncoding];
    for (NSString *key in self.lookupTable) {
        result = [result stringByReplacingOccurrencesOfString:key withString:[self.lookupTable objectForKey:key]];
    }

    NSString *string = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    return string;
}

- (id)fromString:(NSString *)string {
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"value %@ is invalid for string", string];
    NSString *result = [string substringWithRange:NSMakeRange(1, [string length] - 2)];
    return result;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSString class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string length] > 1 && [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

@end
