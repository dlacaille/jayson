//
//  NSString+UTF8.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-21.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYUtf8Helper : NSObject

+ (NSString *)stringByReplacingUTF8Escapes:(NSString *)str;

@end
