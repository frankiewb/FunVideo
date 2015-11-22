//
//  LoginViewController.h
//  FunVideo
//
//  Created by frankie on 15/10/28.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubanServer.h"


//使用代理
@protocol LoginViewDelegate <NSObject>

@optional
-(void)loginViewDelegate_setUserInfo;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate, DoubanDelegate, LoginViewDelegate>

@property (weak, nonatomic)id<DoubanDelegate>douban_delegate;

@property (weak, nonatomic)id<LoginViewDelegate>loginView_delegate;

@end
