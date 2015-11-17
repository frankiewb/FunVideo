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

@interface LoginViewController()
{
    
    DoubanServer * doubanServer;
    
    LoginInfo * loginInfo;
    
}

@property (nonatomic, strong) UILabel * LoginViewTitle;

@property (nonatomic, strong) UITextField * LoginNameTextField;

@property (nonatomic, strong) UITextField * LoginPassWordTextField;

@property (nonatomic, strong) UITextField * CaptchaImageTextField;

@property (nonatomic, strong) UIImageView * CaptchaImageView;

@property (nonatomic, strong) UIButton * LoginButton;

@property (nonatomic, strong) UIButton * CancelButton;





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
    
    
    
    //设置代理后一定要赋值代理！！！！！
    doubanServer.delegate = (id)self;
    
    
    
    
    /*“登录”标签*/
    _LoginViewTitle = [[UILabel alloc]init];
    _LoginViewTitle.text = @"用户登录";
    _LoginViewTitle.backgroundColor = UIBACKGROUNDCOLOR;
    _LoginViewTitle.font = [UIFont systemFontOfSize:30];
    _LoginViewTitle.textColor = [UIColor blackColor];
    _LoginViewTitle.textAlignment = NSTextAlignmentLeft;
    _LoginViewTitle.layer.masksToBounds = YES;
    _LoginViewTitle.layer.cornerRadius = 6;
    _LoginViewTitle.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint, LoginView_Label_Field_Width, LoginView_Label_Field_Height);
    [self.view addSubview:_LoginViewTitle];
    
    
    /*用户名输入框*/
    _LoginNameTextField = [[UITextField alloc]init];
    _LoginNameTextField.delegate = self;
    _LoginNameTextField.placeholder = @"邮箱／用户名";
    _LoginNameTextField.textColor = [UIColor blackColor];
    _LoginNameTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    _LoginNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _LoginNameTextField.textAlignment = NSTextAlignmentLeft;
    _LoginNameTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    _LoginNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    _LoginNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    _LoginNameTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    _LoginNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    _LoginNameTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    _LoginNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    //设置首字母是否大写
    _LoginNameTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    _LoginNameTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    _LoginNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    _LoginNameTextField.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 1 + LoginView_LabelHeight_Distance, LoginView_Label_Field_Width, LoginView_Label_Field_Height);
    [self.view addSubview:_LoginNameTextField];
    
    
    /*密码输入框*/
    _LoginPassWordTextField = [[UITextField alloc]init];
    _LoginPassWordTextField.delegate = self;
    _LoginPassWordTextField.placeholder = @"密码";
    _LoginPassWordTextField.textColor = [UIColor blackColor];
    _LoginPassWordTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    _LoginPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _LoginPassWordTextField.textAlignment = NSTextAlignmentLeft;
    _LoginPassWordTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    _LoginPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    _LoginPassWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    _LoginPassWordTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    _LoginPassWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    _LoginPassWordTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    _LoginPassWordTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    _LoginPassWordTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    _LoginPassWordTextField.returnKeyType = UIReturnKeyDone;
    //设置输入密码保护
    _LoginPassWordTextField.secureTextEntry = YES;
    //设置键盘外观
    _LoginPassWordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    _LoginPassWordTextField.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 2 + LoginView_LabelHeight_Distance + LoginView_TextFieldHeight_Distance * 1, LoginView_Label_Field_Width, LoginView_Label_Field_Height);
    [self.view addSubview:_LoginPassWordTextField];
    
    
    
    /*验证码输入框*/
    _CaptchaImageTextField = [[UITextField alloc]init];
    _CaptchaImageTextField.delegate = self;
    _CaptchaImageTextField.placeholder = @"验证码";
    _CaptchaImageTextField.textColor = [UIColor blackColor];
    _CaptchaImageTextField.backgroundColor = UILOGINVIEWLABELCOLOR;
    _CaptchaImageTextField.borderStyle = UITextBorderStyleRoundedRect;
    _CaptchaImageTextField.textAlignment = NSTextAlignmentLeft;
    _CaptchaImageTextField.font = [UIFont systemFontOfSize:18];
    //设置输入框右侧一次性清除小叉的按钮
    _CaptchaImageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置自动纠错
    _CaptchaImageTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置再次编辑时输入框为空
    _CaptchaImageTextField.clearsOnBeginEditing = NO;
    //设置内容垂直对齐方式
    _CaptchaImageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //设置内容自适应输入框大小
    _CaptchaImageTextField.adjustsFontSizeToFitWidth = YES;
    //设置键盘样式(方便Email输入）
    _CaptchaImageTextField.keyboardType = UIKeyboardAppearanceDefault;
    //设置首字母是否大写
    _CaptchaImageTextField.autocapitalizationType = UITextBorderStyleNone;
    //设置Return键字样
    _CaptchaImageTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘外观
    _CaptchaImageTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    _CaptchaImageTextField.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 3 + LoginView_LabelHeight_Distance + LoginView_TextFieldHeight_Distance * 2, LoginView_Captcha_Width, LoginView_Captcha_Height);
    [self.view addSubview:_CaptchaImageTextField];
    
    /*验证码图片*/
    _CaptchaImageView = [[UIImageView alloc]init];
    _CaptchaImageView.layer.masksToBounds = YES;
    _CaptchaImageView.layer.cornerRadius = 10;
    _CaptchaImageView.backgroundColor = UILOGINVIEWLABELCOLOR;
    _CaptchaImageView.userInteractionEnabled = YES;
    _CaptchaImageView.frame = CGRectMake(LoginView_Origin_Xpoint + LoginView_Captcha_Width + LoginView_CaptchaImageWidth_Distance, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 3 + LoginView_LabelHeight_Distance + LoginView_TextFieldHeight_Distance * 2 , LoginView_CaptchaImageView_Width, LoginView_CaptchaImageView_Height);
    [self.view addSubview:_CaptchaImageView];
    
    
    /*登录Button*/
    _LoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_LoginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [_LoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    _LoginButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [_LoginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    _LoginButton.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 4 + LoginView_LabelHeight_Distance + LoginView_TextFieldHeight_Distance * 2 + LoginView_ButtonHeight_Distance * 1, LoginView_Button_Width, LoginView_Button_Heigth);
    [self.view addSubview:_LoginButton];
    
    /*登出Button*/
    _CancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _CancelButton.backgroundColor = UILOGINVIEWLABELCOLOR;
    [_CancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [_CancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_CancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    _CancelButton.frame = CGRectMake(LoginView_Origin_Xpoint, LoginView_Origin_Ypoint + LoginView_Label_Field_Height * 5 + LoginView_LabelHeight_Distance + LoginView_TextFieldHeight_Distance * 2 + LoginView_ButtonHeight_Distance * 1.5, LoginView_Button_Width, LoginView_Button_Heigth);
    [self.view addSubview:_CancelButton];
    
    //添加验证码点击更新事件
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoadCaptchaImage)];
    [singleTap setNumberOfTapsRequired:1];
    [_CaptchaImageView addGestureRecognizer:singleTap];
    
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
    [_CaptchaImageView setImageWithURL:[NSURL URLWithString:captchaImageURL] placeholderImage:nil];
}



-(void)LoadCaptchaImage
{
    [doubanServer DoubanLoadCaptchaImage];
}



-(void)Login
{
    loginInfo = [[LoginInfo alloc]init];
    loginInfo.LoginName = _LoginNameTextField.text;
    loginInfo.PassWord = _LoginPassWordTextField.text;
    loginInfo.CapthchaInputWord = _CaptchaImageTextField.text;
    [doubanServer DoubanLoginWithLoginInfo:loginInfo];
}


-(void)Cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_LoginNameTextField resignFirstResponder];
    [_LoginPassWordTextField resignFirstResponder];
    [_CaptchaImageTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
