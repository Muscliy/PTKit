//
//  PTDeviceTypes_iOS.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#ifndef PTDeviceTypes_iOS_h
#define PTDeviceTypes_iOS_h

typedef NS_ENUM(NSInteger, PTDeviceModel) {
	PTDeviceModelUnknown = 0,
	PTDeviceModelSimulatoriPhone,
	PTDeviceModelSimulatoriPad,
	PTDeviceModeliPhone1,
	PTDeviceModeliPhone3G,
	PTDeviceModeliPhone3GS,
	PTDeviceModeliPhone4,
	PTDeviceModeliPhone4S,
	PTDeviceModeliPhone5,
	PTDeviceModeliPhone5C,
	PTDeviceModeliPhone5S,
	PTDeviceModeliPhone6,
	PTDeviceModeliPhone6Plus,
	PTDeviceModeliPad1,
	PTDeviceModeliPad2,
	PTDeviceModeliPad3,
	PTDeviceModeliPad4,
	PTDeviceModeliPadMini1,
	PTDeviceModeliPadMini2,
	PTDeviceModeliPadMini3,
	PTDeviceModeliPadAir1,
	PTDeviceModeliPadAir2,
	PTDeviceModeliPod1,
	PTDeviceModeliPod2,
	PTDeviceModeliPod3,
	PTDeviceModeliPod4,
	PTDeviceModeliPod5,
};

typedef NS_ENUM(NSInteger, PTDeviceFamily) {
	PTDeviceFamilyUnknown = 0,
	PTDeviceFamilyiPhone,
	PTDeviceFamilyiPad,
	PTDeviceFamilyiPod,
	PTDeviceFamilySimulator,
};

typedef NS_ENUM(NSInteger, PTDeviceDisplay) {
	PTDeviceDisplayUnknown = 0,
	PTDeviceDisplayiPad,
	PTDeviceDisplayiPhone35Inch,
	PTDeviceDisplayiPhone4Inch,
	PTDeviceDisplayiPhone47Inch,
	PTDeviceDisplayiPhone55Inch,
};

typedef NS_ENUM(NSInteger, PTByteOrder) {
	PTByteOrderLittleEndian,
	PTByteOrderBigEndian,
};

#endif /* PTDeviceTypes_iOS_h */
