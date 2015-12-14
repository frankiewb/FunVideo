//
//  NSTimer + FunVideo.m
//  FunVideo
//
//  Created by frankie on 15/11/22.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "NSTimer + FunVideo.h"

@implementation NSTimer(FunVideo)

+ (NSTimer *)FunVideo_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(FunVideo_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)FunVideo_blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if(block)
    {
        block();
    }
}




@end
