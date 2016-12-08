//
//  PebbleData.h
//  FitEx-Pebble
//
//  Created by Taiwen Jin on 11/10/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

#ifndef PebbleData_h
#define PebbleData_h
#import "PebbleKit/PebbleKit.h"
@interface PebbleData : NSObject <PBDataLoggingServiceDelegate> {
    NSUUID *myAppUUID;
	UInt8 *myBytes;
}
@property NSString *steps;
- (NSString*) start;
- (UInt8*) dataBack;

@end
#endif /* PebbleData_h */
