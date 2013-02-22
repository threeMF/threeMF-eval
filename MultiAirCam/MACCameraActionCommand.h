//
//  MACCameraActionCommand.h
//  MultiAirCam
//
//  Created by Martin Gratzer on 21.12.12.
//  Copyright (c) 2012 Martin Gratzer. All rights reserved.
//

typedef enum MACCameraAction {
    MACCameraActionNone = 0,
    MACCameraActionToggleFlash,
    MACCameraActionToggleCamera,
    MACCameraActionTakePicture
} MACCameraAction;

// This command needs to transmit the requested aciton as parameter
// It should be reqestable and return either YES or NO for the toggle methods (suceeed or not) - in fact it doesn't matter if it suceeds or not in our use case.
// For the MACCameraActionTakePicture action it should return the image's data

#warning TODO Step 2: Add MACCameraActionCommand
#warning TODO Step 2: Add MACCameraActionCommandArguments

// remember to respect the naming convenction for arguments classes or link their classes to the command
// like described in http://threemf.com/documentation/Classes/TMFCommand.html#//api/name/argumentsClass