//
//  MACViewController.m
//  MultiAirCam
//
//  Created by Martin Gratzer on 09.12.12.
//  Copyright (c) 2012 Martin Gratzer. All rights reserved.
//

#import "MACViewController.h"

static BOOL __ipad;

@interface MACViewController () <UIAlertViewDelegate>{
    alertViewCompletionBlock_t _alertViewCompletionBlock;
}
@end

@implementation MACViewController
//............................................................................
#pragma mark -
#pragma mark Memory Management
//............................................................................
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __ipad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    });
}

+ (id)controller  {
    return [[self class] new];
}

#warning TODO: init the connector property self.tmf within this controller MACCameraListViewController MACCameraViewController inherit from this VC

- (void)dealloc {
    _alertViewCompletionBlock = nil;
}

//............................................................................
#pragma mark -
#pragma mark Public
//............................................................................
- (BOOL)iPad {
    return [MACViewController iPad];
}

+ (BOOL)iPad {
    return __ipad;
}

- (void)displayErrorMessage:(NSString *)errorMessage completion:(alertViewCompletionBlock_t)completion {
    _alertViewCompletionBlock = [completion copy];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

//............................................................................
#pragma mark -
#pragma mark Override
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Delegates
//............................................................................
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(_alertViewCompletionBlock) {
        _alertViewCompletionBlock(buttonIndex);
    }
    _alertViewCompletionBlock = NULL;
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if(_alertViewCompletionBlock) {
        _alertViewCompletionBlock(0);
    }
    _alertViewCompletionBlock = NULL;
}

//............................................................................
#pragma mark -
#pragma mark Private
//............................................................................

@end
