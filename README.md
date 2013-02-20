# threeMF Evaluation Project
This is an evaluation project for [3MF](http://threemf.com). 

First please read [this blog post](http://www.mgratzer.com/introducing-threeMF/) to know what this repository is about and how you can take part in this little framework evaluation.

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
	- **While building the app please write a diary, take down your thoughts which can point out where improvements should be made (or record some audio, everything helps)**
	- Take down the time it takes you to do the evaluation
	- Use the [sample applications](https://github.com/mgratzer/threeMF/tree/master/Samples) for further insights
4.  Push your code back to your Github fork
5. And finally it would be very kind if you fill out this [survey](http://grzr.me/3mfeval) 

**threeMF-eval is not an working application out of the box and prepared with placeholders for an implementation with 3MF.** *#warning* directives are used all over to indicate where additions have to be made.


