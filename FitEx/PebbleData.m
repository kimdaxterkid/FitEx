//
//  PebbleData.m
//  FitEx-Pebble
//
//  Created by Taiwen Jin on 11/10/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PebbleData.h"

@implementation PebbleData
- (NSString*)start{
    myAppUUID = [[NSUUID alloc] initWithUUIDString:@"9efade42-0663-4711-beea-e450ebf12dc2"];
    
    [[PBPebbleCentral defaultCentral] dataLoggingServiceForAppUUID:myAppUUID].delegate = self;
    return @"PebbleData Starts";
}

- (UInt8*)dataBack {
	return myBytes;
}

/*
 // can just use data[0] to get that.
 
 // Convert the latter 4 bytes of 'data' into a number we can use in java.
 // We'll turn it into a long and multiply by 1000 to get ms from epoch.
 byte[] unsignedTime = new byte[] {0, 0, 0, 0, data[7], data[6], data[5], data[4]};
 byte[] steps = new byte[] {data[3], data[2], data[1], data[0]};
 
 byte[] myTeamSize = new byte[] {data[11], data[10], data[9], data[8]};
 byte[] rankInTeam = new byte[] {data[15], data[14], data[13], data[12]};
 byte[] rankOfTeam = new byte[] {data[19], data[18], data[17], data[16]};
 byte[] totalSteps = new byte[] {data[23], data[22], data[21], data[20]};
 byte[] numberOfTeams = new byte[] {data[27], data[26], data[25], data[24]};
 
 
 
 ByteBuffer buf = ByteBuffer.wrap(unsignedTime);
 ByteBuffer buf_steps = ByteBuffer.wrap(steps);
 
 ByteBuffer buf_myTeamSize = ByteBuffer.wrap(myTeamSize);
 ByteBuffer buf_rankInTeam = ByteBuffer.wrap(rankInTeam);
 ByteBuffer buf_rankOfTeam = ByteBuffer.wrap(rankOfTeam);
 ByteBuffer buf_totalSteps = ByteBuffer.wrap(totalSteps);
 ByteBuffer buf_numberOfTeams = ByteBuffer.wrap(numberOfTeams);
 
 
 */

- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasByteArrays:(const UInt8 * const)bytes numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
	NSLog(@"numberOfItems : %d\n", numberOfItems);
	
    if (numberOfItems == 0) {
        NSLog(@"CallBack1 Return Nothing");
    } else {
        for (int i = 0; i < numberOfItems; i++) {
            const uint8_t *logBytes = &bytes[i * session.itemSize];
            NSLog(@"%s", logBytes);
			
			uint8_t logByte = bytes[i];
			NSLog(@"%hhu", logByte);
        }
    }
	return YES;

}


//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasUInt8s:(const UInt8[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
//    NSLog(@"2");
//    return YES;
//}
//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasUInt16s:(const UInt16[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
//    NSLog(@"3");
//    return YES;
//}
//
//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasUInt32s:(const UInt32[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
//    NSLog(@"4");
//    return YES;
//}
//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasSInt8s:(const SInt8[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
//    NSLog(@"5");
//    return YES;
//}
//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasSInt16s:(const SInt16[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
//    NSLog(@"6");
//    return YES;
//}
//
//
//- (BOOL)dataLoggingService:(PBDataLoggingService *)service hasSInt32s:(const SInt32[])data numberOfItems:(UInt16)numberOfItems forDataLoggingSession:(PBDataLoggingSessionMetadata *)session{
//    NSLog(@"6");
//    return YES;
//}


- (void)dataLoggingService:(PBDataLoggingService *)service sessionDidFinish:(PBDataLoggingSessionMetadata *)session {
    
    NSLog(@"Finished data log");
    
}


@end


