//
//  MACCameraActionCommand.m
//  MultiAirCam
//
//  Created by Martin Gratzer on 21.12.12.
//  Copyright (c) 2012 Martin Gratzer. All rights reserved.
//

#import "MACCameraActionCommand.h"

static NSString *const kActionKey = @"action";

@implementation MACCameraActionCommand
//............................................................................
#pragma mark -
#pragma mark Memory Management
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Public
//............................................................................
+ (NSString *)name {
    return @"mac_cam";
}

//............................................................................
#pragma mark -
#pragma mark Override
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Delegates
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Private
//............................................................................
@end

@implementation MACCameraActionCommandArguments
//............................................................................
#pragma mark -
#pragma mark Memory Management
//............................................................................
- (id)initWithAction:(MACCameraAction)action {
    self = [self init];
    if(self) {
        _action = action;
    }
    return self;
}

//............................................................................
#pragma mark -
#pragma mark Public
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Override
//............................................................................
- (void)updateFromSerializedObject:(NSDictionary *)serializedObject {
    [super updateFromSerializedObject:serializedObject];
    _action = [[serializedObject objectForKey:kActionKey] integerValue];
}

- (NSMutableDictionary *)serializedObject {
    NSMutableDictionary *serialized = [super serializedObject];
    [serialized setObject:@(_action) forKey:kActionKey];
    return serialized;
}

//............................................................................
#pragma mark -
#pragma mark Delegates
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Private
//............................................................................

@end
