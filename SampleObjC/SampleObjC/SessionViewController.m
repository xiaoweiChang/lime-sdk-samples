//
//  ViewController.m
//  SampleObjC
//
//  Created by Hale Xie on 2019/11/14.
//  Copyright © 2019 Helplightning. All rights reserved.
//

#import "SessionViewController.h"
//#import <HLSDK.h>
#import <HLSDK/HLSDK.h>
#import "FBLPromises.h"

#define HL_SESSION_ID       (@"c7baa9fc-3a68-415b-a287-1d37741441dd")
#define HL_SESSION_TOKEN    (@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdHRyaWJ1dGVzIjpbIm9yZ2FuaXplciJdLCJhdWQiOiJHaGF6YWwiLCJleHAiOjE2MDczMjExMzIsImlhdCI6MTU3NjU2MjczMiwiaXNzIjoiR2hhemFsIiwianRpIjoiNTkwM2U0OTUtNDBkMC00ZjMyLTg3YjUtMGUzMTU1MTM5YWJkIiwibWV0YSI6e30sIm5iZiI6MTU3NjU2MjczMSwib3JpZ2luYXRvciI6NCwicGVtIjp7InNlc3Npb24iOjI1NTl9LCJyZWNvcmRpbmdfcG9saWN5Ijoib3B0X2luIiwic3ViIjoiU2Vzc2lvbjpjN2JhYTlmYy0zYTY4LTQxNWItYTI4Ny0xZDM3NzQxNDQxZGQiLCJ0eXAiOiJhY2Nlc3MiLCJ2ZXIiOiIxMDAifQ.yDzlI0zpikZu4WpoJF8P57n9D0CSK1TfxlVShAydad8")
#define HL_GSS_URL          (@"gss+ssl://containers-asia.helplightning.net:32773")

#define HL_USER1_TOKEN       (@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJHaGF6YWwiLCJleHAiOjE2MDczMjcwNjUsImlhdCI6MTU3NjU2ODY2NSwiaXNzIjoiR2hhemFsIiwianRpIjoiYWQxOWFmMTUtMjgzZC00N2NlLThmYTEtMjVhNDM1NTEzOThlIiwibWV0YSI6e30sIm5iZiI6MTU3NjU2ODY2NCwicGVtIjp7InVzZXIiOjQ0NzI3OTYxMjg1NDA0NjJ9LCJzdWIiOiJVc2VyOjQiLCJ0eXAiOiJhY2Nlc3MiLCJ2ZXIiOiIxMDAifQ.eAS1IsnV1n-kj0VS-Dk1Ifjpp_580MibHZsf8sJQuBw")
#define HL_USER1_NAME       (@"Small User1")
#define HL_USER1_AVATAR     (@"")

#define HL_USER2_TOKEN       (@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJHaGF6YWwiLCJleHAiOjE2MDczOTg0NjYsImlhdCI6MTU3NjY0MDA2NiwiaXNzIjoiR2hhemFsIiwianRpIjoiMzkxNjUyMzUtMDc2MS00ZThiLWI2NzQtMmUwODA3MDY0ZjVhIiwibWV0YSI6e30sIm5iZiI6MTU3NjY0MDA2NSwicGVtIjp7InVzZXIiOjQ0NzI3OTYxMjg1NDA0NjJ9LCJzdWIiOiJVc2VyOjUiLCJ0eXAiOiJhY2Nlc3MiLCJ2ZXIiOiIxMDAifQ.wMJNnbK5vQGCZdS5KStzxThabyXtyuzeU5k-08ZaGwM")
#define HL_USER2_NAME       (@"Small User2")

#define HL_USER2_AVATAR     (@"")

@interface SessionViewController () <HLClientDelegate, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITextView *sessionId;
@property (weak, nonatomic) IBOutlet UITextView *sessionToken;
@property (weak, nonatomic) IBOutlet UITextView *userToken;
@property (weak, nonatomic) IBOutlet UITextView *userName;
@property (weak, nonatomic) IBOutlet UITextView *userAvatar;
@property (weak, nonatomic) IBOutlet UITextView *gssURL;
@property (weak, nonatomic) IBOutlet UITabBar *userTab;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *joinIndicator;

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sessionId.text = HL_SESSION_ID;
    self.sessionToken.text = HL_SESSION_TOKEN;
    self.userToken.text = HL_USER1_TOKEN;
    self.userName.text = HL_USER1_NAME;
    self.userAvatar.text = HL_USER1_AVATAR;
    self.gssURL.text = HL_GSS_URL;
    [self.userTab setSelectedItem:self.userTab.items.firstObject];
    HLClient.sharedInstance.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (IBAction)cancelCall:(id)sender {
    FBLPromise* promise = [HLClient.sharedInstance stopCurrentCall];
    [promise then:^id(id value) {
        NSLog(@"The call has stopped");
        return value;
    }];
    [promise catch:^(NSError* error) {
        NSLog(@"Cannot stop the call:%@", error);
    }];
}

- (IBAction)joinCall:(id)sender {
    HLCall* call = [[HLCall alloc] initWithSessionId:self.sessionId.text
                                        sessionToken:self.sessionToken.text
                                           userToken:self.userToken.text
                                              gssUrl:self.gssURL.text
                                 helplightningAPIKey:@""
                                localUserDisplayName:self.userName.text
                                  localUserAvatarUrl:self.userAvatar.text];
    
    [self.joinIndicator startAnimating];
    FBLPromise* promise = [HLClient.sharedInstance startCall:call withPresentingViewController:self];
    [promise then:^id(id value) {
        NSLog(@"The call has started");
        return value;
    }];
    [promise catch:^(NSError* error) {
        [self.joinIndicator stopAnimating];
        NSLog(@"Cannot start the call:%@", error);
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [tabBar.items indexOfObject:item];
    if (index) {
        self.userToken.text = HL_USER2_TOKEN;
        self.userName.text = HL_USER2_NAME;
        self.userAvatar.text = HL_USER2_AVATAR;
    } else {
        self.userToken.text = HL_USER1_TOKEN;
        self.userName.text = HL_USER1_NAME;
        self.userAvatar.text = HL_USER1_AVATAR;
    }
}

#pragma mark - HLSDK Delegate

- (void) call:(HLCall*)call didEndWithReason:(NSString*)reason {
    [self.joinIndicator stopAnimating];
    NSLog(@"The call has ended: %@", call.sessionId);
}

@end
