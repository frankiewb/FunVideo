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
    
    UILabel * LoginViewTitle;
    
    UITextField * LoginNameTextField;
    
    UITextField * LoginPassWordTextField;
    
    UITextField * CaptchaImageTextField;
    
    UIImageView * CaptchaImageView;
    
    UIButton * LoginButton;
    
    UIButton * CancelButton;
    
}







@end


@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self SetupUI];
}

-(void)SetupUI
{
    self.view.backgroundColor =  UIBACKGROUNDCOLOR;
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    
    
    
    //设置代理后一定要赋值代理，谁具体代理赋值给谁
    doubanServer.delegate = (id)self;
    
    
    
    
    /*“登录”标签*/
    LoginViewTitle = [[UILabel alloc]init];
    LoginViewTitle.text = @"用户登录";
    LoginViewTitle.backgroundColor = UIBACKGROUNDCOLOR;
    LoginViewTitle.font = [UIFont systemFontOfSize:30];
    LoginViewTitle.textColor = [UIColor blackColor];
    LoginViewTitle.textAlignment = NSTextAlignmentLeft;
    LoginViewTitle.layer.masksToBounds = YES;
    LoginViewTitle.layer.cornerRadius = 6;
    LoginViewTitle.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint, kLabel_Field_Width, kLabel_Field_Height);
    [self.view addSubview:LoginViewTitle];
    
    
    /*用户名输入框*/
    LoginNameTextField = [[UITextField alloc]init];
    LoginNameTextField.delegate = self;
    LoginNameTextField.placeholder = @"邮箱／用户名";
    LoginNameTextField.textColor = [UIColor blackColor];
    LoginNameTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    LoginNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    LoginNameTextField.textAlignment = NSTextAlignmentLeft;
    LoginNameTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    LoginNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    LoginNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    LoginNameTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    LoginNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    LoginNameTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    LoginNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    //设置首字母是否大写
    LoginNameTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    LoginNameTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    LoginNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    LoginNameTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 1 + kLabelHeight_Distance, kLabel_Field_Width, kLabel_Field_Height);
    [self.view addSubview:LoginNameTextField];
    
    
    /*密码输入框*/
    LoginPassWordTextField = [[UITextField alloc]init];
    LoginPassWordTextField.delegate = self;
    LoginPassWordTextField.placeholder = @"密码";
    LoginPassWordTextField.textColor = [UIColor blackColor];
    LoginPassWordTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    LoginPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    LoginPassWordTextField.textAlignment = NSTextAlignmentLeft;
    LoginPassWordTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    LoginPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    LoginPassWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    LoginPassWordTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    LoginPassWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    LoginPassWordTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    LoginPassWordTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    LoginPassWordTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    LoginPassWordTextField.returnKeyType = UIReturnKeyDone;
    //设置输入密码保护
    LoginPassWordTextField.secureTextEntry = YES;
    //设置键盘外观
    LoginPassWordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    LoginPassWordTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 2 + kLabelHeight_Distance + kTextFieldHeight_Distance * 1, kLabel_Field_Width, kLabel_Field_Height);
    [self.view addSubview:LoginPassWordTextField];
    
    
    
    /*验证码输入框*/
    CaptchaImageTextField = [[UITextField alloc]init];
    CaptchaImageTextField.delegate = self;
    CaptchaImageTextField.placeholder = @"验证码";
    CaptchaImageTextField.textColor = [UIColor blackColor];
    CaptchaImageTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    CaptchaImageTextField.borderStyle = UITextBorderStyleRoundedRect;
    CaptchaImageTextField.textAlignment = NSTextAlignmentLeft;
    CaptchaImageTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    CaptchaImageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    CaptchaImageTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    CaptchaImageTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    CaptchaImageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    CaptchaImageTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    CaptchaImageTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    CaptchaImageTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    CaptchaImageTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    CaptchaImageTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    CaptchaImageTextField.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 3 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2, kCaptcha_Width, kCaptcha_Height);
    [self.view addSubview:CaptchaImageTextField];
    
    /*验证码图片*/
    CaptchaImageView = [[UIImageView alloc]init];
    CaptchaImageView.layer.masksToBounds = YES;
    CaptchaImageView.layer.cornerRadius = 10;
    CaptchaImageView.backgroundColor = UILOGINVIEWLABELCOLOR;
    CaptchaImageView.userInteractionEnabled = YES;
    CaptchaImageView.frame = CGRectMake(kOrigin_Xpoint + kCaptcha_Width + kCaptchaImageWidth_Distance, kOrigin_Ypoint + kLabel_Field_Height * 3 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 , kCaptchaImageView_Width, kCaptchaImageView_Height);
    [self.view addSubview:CaptchaImageView];
    
    
    /*登录Button*/
    LoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [LoginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [LoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    LoginButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [LoginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    LoginButton.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 4 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 + kButtonHeight_Distance * 1, kButton_Width, kButton_Heigth);
    [self.view addSubview:LoginButton];
    
    /*登出Button*/
    CancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CancelButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [CancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [CancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [CancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    CancelButton.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint + kLabel_Field_Height * 5 + kLabelHeight_Distance + kTextFieldHeight_Distance * 2 + kButtonHeight_Distance * 1.5, kButton_Width, kButton_Heigth);
    [self.view addSubview:CancelButton];
    
    //添加验证码点击更新事件
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoadCaptchaImage)];
    [singleTap setNumberOfTapsRequired:1];
    [CaptchaImageView addGestureRecognizer:singleTap];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadCaptchaImage];
}

-(void)LoginSuccessful
{
    [_delegate SetUserInfo];
    NSLog(@"LOGIN_SUCCESSFUL");
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)SetCaptchaImageWithURL:(NSString *) captchaImageURL
{
    [CaptchaImageView setImageWithURL:[NSURL URLWithString:captchaImageURL] placeholderImage:nil];
}



-(void)LoadCaptchaImage
{
    [doubanServer DoubanLoadCaptchaImage];
}



-(void)Login
{
    loginInfo = [[LoginInfo alloc]init];
    loginInfo.LoginName = LoginNameTextField.text;
    loginInfo.PassWord = LoginPassWordTextField.text;
    loginInfo.CapthchaInputWord = CaptchaImageTextField.text;
    [doubanServer DoubanLoginWithLoginInfo:loginInfo];
}


-(void)Cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [LoginNameTextField resignFirstResponder];
    [LoginPassWordTextField resignFirstResponder];
    [CaptchaImageTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
