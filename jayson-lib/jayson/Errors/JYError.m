//
//  JYErrorEnum.m
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-06-16.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYError.h"

@implementation JYError

- (instancetype)initWithType:(enum JYErrorType)errorType withMessage:(NSString *)message {
    if (self = [super init]) {
        self.errorType = errorType;
        self.message = message;
        return self;
    }
    return nil;
}

- (instancetype)initWithType:(enum JYErrorType)errorType withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3) {
    if (self = [super init]) {
        self.errorType = errorType;
        va_list args;
        va_start(args, format);
        self.message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        return self;
    }
    return nil;
}

+ (void)errors:(NSArray **)errors raiseError:(JYError *)error {
    if (*errors == nil)
        *errors = [NSMutableArray new];
    else if (![*errors isKindOfClass:[NSMutableArray class]])
        *errors = [[NSMutableArray alloc] initWithArray:*errors];
    NSMutableArray *mutableErrors = (NSMutableArray *)*errors;
    [mutableErrors addObject:error];
}

+ (void)errors:(NSArray **)errors raiseError:(enum JYErrorType)type withMessage:(NSString *)message {
    [self errors:errors raiseError:[[JYError alloc] initWithType:type withMessage:message]];
}

+ (void)errors:(NSArray **)errors raiseError:(enum JYErrorType)type withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4) {
    va_list args;
    va_start(args, format);
    [self errors:errors raiseError:type withMessage:[[NSString alloc] initWithFormat:format arguments:args]];
    va_end(args);
}

@end
