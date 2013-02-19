
//  MACCameraViewController.m
//  MultiAirCam
//
//  Created by Martin Gratzer on 09.12.12.
//  Copyright (c) 2012 Martin Gratzer. All rights reserved.
//

#import "MACCameraViewController.h"
#import "MACCamera.h"
#import "UIImage+Scaling.h"

#define IMAGE_SIZE ((CGSize){640.0f, 640.0f})
#define CONSOLE_HEIGHT 80.0f
#define SUBSCRIBER_COUNTER_WIDTH 42.0f

static NSDateFormatter *__timeFormatter;

@interface MACCameraViewController() <TMFConnectorDelegate, MACCameraDelegate> {
    MACCamera *_camera;
    UIView *_preview;

    #warning Add ivars for commands Previews and CameraActions

    __weak NSTimer *_timer;

    NSLock *_waitingForImageResponseBlockLock;
    NSMutableArray *_waitingForImageResponseBlocks;

    UITextView *_console;
    UILabel *_subscribers;
}
@end

@implementation MACCameraViewController
//............................................................................
#pragma mark -
#pragma mark Memory Management
//............................................................................
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __timeFormatter = [NSDateFormatter new];
        [__timeFormatter setDateFormat:@"HH:mm:ss"];
        [__timeFormatter setLocale:[NSLocale currentLocale]];
    });
}

//............................................................................
#pragma mark -
#pragma mark Public
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Override
//............................................................................
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addConsoleView];
    [self addSubscriberCounterView];

    _waitingForImageResponseBlockLock = [NSLock new];
    _waitingForImageResponseBlocks = [NSMutableArray new];

#warning Create a command for camera previews.
// previews should be a publish subscribe command with the actual preview image as parameter (NSData)

#warning Create a command for camera actions.
// should be a request response command with the following actions
//    typedef enum MACCameraAction {
//        MACCameraActionNone = 0,
//        MACCameraActionToggleFlash, // turns flash on and off
//        MACCameraActionToggleCamera,
//        MACCameraActionTakePicture
//    } MACCameraAction;

// MACCameraActionToggleFlash should do
//    [_camera toggleTorch];
//    [_camera toggleFlash];
//    [self appendToConsole:[NSString stringWithFormat:@"%@ wants to toggled the flash.", peer.name]];

// MACCameraActionToggleCamera should do
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [_camera toggleCamera];
//    });
//    [self appendToConsole:[NSString stringWithFormat:@"%@ wants to toggled camera position.", peer.name]];

// MACCameraActionTakePicture should do
//    [_waitingForImageResponseBlockLock lock];
//    [_waitingForImageResponseBlocks addObject:[responseBlock copy]];
//    [_waitingForImageResponseBlockLock unlock];
//    if(![MACCamera hasCamera]) {
//        [self cameraStillImageCaptured:nil image:[self imageFromPreviewLayer]];
//    }
//    else {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [_camera captureStillImage];
//        });
//    }
//    [self appendToConsole:[NSString stringWithFormat:@"%@ is requesting still image.", peer.name]];

    _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_preview belowSubview:_console];

    if(![MACCamera hasCamera]) {
        _preview.backgroundColor = [UIColor whiteColor];
        UILabel *simulatorMessage = [[UILabel alloc] initWithFrame:self.view.bounds];
        simulatorMessage.numberOfLines = 2;
        simulatorMessage.text = @"Simulator Mode";
        simulatorMessage.font = [UIFont boldSystemFontOfSize:58.0f];
        simulatorMessage.textAlignment = NSTextAlignmentCenter;
        [_preview addSubview:simulatorMessage];
    }
    else {
        if(!_camera) {
            _camera = [MACCamera new];
            _camera.delegate = self;

            if([_camera setupSession]) {
                AVCaptureVideoPreviewLayer *captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[_camera session]];
                captureLayer.frame = self.view.bounds;
                captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

                _preview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [_preview.layer addSublayer:captureLayer];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [_camera.session startRunning];
                });
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning Puhlish commands
    [self appendToConsole:@"Waiting for subscribers"];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _preview.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate {
    return NO;
}

//............................................................................
#pragma mark -
#pragma mark Delegates
//............................................................................

#pragma mark TMFConnectorDelegate
#warning Report new subscribers 
// do on + subscribers for previews: [self appendToConsole:[NSString stringWithFormat:@"Added %@", peer.hostName]];
#warning Report leaving subscribers
// do on - subscribers for previews: [self appendToConsole:[NSString stringWithFormat:@"Removed %@", peer.hostName]];

#warning Display number of active substribers with _subscribers.text

#pragma mark MACCameraDelegate
- (void)camera:(MACCamera *)camera didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                    message:[error localizedFailureReason]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                          otherButtonTitles:nil] show];
    });
}

- (void)cameraStillImageCaptured:(MACCamera *)camera image:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    [_waitingForImageResponseBlockLock lock];
    NSArray *blocks = [_waitingForImageResponseBlocks copy];
    for(responseBlock_t block in blocks) {
        block(@{ @"image" :  imageData }, nil);
    }
    [_waitingForImageResponseBlocks removeObjectsInArray:blocks];
    [_waitingForImageResponseBlockLock unlock];
}

- (void)cameraPreviewImageCaptured:(MACCamera *)captureManager image:(UIImage *)image {
#warning Send preview image
// use small data: UIImageJPEGRepresentation(image, 0.6)
}

//............................................................................
#pragma mark -
#pragma mark Private
//............................................................................
- (void)appendToConsole:(NSString *)string {
    _console.text = [NSString stringWithFormat:@"%@[%@] %@\n", (_console.text ? _console.text : @""), [__timeFormatter stringFromDate:[NSDate date]], string];
    [_console scrollRangeToVisible:NSMakeRange([_console.text length]-1, 1)];
}

- (void)addConsoleView {
    _console = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - CONSOLE_HEIGHT, CGRectGetWidth(self.view.bounds), CONSOLE_HEIGHT)];
    _console.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _console.backgroundColor = [UIColor blackColor];
    _console.alpha = 0.8f;
    _console.font = [UIFont fontWithName:@"CourierNewPSMT" size:10.0f];
    _console.textColor = [UIColor whiteColor];
    _console.editable = NO;
    _console.contentInset = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    [self.view addSubview:_console];
}

- (void)addSubscriberCounterView {
    _subscribers = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.view.bounds) - SUBSCRIBER_COUNTER_WIDTH - 20.0f, 20.0f, SUBSCRIBER_COUNTER_WIDTH, SUBSCRIBER_COUNTER_WIDTH)];
    _subscribers.backgroundColor = [UIColor blackColor];
    _subscribers.alpha = 0.5f;
    _subscribers.font = [UIFont boldSystemFontOfSize:34];
    _subscribers.textColor = [UIColor whiteColor];
    _subscribers.textAlignment = NSTextAlignmentCenter;
    _subscribers.layer.cornerRadius = 8.0f;
    _subscribers.text = @"0";
    _console.contentInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    //    _subscribers.hidden = YES;
    [self.view addSubview:_subscribers];
}

- (UIImage *)imageFromPreviewLayer {
    UIGraphicsBeginImageContext(_preview.bounds.size);
    [_preview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
