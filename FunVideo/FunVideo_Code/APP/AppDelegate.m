//
//  AppDelegate.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "DoubanServer.h"
#import "UserInfo.h"
#import "PlayerInfo.h"
#import "ChannelGroup.h"
#import "SongInfo.h"

@interface AppDelegate ()
{
    DoubanServer * doubanServer;
}

@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self p_initSharedVideoPlayer];
    return YES;
}


- (void)p_initSharedVideoPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _VideoPlayer = [[MPMoviePlayerController alloc]init];
        _userInfo = [[UserInfo alloc]init];
        _playerInfo = [[PlayerInfo alloc]initPlayerInfo];
        _channelGroup = [[ChannelGroup alloc]init];
        doubanServer = [[DoubanServer alloc]initDoubanServer];
        [self p_unArchiveVideoInfo];
                
        //后台播放FrankieVideoPlayer
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    });
}

//归档
-(void)p_archiveVideoInfo
{
    NSString * path = [[NSBundle mainBundle]bundlePath];
    
    //归档playerInfo
    NSLog(@"CurrentSong : %@",_playerInfo.currentSong);
    NSString *  playerpath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoPlayerInfo.archiver"];
    BOOL playerInfoflag = [NSKeyedArchiver archiveRootObject:_playerInfo toFile:playerpath];
    if(playerInfoflag)
    {
        NSLog(@"playerInfo archived successfuly");
    }
    else
    {
        NSLog(@"playerInfo archived failled");
    }
    
    
    //归档ChannelGroup
    NSLog(@"CurrentChannelGroup: %@",_channelGroup);
    NSString * channelGroupInfoPath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoChannelInfo.archiver"];
    BOOL channelInfoflag = [NSKeyedArchiver archiveRootObject:_channelGroup toFile:channelGroupInfoPath];
    if(channelInfoflag)
    {
        NSLog(@"channelGroup archived successfuly");
    }
    else
    {
        NSLog(@"channelGroup archived failled");
    }
    
    //归档UserInfo
    NSString * userInfoPath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoUserInfo.archiver"];
    BOOL userInfoflag = [NSKeyedArchiver archiveRootObject:_userInfo toFile:userInfoPath];
    if(userInfoflag)
    {
        NSLog(@"userInfo archived successfuly");
    }
    else
    {
        NSLog(@"userInfo archived failled");
        
    }
    
}

//解档
-(void)p_unArchiveVideoInfo
{
    NSString * path = [[NSBundle mainBundle]bundlePath];
    
    //解档playerInfo
    NSString *  playerPath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoPlayerInfo.archiver"];
    PlayerInfo * tempPlayerInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:playerPath];
    if(tempPlayerInfo)
    {
        _playerInfo = tempPlayerInfo;
        NSLog(@"RECurrentSong : %@",_playerInfo.currentSong);
        NSLog(@"playerInfo Unarchived");
    }
    else
    {
        NSLog(@"NO FILE ERROR : PLAYERINFO");
    }
    
    
    //解档ChannelGroup
    NSString * channelGroupInfoPath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoChannelInfo.archiver"];
    ChannelGroup * tempChannelGroupInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:channelGroupInfoPath];
    if(tempChannelGroupInfo)
    {
        _channelGroup = tempChannelGroupInfo;
        NSLog(@"ChannelGroupInfo Unarchived");
    }
    else
    {
         NSLog(@"NO FILE ERROR : CHANNELINFO");
    }
    
    //解档UserInfo
    NSString * userInfopath = [[NSString alloc]initWithFormat:@"%@%@",path,@"/FunVideoUserInfo.archiver"];
    UserInfo * tempUserInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:userInfopath];
    if(tempUserInfo)
    {
        _userInfo = tempUserInfo;
        NSLog(@"UserInfo Unarchived");
    }
    else
    {
        NSLog(@"NO FILE ERROR : USERINFO");
    }
    
    
    
}
















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //当app进入后台需要将playerInfo以及ChannelInfo保存
    
    [self p_archiveVideoInfo];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //当app进入前台时解档读取playerInfo及ChannelInfo
    
    [self p_unArchiveVideoInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "frankie.FrankieVideo_New" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FrankieVideo_New" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FrankieVideo_New.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
