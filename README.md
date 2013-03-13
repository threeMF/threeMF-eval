# threeMF Evaluation Project

First please read [this blog post](http://www.mgratzer.com/introducing-threeMF/) to know what this repository is about and how you can take part in this little framework evaluation. Afterwards please follow the implementation instructions below.

## Project
This application is called **MultiAirCam** and uses [3MF](http://threemf.com) to share camera images between *n iPhones* and *m iPads*. These devices should find each other automatically via 3MF and iPads should subscribe to all iPhone cameras and display live preview data of what the camera is recording. Small images captured from the camera are transmitted to each subscribed iPad. *All the camera recording is ready to use, no effort in this direction has to be made!*

Each iPhone provides two services, one for sharing live preview images from their cameras as [publish subscribe command](https://github.com/mgratzer/threeMF/wiki/PublishSubscribe). The second service is a [request response command](https://github.com/mgratzer/threeMF/wiki/RequestResponse) allowing iPads to execute one of three different actions at each connected iPhone.

- Turn their flash on or off (`MACCameraActionToggleFlash`)
- Toggle between back-facing and front-facing camera (`MACCameraActionToggleCamera`) 
- Request a still shot image (`MACCameraActionTakePicture`)

3MF enables these devices to publish services (Commands) and share arbitrary data between each other with very little code. These devices find each other automatically on the local network and check their capabilities to talk with each other.

For more information on 3MF please read [this blog post](http://www.mgratzer.com/introducing-threeMF/), the [3MF Wiki](https://github.com/mgratzer/threeMF/wiki), the [code documentation](http://threemf.com/documentation/) or have a look at the existing [sample applications](https://github.com/mgratzer/threeMF/tree/master/Samples/).

## Tasks for this evaluation
1. Fork this project
2. Read about creating [Custom](https://github.com/mgratzer/threeMF/wiki/CustomCommands), [Publish Subscribe](https://github.com/mgratzer/threeMF/wiki/PublishSubscribe) and [Request Response](https://github.com/mgratzer/threeMF/wiki/RequestResponse) Commands
3. Build the project and replace all warnings with the necessary 3MF code. 
	- While building the app **please write a diary**, take down your thoughts which can point out where improvements should be made (or record some audio, everything helps). Simply create a text document and take down your thoughts after every step marked in the sample project and the time it took you to perform the step. You can copy your diary into the survey at the end of the evaluation.
	- Take down the time it takes you to do the evaluation
	- Use the [sample applications](https://github.com/mgratzer/threeMF/tree/master/Samples) for further insights
4.  Push your code back to your Github fork
5. And finally it would be very kind if you fill out this [survey](http://grzr.me/3mfeval) 

**threeMF-eval is not an working application out of the box and prepared with placeholders for an implementation with 3MF.** *#warning* directives are used all over to indicate where additions have to be made.

## Implementation Instructions

The project is divided into two view controllers, first the `MACCameraListViewController` which is the controller running on iPads displaying all iPhones in range. The second controller is `MACCameraViewController` containing all code for the iPhone. Both controllers are a subclass of `MACViewController` adding some convenience code and most importantly defining the `TMFConnector` property. Beside the 3MF commands, these are the only classes to change.

Two files for the planned commands already exist `MACPreviewCommand` and `MACCameraActionCommand` (but without any class definitions). 

### Step 1 - The Connector
Start with the initialization of the `[MACViewController tmf]` property in `[MACViewController init]`.

### Step 2 - Commands

#### Camera Action Command
This command should follow the [request response](https://github.com/mgratzer/threeMF/wiki/RequestResponse) pattern. Provide the command create a corresponding [arguments](https://github.com/mgratzer/threeMF/wiki/CustomCommands) class defining a `MACCameraAction` property and implementing the `- (id)initWithAction:(MACCameraAction)action` method.

#### Camera Preview Command
This command should follow the [publish subscribe](https://github.com/mgratzer/threeMF/wiki/PublishSubscribe) pattern. Provide the command and create a corresponding [arguments](https://github.com/mgratzer/threeMF/wiki/CustomCommands) class. This command sends small image frames to subscribers and therefore we can subclass `TMFImageCommand` and `TMFImageCommandArguments`.

### Step 3 - iPhone Controller

The `MACCameraViewController` is defined to run on iPhones which are the providers for our commands.

1. Add an ivar for each command to `MACCameraViewController`
2. Create both commands in `viewDidLoad` and provide the code below each warning in the `MACCameraActionCommand` receive block.
3. Publish both commands in `viewDidAppear`
4. Activate the code in `connector:didAddSubscriber:toCommand`
5. Activate the code in `connector:didRemoveSubscriber:fromCommand`
6. Create preview arguments and send them in `cameraPreviewImageCaptured:image:`

### Step 4 - iPad Controller

The `MACCameraListViewController` is defined to run on iPads which are subscribers for our commands. 

1. Start discovery for providers with our two commands in `viewWillAppear:` and use `self` as delegate.
2. Subscribe to the preview command and update the cameras preview image like in the given example (comment in code).
3. Execute all camera action commands and save the resulting image of `MACCameraActionTakePicture` to the photos album with `UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:response[@"image"]], nil, nil, nil);`






