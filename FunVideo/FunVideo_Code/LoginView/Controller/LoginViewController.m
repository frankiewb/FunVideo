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
#import "Commons.h"



#define UILOGINVIEWLABELCOLOR [UIColor whiteColor]

static const CGFloat kOrigin_Xpoint              = 10;
static const CGFloat kOrigin_Ypoint              = 35;
static const CGFloat kLabelHeight_Distance       = 30;
static const CGFloat kTextFieldHeight_Distance   = 20;
static const CGFloat kCaptchaImageWidth_Distance = 10;

static const CGFloat kLabel_Field_Width          = 300;
static const CGFloat kLabel_Field_Height         = 50;

static const CGFloat kCaptcha_Width              = 140;
static const CGFloat kCaptcha_Height             = 50;

static const CGFloat kCaptchaImageView_Width     = 150;
static const CGFloat kCaptchaImageView_Height    = 50;

static const CGFloat kButtonHeight_Distance      = 50;
static const CGFloat kButton_Width               = 300;
static const CGFloat kButton_Heigth              = 50;







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
}

-(void)p_setupUI
{
    self.view.backgroundColor =  UIBACKGROUNDCOLOR;
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    
    
    
    //设置代理后一定要赋值代理，谁具体代理赋值给谁
    doubanServer.delegate = (id)self;
    
    
    
    
    /*“登录”标签*/
    loginViewTitle = [[UILabel alloc]init];
    loginViewTitle.text = @"用户登录";
    loginViewTitle.backgroundColor = UIBACKGROUNDCOLOR;
    loginViewTitle.font = [UIFont systemFontOfSize:30];
    loginViewTitle.textColor = [UIColor blackColor];
    loginViewTitle.textAlignment = NSTextAlignmentLeft;
    loginViewTitle.layer.masksToBounds = YES;
    loginViewTitle.layer.cornerRadius = 6;
    loginViewTitle.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint, kLabel_Field_Width, kLabel_Field_Height);
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
    loginNameTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 1 + kLabelHeight_Distance, kLabel_Field_Width, kLabel_Field_Height);
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
    loginPassWordTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 2 + kLabelHeight_Distance + kTextFieldHeight_Distance * 1, kLabel_Field_Width, kLabel_Field_Height);
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
    captchaImageTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 3 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2, kCaptcha_Width, kCaptcha_Height);
    [self.view addSubview:captchaImageTextField];
    
    /*验证码图片*/
    captchaImageView = [[UIImageView alloc]init];
    captchaImageView.layer.masksToBounds = YES;
    captchaImageView.layer.cornerRadius = 10;
    captchaImageView.backgroundColor = UILOGINVIEWLABELCOLOR;
    captchaImageView.userInteractionEnabled = YES;
    captchaImageView.frame = CGRectMake(kOrigin_Xpoint + kCaptcha_Width + kCaptchaImageWidth_Distance, kOrigin_Ypoint + kLabel_Field_Height * 3 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 , kCaptchaImageView_Width, kCaptchaImageView_Height);
    [self.view addSubview:captchaImageView];
    
    
    /*登录Button*/
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    loginButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [loginButton addTarget:self action:@selector(p_login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 4 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 + kButtonHeight_Distance * 1, kButton_Width, kButton_Heigth);
    [self.view addSubview:loginButton];
    
    /*登出Button*/
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(p_cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 5 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 + kButtonHeight_Distance * 1.5, kButton_Width, kButton_Heigth);
    [self.view addSubview:cancelButton];
    
    //添加验证码点击更新事件
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_loadCaptchaImage)];
    [singleTap setNumberOfTapsRequired:1];
    [captchaImageView addGestureRecognizer:singleTap];
    
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


@end
