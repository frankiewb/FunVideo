//
//  LoginViewController.m
//  FunVideo
//
//  Created by frankie on 15/10/28.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UIKIT+AFNetworking.h"
#import "LoginViewController.h"
#import "LoginInfo.h"
#import "Masonry.h"
#import "Commons.h"



#define UILOGINVIEWLABELCOLOR [UIColor whiteColor]
static const CGFloat kHeadLabelTopPoint               = 35;
static const CGFloat kButtonLabelWidthFactor          = 0.83f;
static const CGFloat kButtonLabelHeightFactor         = 0.08f;
static const CGFloat kCaptchaTextCenterXFactor        = 0.572f;
static const CGFloat kCaptchaImageCenterXFactor       = 1.433f;
static const CGFloat kLoginNameTextFieldTopFactor     = 1.35f;
static const CGFloat kLoginPassWordTextFieldTopFactor = 1.12f;
static const CGFloat kCaptchaTopFactor                = 1.085f;
static const CGFloat kLoginTopFactor                  = 1.164f;
static const CGFloat kLogoutTopFactor                 = 1.05f;








@interface LoginViewController()
{
    
    DoubanServer * doubanServer;
    
    LoginInfo * loginInfo;
    
    UILabel * loginViewTitle;
    
    UITextField * loginNameTextField;
    
    UITextField * loginPassWordTextField;
    
    UITextField * captchaImageTextField;
    
    UIImageView * captchaImageView;
    
    UIButton * loginButton;
    
    UIButton * cancelButton;
    
}







@end


@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
    [self p_setUpAutoLayOut];
}

-(void)p_setupUI
{
    self.view.backgroundColor =  UIBACKGROUNDCOLOR;
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    
    
    
    //设置代理后一定要赋值代理，谁具体代理赋值给谁
    doubanServer.delegate = (id)self;
    
    
    
    
    
    
    //以下尝试采用Masonry自动布局框架来对页面控件进行自动布局
    
    
    
    /*“登录”标签*/
    loginViewTitle = [[UILabel alloc]init];
    loginViewTitle.text = @"登录";
    loginViewTitle.backgroundColor = UIBACKGROUNDCOLOR;
    loginViewTitle.font = [UIFont systemFontOfSize:30];
    loginViewTitle.textColor = [UIColor blackColor];
    loginViewTitle.textAlignment = NSTextAlignmentLeft;
    loginViewTitle.layer.masksToBounds = YES;
    loginViewTitle.layer.cornerRadius = 6;
    [self.view addSubview:loginViewTitle];
    

    /*用户名输入框*/
    loginNameTextField = [[UITextField alloc]init];
    loginNameTextField.delegate = self;
    loginNameTextField.placeholder = @"邮箱／用户名";
    loginNameTextField.textColor = [UIColor blackColor];
    loginNameTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    loginNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    loginNameTextField.textAlignment = NSTextAlignmentLeft;
    loginNameTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    loginNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    loginNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    loginNameTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    loginNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    loginNameTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    loginNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    //设置首字母是否大写
    loginNameTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    loginNameTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    loginNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.view addSubview:loginNameTextField];
    

    /*密码输入框*/
    loginPassWordTextField = [[UITextField alloc]init];
    loginPassWordTextField.delegate = self;
    loginPassWordTextField.placeholder = @"密码";
    loginPassWordTextField.textColor = [UIColor blackColor];
    loginPassWordTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    loginPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    loginPassWordTextField.textAlignment = NSTextAlignmentLeft;
    loginPassWordTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    loginPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    loginPassWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    loginPassWordTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    loginPassWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    loginPassWordTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    loginPassWordTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    loginPassWordTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    loginPassWordTextField.returnKeyType = UIReturnKeyDone;
    //设置输入密码保护
    loginPassWordTextField.secureTextEntry = YES;
    //设置键盘外观
    loginPassWordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.view addSubview:loginPassWordTextField];

    
    /*验证码输入框*/
    captchaImageTextField = [[UITextField alloc]init];
    captchaImageTextField.delegate = self;
    captchaImageTextField.placeholder = @"验证码";
    captchaImageTextField.textColor = [UIColor blackColor];
    captchaImageTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    captchaImageTextField.borderStyle = UITextBorderStyleRoundedRect;
    captchaImageTextField.textAlignment = NSTextAlignmentLeft;
    captchaImageTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    captchaImageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    captchaImageTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    captchaImageTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    captchaImageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    captchaImageTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    captchaImageTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    captchaImageTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    captchaImageTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    captchaImageTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.view addSubview:captchaImageTextField];
    
    /*验证码图片*/
    captchaImageView = [[UIImageView alloc]init];
    captchaImageView.layer.masksToBounds = YES;
    captchaImageView.layer.cornerRadius = 10;
    captchaImageView.backgroundColor = UILOGINVIEWLABELCOLOR;
    captchaImageView.userInteractionEnabled = YES;
    [self.view addSubview:captchaImageView];
    
    
    /*登录Button*/
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = UIBUTTONCOLOR;
    [loginButton addTarget:self action:@selector(p_login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    /*登出Button*/
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.backgroundColor = UIBUTTONCOLOR;
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(p_cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    //添加验证码点击更新事件
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_loadCaptchaImage)];
    [singleTap setNumberOfTapsRequired:1];
    [captchaImageView addGestureRecognizer:singleTap];
    
}










-(void)p_setUpAutoLayOut
{
    //loginViewTitle
    [loginViewTitle mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.view.mas_top).with.offset(kHeadLabelTopPoint);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(kButtonLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
     }];
    
    //loginNameTextField
    [loginNameTextField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(loginViewTitle.mas_bottom).with.multipliedBy(kLoginNameTextFieldTopFactor);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(kButtonLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
     }];
    
    //loginPassWordTextField
    [loginPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(loginNameTextField.mas_bottom).with.multipliedBy(kLoginPassWordTextFieldTopFactor);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(kButtonLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
     }];
    
    //captchaImageTextField
    [captchaImageTextField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         
         make.top.equalTo(loginPassWordTextField.mas_bottom).with.multipliedBy(kCaptchaTopFactor);
         make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(kCaptchaTextCenterXFactor);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(0.483* kButtonLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
     }];
    
    //captchaIMageView
    [captchaImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(loginPassWordTextField.mas_bottom).with.multipliedBy(kCaptchaTopFactor);
         make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(kCaptchaImageCenterXFactor);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(0.483* kButtonLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
     }];
    
    //loginButton
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(captchaImageTextField.mas_bottom).with.multipliedBy(kLoginTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kButtonLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
    }];
    
    
    //cancelBUtton
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(loginButton.mas_bottom).with.multipliedBy(kLogoutTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kButtonLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kButtonLabelHeightFactor);
    }];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_loadCaptchaImage];
}

-(void)doubanDelegate_loginSuccessful
{
    [_loginView_delegate loginViewDelegate_setUserInfo];
    NSLog(@"LOGIN_SUCCESSFUL");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doubanDelegate_loginFail:(NSString *)errorMessege
{
    //采用IOS8提供的UIAlerController
    UIAlertController * alerController = [UIAlertController alertControllerWithTitle:@"登录失败"
                                                                             message:[NSString stringWithFormat:@"失败原因：%@",errorMessege]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:cancelAction];
    [self presentViewController:alerController animated:YES completion:nil];

}


-(void)doubanDelegate_setCaptchaImageWithURL:(NSString *) captchaImageURL
{
    [captchaImageView setImageWithURL:[NSURL URLWithString:captchaImageURL] placeholderImage:nil];
}



-(void)p_loadCaptchaImage
{
    [doubanServer doubanLoadCaptchaImage];
}



-(void)p_login
{
    loginInfo = [[LoginInfo alloc]init];
    loginInfo.loginName = loginNameTextField.text;
    loginInfo.passWord = loginPassWordTextField.text;
    loginInfo.capthchaInputWord = captchaImageTextField.text;
    [doubanServer doubanLoginWithLoginInfo:loginInfo];
}


-(void)p_cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [loginNameTextField resignFirstResponder];
    [loginPassWordTextField resignFirstResponder];
    [captchaImageTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//Portrait = 正常竖屏
//UpsideDown ＝ 竖着倒转
//Landscape Left ＝ 横屏且按钮在左边
//Landscape Right = 横屏且按钮在右边

//是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    //不支持自动旋转，则默认正常竖屏Portrait
    return NO;
}

@end
