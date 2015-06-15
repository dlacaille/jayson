//
//  JYSerializerSettings.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-15.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYSerializerSettings.h"

@implementation JYSerializerSettings

+ (JYSerializerSettings *)defaultSettings {
    JYSerializerSettings *settings = [JYSerializerSettings new];
    settings.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    settings.ignoreNull = NO;
    settings.indented = YES;
    return settings;
}

@end
