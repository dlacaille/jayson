//
//  JYErrorEnum.h
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-06-16.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

enum JYErrorType {
    JYErrorMissingProperty,
    JYErrorInvalidFormat,
    JYErrorCircularReference,
    JYErrorUnknown
};

@interface JYError : NSObject

@property (assign, nonatomic) enum JYErrorType errorType;
@property (strong, nonatomic) NSString *message;

- (instancetype)initWithType:(enum JYErrorType)errorType withMessage:(NSString *)message;

+ (void)raiseError:(JYError *)error inArray:(NSArray **)errors;
+ (void)raiseError:(enum JYErrorType)type withMessage:(NSString *)message inArray:(NSArray **)errors;

@end
