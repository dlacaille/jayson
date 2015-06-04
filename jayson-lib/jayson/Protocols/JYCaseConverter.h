//
//  JYCaseConverter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-02.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYCaseConverter

/*
 * Converts a property name string to a naming convention.
 */
- (NSString *)convert:(NSString *)propertyName;

@end