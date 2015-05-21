//
//  NSString+UTF8.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "NSString+UTF8.h"

@implementation NSString (UTF8)

- (NSString *)stringByReplacingUTF8Escapes; {
    NSDictionary *const escMap = @{
                                   @"\"": @"\"", @"/": @"/", @"b": @"\b", @"f": @"\f",
                                   @"n": @"\n", @"r": @"\r", @"t": @"\t",
                                   };
    NSMutableString *builder = [NSMutableString new];
    BOOL escaped = NO;
    for (int i=0; i<[self length]; i++)
    {
        char c = [self characterAtIndex:i];
        if (escaped) {
            if (c == 'u')
            {
                NSString *hex = [self substringWithRange:NSMakeRange(i+1, 4)];
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

@end
