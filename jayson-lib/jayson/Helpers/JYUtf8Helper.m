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
    NSMutableString *builder = [NSMutableString new];
    BOOL escaped = NO;
    for (int i=0; i<[str length]; i++)
    {
        char c = [str characterAtIndex:i];
        if (escaped) {
            // Escaped characters.
            char esc = 0;
            switch (c) {
                case 'u': {
                    // Unicode escaping.
                    unsigned int outVal;
                    NSString *hex = [str substringWithRange:NSMakeRange(i+1, 4)];
                    [[NSScanner scannerWithString:hex] scanHexInt:&outVal];
                    [builder appendFormat:@"%C", (unichar)outVal];
                    i += 4;
                    continue;
                }
                case '\"': case '\\': case '/': esc = c; goto insertChar;
                case 'b': esc = '\b'; goto insertChar;
                case 'f': esc = '\f'; goto insertChar;
                case 'n': esc = '\n'; goto insertChar;
                case 'r': esc = '\r'; goto insertChar;
                case 't': esc = '\t'; goto insertChar;
                insertChar: [builder appendFormat:@"%c", esc];
            }
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
