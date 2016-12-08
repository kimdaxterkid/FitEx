//
//  PebbleHelper.m
//  FitEx-Pebble
//
//  Created by Taiwen Jin on 10/31/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PebbleHelper.h"

@implementation PebbleHelper

- (NSString*)start: (int)stepsFromPhone{
    myAppUUID = [[NSUUID alloc] initWithUUIDString:@"9efade42-0663-4711-beea-e450ebf12dc2"];
    self.central = [PBPebbleCentral defaultCentral];
    self.central.delegate = self;
    self.central.appUUID = myAppUUID;
	
	userStepsData = stepsFromPhone;
	
	[self.central run];
    return @"Hello OBJ-C";
}

- (void) pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew {
    if (self.watch) {
        return;
    }
    self.watch = watch;
    
    // Check AppMessage is supported by this watch
    [self.watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Tell the user using the Label
            self.helperMessage = @"Watch connected and AppMessage is supported!";
            [self.watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
                NSLog(@"Received message: %@", update);
                NSNumber *key = @4;
                
                // If the key is present in the received dictionary
                if (update[key]) {
                    // Read the integer value
                    int value = [update[key] intValue];
                    NSLog(@"%d", value);
                }
				[self data1Sent:userStepsData];
                [NSTimer scheduledTimerWithTimeInterval:5.0
                                                 target:self
                                               selector:@selector(data2Sent)
                                               userInfo:nil
                                                repeats:NO];
                return YES;
            }];
        } else {
            self.helperMessage = @"Watch connected but AppMessage is NOT supported!";
        }
    }];
	
}

- (void) pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    NSLog(@"Pebble disconnected: %@", [watch name]);
    
    if (self.watch == watch) {
        self.watch = nil;
        self.helperMessage = @"Watch disconnected";
    }
	
}


- (void) data1Sent: (int)userSteps{
    
    /*
     public static final int TEAM_RANK_KEY = 0;
     public static final int PERSONAL_RANK_KEY = 1;
     public static final int ME_IN_TEAM_RANK = 2;
     public static final int STEPS_KEY = 3;
     public static final int TOTAL_TEAMS = 4;
     public static final int TOTAL_USERS = 5;
     public static final int MY_TEAM_SIZE = 6;
     public static final int PERCENT_GOAL = 7;
     public static final int OFFER_KEY = 8;
     public static final int RESET_TO_0 = 9;
     */
	
    NSDictionary *update = @{// My team's rank out of all teams
                             @(0):[NSNumber numberWithUint16:7],
                             // No idea
                             @(1):[NSNumber numberWithUint16:18],
                             // No idea
                             @(2):[NSNumber numberWithInt8:17],
                              
                             // All teammates' steps without user's
                             @(3):[NSNumber numberWithUint16:100],
                              
                             // The total number of teams
                             @(4):[NSNumber numberWithInt8:9],
                              
                             // No idea
                             @(5):[NSNumber numberWithUint16:85],
                              
                             // User's team size
                             @(6):[NSNumber numberWithUint16:6],
                              
                             // User's steps - works if watch has the lower value
                             @(7):[NSNumber numberWithUint16:userSteps]
                             
//                             @(8):[NSNumber numberWithUint16:88],
//                             
//                             @(9):[NSNumber numberWithUint16:99]
                             
                             
                             };

    [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Sent general data to the watch.");
        } else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (void) data2Sent{
    NSDictionary *update2 = @{
                              @(10):[NSNumber numberWithUint16:10],    //  Player 1
                              @(11):[NSNumber numberWithUint16:20],    //  Player 2
                              @(12):[NSNumber numberWithUint16:30],    //  Player 3
                              @(13):[NSNumber numberWithUint16:40],    //  Player 4
                              @(14):[NSNumber numberWithUint16:0],    //  Player 5
                              @(15):[NSNumber numberWithUint16:0]     //  Player 6
                              };
    
    [self.watch appMessagesPushUpdate:update2 onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Sent user's team data to the watch.");
        } else {
            NSLog(@"Error sending message: %@", error);
        }
    }];

}
- (void) data3Sent{

	NSDictionary *update3 = @{
							 @(8):[NSNumber numberWithUint16:88],
							 @(9):[NSNumber numberWithUint16:99]
							 };
	
	[self.watch appMessagesPushUpdate:update3 onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
		if (!error) {
			NSLog(@"Clean pebble data.");
		} else {
			NSLog(@"Error sending message: %@", error);
		}
	}];
}

@end

