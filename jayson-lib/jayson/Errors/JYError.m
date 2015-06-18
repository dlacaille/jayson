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

+ (void)raiseError:(JYError *)error inArray:(NSArray *__autoreleasing *)errors {
    if (*errors == nil)
        *errors = [NSMutableArray new];
    else if (![*errors isKindOfClass:[NSMutableArray class]])
        *errors = [[NSMutableArray alloc] initWithArray:*errors];
    NSMutableArray *mutableErrors = (NSMutableArray *)*errors;
    [mutableErrors addObject:error];
}

+ (void)raiseError:(enum JYErrorType)type withMessage:(NSString *)message inArray:(NSArray **)errors {
    [self raiseError:[[JYError alloc] initWithType:type withMessage:message] inArray:errors];
}

@end
