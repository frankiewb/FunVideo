//
//  NSTimer + FunVideo.h
//  FunVideo
//
//  Created by frankie on 15/11/22.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(FunVideo)

+(NSTimer *)FunVideo_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
