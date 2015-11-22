//
//  UserViewController.h
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"
#import "LoginViewController.h"

@interface UserViewController : UIViewController<UIAlertViewDelegate,DoubanDelegate,LoginViewDelegate>

@property (weak, nonatomic)id<DoubanDelegate>douban_delegate;

@property (weak, nonatomic)id<LoginViewDelegate>loginView_delegate;

@end
