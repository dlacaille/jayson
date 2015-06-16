//
//  JYErrorEnum.h
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-06-16.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYError : NSObject
typedef enum {
    JYErrorMissingProperty,
    JYErrorInvalidFormat,
    JYErrorUnknown
} JYErrorEnum;
@end
