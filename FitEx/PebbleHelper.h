//
//  PebbleHelper.h
//  FitEx-Pebble
//
//  Created by Taiwen Jin on 10/31/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

#ifndef PebbleHelper_h
#define PebbleHelper_h
#import "PebbleKit/PebbleKit.h"

@interface PebbleHelper : NSObject <PBPebbleCentralDelegate> {
    NSUUID *myAppUUID;
	int userStepsData;
}
@property NSString *helperMessage;
@property (weak, nonatomic) PBWatch *watch;
@property (weak, nonatomic) PBPebbleCentral *central;

- (NSString*)start: (int)stepsFromPhone;
- (void) data1Sent: (int)userSteps;
- (void) data2Sent;
- (void) data3Sent;
@end

#endif /* PebbleHelper_h */
