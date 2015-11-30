//
//  LoginViewController.h
//  FunVideo
//
//  Created by frankie on 15/10/28.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate, DoubanDelegate>

@property (weak, nonatomic)id<DoubanDelegate>douban_delegate;

@end
