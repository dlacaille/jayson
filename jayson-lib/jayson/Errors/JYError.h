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
- (instancetype)initWithType:(enum JYErrorType)errorType withFormat:(NSString *)message, ... NS_FORMAT_FUNCTION(2,3);

+ (void)errors:(NSArray **)errors raiseError:(JYError *)error;
+ (void)errors:(NSArray **)errors raiseError:(enum JYErrorType)type withMessage:(NSString *)message;
+ (void)errors:(NSArray **)errors raiseError:(enum JYErrorType)type withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

@end
