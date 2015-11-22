//
//  ChannelTableViewController.h
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"

@interface ChannelTableViewController : UITableViewController<DoubanDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>

@property(nonatomic,weak) id<DoubanDelegate> delegate;

@end
