//
//  ChannelTableViewController.h
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"
#import "EGORefreshTableHeaderView.h"

@interface ChannelTableViewController : UIViewController<DoubanDelegate,UIGestureRecognizerDelegate,EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id<DoubanDelegate> delegate;

@end
