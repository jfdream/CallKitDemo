//
//  AppDelegate.m
//  CallKitDemo
//
//  Created by jfdreamyang on 2019/9/29.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "AppDelegate.h"
#import "RCFetchTokenManager.h"
#import <RongCallLib/RongCallLib.h>
#import <RongIMKit/RongIMKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()
@property (nonatomic,strong)NSTimer *pushTimer;
@property (nonatomic,strong)NSTimer *connectHoldingTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Verbose;
    [[RCIMClient sharedRCIMClient] initWithAppKey:RCIMAPPKey];
    
    [self registerNotification];

    return YES;
}

-(void)registerNotification{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else if([[UIDevice currentDevice].systemVersion floatValue] < 10.0){
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextMinimal)];
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:categorys]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
    }
    else{
        
        UNTextInputNotificationAction *textInputAction = [UNTextInputNotificationAction actionWithIdentifier:@"replymessage" title:@"立即回复" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"发送" textInputPlaceholder:@"聊聊吧……"];
        
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"forbidden" title:@"临时屏蔽" options:UNNotificationActionOptionForeground];
        
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"shutdown" title:@"关闭" options:UNNotificationActionOptionDestructive];
        
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"" actions:@[textInputAction,action1,action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES) {
                NSLog(@"IMApp %@", @"notification center granted");
            }
        }];
    }
#if !TARGET_IPHONE_SIMULATOR
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    uint8_t *bytes = (uint8_t *)deviceToken.bytes;
    NSMutableString *token = @"".mutableCopy;
    for (NSInteger i=0; i<deviceToken.length; i++) {
        [token appendFormat:@"%02x",bytes[i]];
    }
    NSLog(@"IMApp didRegisterDeviceToken %@",token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSLog(@"IMApp %@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
