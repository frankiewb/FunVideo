//
//  UserViewController.h
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"

@interface UserViewController : UIViewController<UIAlertViewDelegate,DoubanDelegate>

@property (weak, nonatomic)id<DoubanDelegate>delegate;

@end
