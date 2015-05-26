//
//  ViewController.h
//  BaiduT5PlayerDemo
//
//  Created by CuppiZhangTF on 15/5/18.
//  Copyright (c) 2015年 cuppi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CyberPlayerController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "CPDateManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController : UIViewController
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@end

