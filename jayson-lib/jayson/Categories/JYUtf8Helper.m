//
//  NSString+UTF8.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYUtf8Helper.h"

@implementation JYUtf8Helper

+ (NSString *)stringByReplacingUTF8Escapes:(NSString *)str {
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

@end
