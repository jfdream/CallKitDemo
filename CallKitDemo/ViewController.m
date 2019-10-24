//
//  ViewController.m
//  CallKitDemo
//
//  Created by jfdreamyang on 2019/9/29.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "ViewController.h"
#import "RCFetchTokenManager.h"
#import <RongIMLib/RongIMLib.h>
#import <RongCallKit/RongCallKit.h>

@interface ViewController ()<RCCallSessionDelegate>
{
    NSString *userId1;
    NSString *userId2;
    
    NSInteger someone;
    BOOL isAudio;
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [RCCall sharedRCCall];
    
    userId1 = @"dashouji";
    userId2 = @"xiaoshouji";
    
}
-(void)session:(RCCallSession *)session{
    [[RCCall sharedRCCall].currentCallSession addDelegate:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDarkContent;
}

- (IBAction)connect1:(id)sender {
    if (someone > 0) {
        return;
    }
    
    self.statusLabel.text = @"connected 1";
    
    someone = 1;
    
    NSString *token1 = [[NSUserDefaults standardUserDefaults] objectForKey:userId1];
    if (!token1) {
        [[RCFetchTokenManager sharedManager] fetchTokenWithUserId:userId1 username:@"" portraitUri:@"" completion:^(BOOL isSucccess, NSString * _Nullable token) {
            if (token.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:userId1];
                [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
                    
                } error:^(RCConnectErrorCode status) {
                    
                } tokenIncorrect:^{
                    
                }];
            }
        }];
    }
    else{
        [[RCIMClient sharedRCIMClient] connectWithToken:token1 success:^(NSString *userId) {
            
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }
    
}



- (IBAction)connect2:(id)sender {
    
    if (someone > 0) {
        return;
    }
    
    self.statusLabel.text = @"connected 2";
    
    someone = 2;
    
    NSString *token2 = [[NSUserDefaults standardUserDefaults] objectForKey:userId2];
       if (!token2) {
           [[RCFetchTokenManager sharedManager] fetchTokenWithUserId:userId2 username:@"" portraitUri:@"" completion:^(BOOL isSucccess, NSString * _Nullable token) {
               if (token.length > 0) {
                   [[NSUserDefaults standardUserDefaults] setObject:token forKey:userId2];
                   [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
                       
                   } error:^(RCConnectErrorCode status) {
                       
                   } tokenIncorrect:^{
                       
                   }];
               }
           }];
       }
       else{
           [[RCIMClient sharedRCIMClient] connectWithToken:token2 success:^(NSString *userId) {
               
           } error:^(RCConnectErrorCode status) {
               
           } tokenIncorrect:^{
               
           }];
       }
}
- (IBAction)call:(id)sender {
    
    RCCallMediaType type = isAudio ? RCCallMediaAudio : RCCallMediaVideo;
    
    if (someone == 1) {
        [[RCCall sharedRCCall] startSingleCall:userId2 mediaType:type];
    }
    else{
        [[RCCall sharedRCCall] startSingleCall:userId1 mediaType:type];
    }
    
}
- (IBAction)isAudioButtonClick:(UIButton *)sender {
    isAudio = !isAudio;
    if (isAudio) {
        [sender setTitle:@"isAudio" forState:UIControlStateNormal];
    }
    else{
        [sender setTitle:@"isVideo" forState:UIControlStateNormal];
    }
}

@end
