//
//  JYNumberJsonConverter.m
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-05-06.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYNumberJsonConverter.h"

@implementation JYNumberJsonConverter

- (NSString *)toString:(id)obj {
    return ((NSNumber *)obj).stringValue;
}

- (id)fromString:(NSString *)string {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    return [formatter numberFromString:string];
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSNumber class]];
}

@end
