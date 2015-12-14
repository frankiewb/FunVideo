//
//  AppDelegate.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MediaPlayer/MediaPlayer.h>


@class UserInfo;
@class PlayerInfo;
@class ChannelGroup;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)MPMoviePlayerController *VideoPlayer;
@property (strong, nonatomic)UserInfo *userInfo;
@property (strong, nonatomic)PlayerInfo *playerInfo;
@property (strong, nonatomic)ChannelGroup *channelGroup;
//表示当前iphone型号
@property (copy, nonatomic)NSString *deviceMode;



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

