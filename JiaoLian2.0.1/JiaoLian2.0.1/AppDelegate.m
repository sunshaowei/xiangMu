//
//  AppDelegate.m
//  JiaoLian2.0.1
//
//  Created by 孙少伟 on 15/11/24.
//  Copyright © 2015年 sunshaowei. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import "PersonalCenterViewController.h"
#import "APService.h"
#import "SystemMessageViewController.h"
#import "MD5.h"
#import "UTF8Two.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
   

    
    [SMSSDK registerApp:@"c37951d81fa6" withSecret:@"1a18d7214b351a1d126181ee82b7c897"];

    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //从NSUserDefaults中获得教练的几种状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:@"2" forKey:SHENGHE_SATAE];

    //如果已经登陆过就显示已经登陆过的页面
    if ([userDefaults boolForKey:LOING_SATAE]) {
        
        NSString*shengHeState=[userDefaults objectForKey:SHENGHE_SATAE];
        if ([shengHeState isEqualToString:@"2"]){
            UIStoryboard *MainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController*MainSbNc = [MainSb instantiateViewControllerWithIdentifier:@"Main"];
            self.window.rootViewController=MainSbNc;
        }else{
            NSURL *url = [NSURL URLWithString:SHENGHE_STATE_URL];
            NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod=@"POST";
            //        NSString*dddd=[MD5 stringToMD5Str:@"/rest/native/coach/ol/findOwnerInfo1118f52c5936f7d02f0ba97d8d9a334526c6"];
            //    NSString*password=[MD5 stringToMD5Str:@"123456"];
            NSString*userid =[userDefaults objectForKey:USER_ID];
            NSString*token=[userDefaults objectForKey:TOKEN];
            NSString*sign=[MD5 stringToMD5Str:[NSString stringWithFormat:@"/rest/native/coach/ol/selectCoachSta%@%@",userid,token]];
            NSString * postString =[NSString stringWithFormat:@"id=%@&sign=%@",userid,sign];
           postString=[UTF8Two stringToUTF8Str:postString];
            NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
            request.HTTPBody=postData;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"申核详情=========%@",weatherDic);

            NSDictionary*beanDic=[weatherDic objectForKey:@"bean"];
            NSString*state=[beanDic objectForKey:@"status"];
            if ([state isEqualToString:@"2"]) {
                UIStoryboard *MainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController*MainSbNc = [MainSb instantiateViewControllerWithIdentifier:@"Main"];
                self.window.rootViewController=MainSbNc;
            }else{
                
                
                
                /*
                 申核状态
                 */
                
                [userDefaults setObject:state forKey:SHENGHE_SATAE];
//                [userDefaults setObject:@"0" forKey:SHENGHE_SATAE];
                //资质认证
                PersonalCenterViewController*ziZhiVc=[[PersonalCenterViewController alloc] init];
                UINavigationController*ziZhiNc=[[UINavigationController alloc] initWithRootViewController:ziZhiVc];
                self.window.rootViewController=ziZhiNc;
            }
        }
    }else{
    //如果没有登陆就显示登陆界面
    UIStoryboard *LoginAndRegisterSb = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    UINavigationController*LoginAndRegisterNc = [LoginAndRegisterSb instantiateViewControllerWithIdentifier:@"LogiRegister"];
    self.window.rootViewController=LoginAndRegisterNc;
    }
    [self.window makeKeyAndVisible];
#pragma ----------------------推送－－－－－－－－－－－－－－－－－
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    //给服务器传token
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"=====%s=====%d",__FUNCTION__,__LINE__);
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

//iOS7后调用点击通知触发的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString*infoState= [userInfo objectForKey:@"key"];
    if ([infoState isEqualToString:@"1"]) {
//        NSLog(@"========学员列表");
    }
//    else if ([infoState isEqualToString:@"2"]){
//        NSLog(@"========审核通过");
//
//    }
    else if ([infoState isEqualToString:@"3"]){
//        NSLog(@"========审核未通过");
        //资质认证
        PersonalCenterViewController*ziZhiVc=[[PersonalCenterViewController alloc] init];
        UINavigationController*ziZhiNc=[[UINavigationController alloc] initWithRootViewController:ziZhiVc];
        self.window.rootViewController=ziZhiNc;


    }else if ([infoState isEqualToString:@"4"]){
//        NSLog(@"========消息列表");
    }
    
//    NSLog(@"dele=========%@",userInfo);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserProfileSuccess" object:self userInfo:userInfo];
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.\
    
      [UIApplication sharedApplication].applicationIconBadgeNumber = 0;


}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
