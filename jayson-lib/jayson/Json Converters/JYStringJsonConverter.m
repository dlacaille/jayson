//
//  JYStringJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYStringJsonConverter.h"

@implementation JYStringJsonConverter

- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (NSString *)toString:(id)obj {
    return [NSString stringWithFormat:@"\"%@\"", obj];
}

- (id)fromString:(NSString *)string {
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"Value '%@' is invalid for string", string];
    NSString *trimmed = [string substringWithRange:NSMakeRange(1, [string length] - 2)];
    return [self stringByReplacingUTF8Escapes:trimmed];
}

- (NSString *)stringByReplacingUTF8Escapes:(NSString *)str {
    NSDictionary *const escMap = @{
                                    @"\"": @"\"", @"/": @"/", @"b": @"\b", @"f": @"\f",
                                    @"n": @"\n", @"r": @"\r", @"t": @"\t",
                                    };
    NSMutableString *builder = [NSMutableString new];
    BOOL escaped = NO;
    for (int i=0; i<[str length]; i++)
    {
        char c = [str characterAtIndex:i];
        if (escaped) {
            if (c == 'u')
            {
                NSString *hex = [str substringWithRange:NSMakeRange(i+1, 4)];
                NSScanner *scanner = [NSScanner scannerWithString:hex];
                unsigned int outVal;
                [scanner scanHexInt:&outVal];
                [builder appendFormat:@"%C", (unichar)outVal];
                i += 4;
                continue;
            }
            NSString *esc = [escMap objectForKey:[NSString stringWithFormat:@"%c", c]];
            if (esc != nil)
                [builder appendString:esc];
            escaped = NO;
            continue;
        }
        if (c == '\\') {
            escaped = YES;
            continue;
        }
        [builder appendFormat:@"%c", c];
    }
    return [NSString stringWithString:builder];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSString class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string length] > 1 && [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

@end
