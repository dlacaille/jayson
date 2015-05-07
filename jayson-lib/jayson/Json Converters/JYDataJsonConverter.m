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
- (NSString *)toString:(id)obj {
    return [((NSData *)obj) base64EncodedString];
}

- (id)fromString:(NSString *)string {
    return  [NSData dataFromBase64String:string];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSData class]];
}
@end
