//
//  JYSerializerSettings.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-15.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYCircularReferenceHandling.h"

@interface JYSerializerSettings : NSObject

/*
 * Format used by the date converter. Default value is ISO8601 yyyy-MM-dd'T'HH:mm:ssZZZZZ
 */
@property (nonatomic, strong) NSString *dateFormat;

/*
 * Forces a timezone to use in the date converter. Default value is nil.
 */
@property (nonatomic, strong) NSTimeZone *timeZone;

/*
 * When true, the json is indented when serializing objects.
 */
@property (assign, nonatomic) BOOL indented;

/*
 * When true, null values are not included in the json.
 */
@property (assign, nonatomic) BOOL ignoreNull;

/*
 * Change the behavior of circular references in the serializer.
 */
@property (assign, nonatomic) enum JYCircularReferenceHandling circularReferenceHandling;

/*
 * Returns a new instance of JYSerializerSettings with default values.
 */
+ (JYSerializerSettings *)defaultSettings;

@end
