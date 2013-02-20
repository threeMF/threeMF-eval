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
// It should be reqestable and return YES or NO (suceeed or not)

#warning TODO: Add MACCameraActionCommand
#warning TODO: Add MACCameraActionCommandArguments

// remember to respect the naming convenction for arguments classes or link their classes to the command
// like described in http://threemf.com/documentation/Classes/TMFCommand.html#//api/name/argumentsClass