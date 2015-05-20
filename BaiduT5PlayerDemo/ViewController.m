//
//  ViewController.m
//  BaiduT5PlayerDemo
//
//  Created by CuppiZhangTF on 15/5/18.
//  Copyright (c) 2015年 cuppi. All rights reserved.
//
#define __kMovieUrl1 [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"IcerEnglish.mp4"]
#define __kMovieUrl2 [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"IcerJapanese.mp4"]

//#define __kMovieUrl @"http://bcs.duapp.com/videotest123567/media/%5B%E9%AC%BC%E6%89%93%E9%AC%BC.%E8%8A%B1%E7%B5%AE%5D.Ghost.Against.Ghost.1980.Extras.HALFCD-NORM.mkv"
#import "ViewController.h"

@interface ViewController ()
{
    CyberPlayerController *_cpViewController;
    MBProgressHUD *_mbProgressHUD;
    BOOL _changeSharpness;
    NSTimeInterval _breakPointTime;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
     1
     CBP_EXTERN NSString * const CyberPlayerLoadDidPreparedNotification;
     2
     CBP_EXTERN NSString * const CyberPlayerPlaybackDidFinishNotification;
     3
     CBP_EXTERN NSString * const CyberPlayerStartCachingNotification;
     4
     CBP_EXTERN NSString * const CyberPlayerGotCachePercentNotification;
     5
     CBP_EXTERN NSString * const CyberPlayerPlaybackErrorNotification;
     6
     CBP_EXTERN NSString * const CyberPlayerSeekingDidFinishNotification;
     7
     CBP_EXTERN NSString * const CyberPlayerPlaybackStateDidChangeNotification;
     8
     CBP_EXTERN NSString * const CyberPlayerMeidaTypeAudioOnlyNotification;
     9
     CBP_EXTERN NSString * const CyberPlayerGotNetworkBitrateNotification;
     
     */
    //  1
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerLoadDidPreparedNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     
                                                     NSLog(@"准备完成");
                                                 }];
    //  2
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerPlaybackDidFinishNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 2 ************  CyberPlayerPlaybackDidFinishNotification");
                                                     if(_changeSharpness)
                                                     {
                                                         [_cpViewController start];
                                                         [_cpViewController seekTo:_breakPointTime];
                                                         _breakPointTime = 0;
                                                         _changeSharpness = NO;
                                                     }
                                                     
                                                 }];
    //  3
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerStartCachingNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                 }];
    //  4
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerGotCachePercentNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 4 ************  CyberPlayerGotCachePercentNotification");
                                                     if([note.object intValue] == 100)
                                                     {
                                                         [_mbProgressHUD hide:YES];
                                                     }
                                                     else
                                                     {
                                                         [_mbProgressHUD show:YES];
                                                     }
                                                 }];
    //  5
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerPlaybackErrorNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     [_mbProgressHUD show:NO];
                                                 }];
    //  6
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerSeekingDidFinishNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 6 ************  CyberPlayerSeekingDidFinishNotification");
                                                     
                                                 }];
    
    //  7
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerPlaybackStateDidChangeNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"状态改变");
                                                 }];
    //  8
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerMeidaTypeAudioOnlyNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 8 ************  CyberPlayerMeidaTypeAudioOnlyNotification");
                                                 }];
    
    //  9
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerGotNetworkBitrateNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 9 ************  CyberPlayerGotNetworkBitrateNotification");
                                                 }];
    [self createMetadata];
    [self createViewController];
    [self createMBProgressHUD];
    [self createButton];
}

- (void)createMetadata
{
    _breakPointTime = 0;
    _changeSharpness = NO;
}

/**
 *  创建播放控制器
 */
- (void)createViewController
{
    NSString* msAK=@"TwthXSKCmkGbR9DbYUriGmT7";
    NSString* msSK=@"irre7k4rzRjGqPnM";
    //添加开发者信息
    [[CyberPlayerController class ]setBAEAPIKey:msAK SecretKey:msSK ];
    _cpViewController = [[CyberPlayerController alloc]initWithContentString:__kMovieUrl2];
    [self.view addSubview:_cpViewController.view];
    [_cpViewController.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionRight)]];
    _cpViewController.view.frame = CGRectMake(0, 0, 568, 320);
}

- (void)createMBProgressHUD
{
    _mbProgressHUD = [[MBProgressHUD alloc]initWithView:_cpViewController.view];
    [self.view addSubview:_mbProgressHUD];
}

/**
 *  创建按钮
 */
- (void)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(200, 280, 100, 40);
    [button addTarget:self action:@selector(actionStartPlay:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"开始播放" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor yellowColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- action area

- (void)actionStartPlay:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [_cpViewController start];
    [UIView animateWithDuration:1.5
                     animations:^{
                         button.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                         {
                             button.hidden = YES;
                         }
                     }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    
    //
    //    self.internetReachability = [Reachability reachabilityForInternetConnection];
    //    [self.internetReachability startNotifier];
    //
    //    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    //    [self.wifiReachability startNotifier];
    //
    
    
}

- (void)actionRight
{
    NSLog(@"点击了屏幕");
    if(_cpViewController.isPreparedToPlay)
    {
        [_cpViewController seekTo:_cpViewController.currentPlaybackTime + 15];
    }
    else
    {
        NSLog(@"------------------  还没有准备号");
    }
    
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if(reachability == self.hostReachability)
    {
        //     NSLog(@"hostReachability");
        [self printState:reachability];
    }
    //    if(reachability == self.internetReachability)
    //    {
    //        NSLog(@"internetReachability");
    //        [self printState:reachability];
    //    }
    //    if(reachability == self.wifiReachability)
    //    {
    //        NSLog(@"wifiReachability");
    //        [self printState:reachability];
    //    }
    
}

- (void)printState:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    //  BOOL connectionRequired = [reachability connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:        {
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            NSLog(@"NotReachable");
            break;
        }
            
        case ReachableViaWWAN:        {
            _breakPointTime = _cpViewController.currentPlaybackTime;
            [_cpViewController stop];
            _changeSharpness = YES;
            [_cpViewController setContentString:__kMovieUrl1];
            break;
        }
        case ReachableViaWiFi:        {
            _breakPointTime = _cpViewController.currentPlaybackTime;
            [_cpViewController stop];
            _changeSharpness = YES;
            [_cpViewController setContentString:__kMovieUrl2];
            break;
        }
    }
    
}
@end
