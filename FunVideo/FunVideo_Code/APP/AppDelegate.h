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

/**
 * 必须保证无论跳转哪个页面播放器一直在工作，直至app退出，故须放置在AppDelegate中
 */
@property (strong, nonatomic)MPMoviePlayerController *VideoPlayer;

/**
 * 保证UserInfo存在于全局
 */
@property (strong, nonatomic)UserInfo * userInfo;

/**
 * 保证PlayerInfo存在于全局
 */
@property (strong, nonatomic)PlayerInfo * playerInfo;

/**
 * 保证ChannelGroup存在于全局
 */
@property (strong, nonatomic)ChannelGroup * channelGroup;


/**
 * 表示当前iphone型号
 */
@property (copy, nonatomic)NSString * deviceMode;



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

