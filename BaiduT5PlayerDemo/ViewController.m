//
//  ViewController.m
//  BaiduT5PlayerDemo
//
//  Created by CuppiZhangTF on 15/5/18.
//  Copyright (c) 2015年 cuppi. All rights reserved.
//


#define __kNotifyPanGestureRecognizerStateChange @"__kNotifyPanGestureRecognizerStateChange"
#define __kMovieUrl1 [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"IcerEnglish.mp4"]
#define __kMovieUrl2 [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"IcerJapanese.mp4"]

//#define __kMovieUrl @"http://bcs.duapp.com/videotest123567/media/%5B%E9%AC%BC%E6%89%93%E9%AC%BC.%E8%8A%B1%E7%B5%AE%5D.Ghost.Against.Ghost.1980.Extras.HALFCD-NORM.mkv"
#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
{
    CyberPlayerController *_cpViewController;
    MBProgressHUD *_mbProgressHUD;
    BOOL _isPlaying;
    BOOL _isChangeSharpness;
    BOOL _isPostPlayTimePointNotifier;
    BOOL _isSliderEditing;
    NSTimeInterval _breakPointTime;
    NSTimer *_playerTimer;
    
    UIView *_progressPlaceHolderView;
    UILabel *_progressPlaceHolderLabel;
    UIView *_oprationView;
    UISlider *_playerSlider;
    UIButton *_playButton;
    
    UIPanGestureRecognizer *_oprationViewPanGesture;
    
    NSTimeInterval _panGestureStartTime;
    CGPoint _panGestureStartPoint;
}
@end

@implementation ViewController

- (void)dealloc
{
    [_oprationViewPanGesture removeObserver:self forKeyPath:@"state"];
}

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
                                                     [_cpViewController seekTo:_breakPointTime];
                                                 }];
    //  2
    [[NSNotificationCenter defaultCenter]addObserverForName:CyberPlayerPlaybackDidFinishNotification
                                                     object:_cpViewController
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     NSLog(@"** 2 ************  CyberPlayerPlaybackDidFinishNotification");
                                                     if(_isChangeSharpness)
                                                     {
                                                         [_cpViewController start];
                                                         [_cpViewController seekTo:_breakPointTime];
                                                         _breakPointTime = 0;
                                                         _isChangeSharpness = NO;
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
    [self createOprationView];
    [self createMBProgressHUD];
    [self createPlaceHolder];
    
    [self createReachabilityObserver];
    [self startPostPlayTimePointNotifier];
}

- (void)createMetadata
{
    _breakPointTime = 0;
    _isPlaying = NO;
    _isChangeSharpness = NO;
    _isPostPlayTimePointNotifier = NO;
    _isSliderEditing = NO;
    _panGestureStartTime = 0;
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(actionUpdateProgressBar)
                                                  userInfo:nil
                                                   repeats:YES];
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/**
 *  创建拖拽滑动条时,屏幕中间显示的view
 */
- (void)createPlaceHolder
{
    _progressPlaceHolderView = [[UILabel alloc]init];
    [self.view addSubview:_progressPlaceHolderView];
    _progressPlaceHolderView.center = self.view.center;
    _progressPlaceHolderView.bounds = CGRectMake(0, 0, 150, 70);
    _progressPlaceHolderView.hidden = YES;
    _progressPlaceHolderView.layer.cornerRadius = 5;
    _progressPlaceHolderView.layer.masksToBounds = YES;
    _progressPlaceHolderView.layer.backgroundColor = [UIColor blackColor].CGColor;
    _progressPlaceHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                         CGHeight(_progressPlaceHolderView.frame) - 20,
                                                                         CGWidth(_progressPlaceHolderView.frame),
                                                                         20)];
    [_progressPlaceHolderView addSubview:_progressPlaceHolderLabel];
    _progressPlaceHolderLabel.font = [UIFont boldSystemFontOfSize:14];
    _progressPlaceHolderLabel.textAlignment = NSTextAlignmentCenter;
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
    _cpViewController.view.frame = CGRectMake(0, 20, 568, 300);
}

/**
 *  创建操作的View
 */
- (void)createOprationView
{
    _oprationView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_oprationView];
    _oprationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    //[_oprationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTouchOprationView)]];
    _oprationViewPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanOprationView:)];
    _oprationViewPanGesture.delegate = self;
    [_oprationViewPanGesture addObserver:self
                              forKeyPath:@"state"
                                 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                 context:__kNotifyPanGestureRecognizerStateChange];
    [_oprationView addGestureRecognizer:_oprationViewPanGesture];
    [self createButton];
    [self createPlayerProgressBar];
}

/**
 *  创建按钮
 */
- (void)createButton
{
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_oprationView addSubview:_playButton];
    _playButton.frame = CGRectMake(__kDScreenWidth - 100, __kDScreenHeight - 40, 100, 40);
    [_playButton addTarget:self action:@selector(actionStartPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setTitle:@"开始播放" forState:UIControlStateNormal];
    [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton setBackgroundColor:[UIColor yellowColor]];
}

/**
 *  创建播放进度条
 */
- (void)createPlayerProgressBar
{
    _playerSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, __kDScreenHeight - 40, __kDScreenWidth - 100, 20)];
    [_oprationView addSubview:_playerSlider];
    _playerSlider.backgroundColor = [UIColor orangeColor];
    [_playerSlider addTarget:self action:@selector(actionProgressBarEndDraged) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [_playerSlider addTarget:self action:@selector(actionProgressBarDraging) forControlEvents:UIControlEventValueChanged];
    [_playerSlider addTarget:self action:@selector(actionProgressBarBeganDraged) forControlEvents:UIControlEventTouchDown];
}

/**
 *  创建加载框
 */
- (void)createMBProgressHUD
{
    _mbProgressHUD = [[MBProgressHUD alloc]initWithView:_cpViewController.view];
    [self.view addSubview:_mbProgressHUD];
}


/**
 *  创建网络连接状态对象
 */
- (void)createReachabilityObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- action area
- (void)actionStartPlay:(id)sender
{
    if(_isPlaying)
    {
        [_cpViewController pause];
        _breakPointTime = _cpViewController.currentPlaybackTime;
        [_playButton setTitle:@"开始播放" forState:UIControlStateNormal];
        _isPlaying = NO;
    }
    else
    {
        [_cpViewController start];
        [_playButton setTitle:@"暂停播放" forState:UIControlStateNormal];
        _isPlaying = YES;
    }
}

- (void)actionTouchOprationView
{
    return;
}

- (void)actionPanOprationView:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    if(_isPlaying)
    {
        CGFloat x_offset = point.x - _panGestureStartPoint.x;
        //  NSLog(@"-------- %f", x_offset);
    }
}

- (void)actionUpdateProgressBar
{
    if(!_isSliderEditing)
    {
        _playerSlider.value = _cpViewController.currentPlaybackTime/_cpViewController.infoDuration;
        [self setPlaceHolderLabelCurrentTime:_cpViewController.currentPlaybackTime andAllTime:_cpViewController.infoDuration];
    }
}

/**
 *  拖动播放的滑动条
 */
- (void)actionProgressBarBeganDraged
{
    [self showPlaceHolder];
    _isSliderEditing = YES;
}

- (void)actionProgressBarDraging
{
    [self setPlaceHolderLabelCurrentTime:_cpViewController.infoDuration*_playerSlider.value andAllTime:_cpViewController.infoDuration];
}

- (void)actionProgressBarEndDraged
{
    [self hiddenPlaceHolder];
    _isSliderEditing = NO;
    [_cpViewController seekTo:_cpViewController.infoDuration*_playerSlider.value];
}





#pragma mark -- method
- (void)startPostPlayTimePointNotifier
{
    _isPostPlayTimePointNotifier = YES;
    [_playerTimer setFireDate:[NSDate distantPast]];
}

- (void)stopPostPlayTimePointNotifier
{
    [_playerTimer setFireDate:[NSDate distantFuture]];
    _isPostPlayTimePointNotifier = NO;
}

- (void)showPlaceHolder
{
    _progressPlaceHolderView.hidden = NO;
}

- (void)hiddenPlaceHolder
{
    _progressPlaceHolderView.hidden = YES;
}

- (void)setPlaceHolderLabelCurrentTime:(NSTimeInterval)currentTime andAllTime:(NSTimeInterval)allTime
{
    
    NSString *currentString = [[CPDateManager defaultManager]hh_mm_ssFromIntegerSeconds:floor(currentTime)];
    NSString *allString = [[CPDateManager defaultManager]hh_mm_ssFromIntegerSeconds:floor(allTime)];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:currentString
                                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@",allString] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    _progressPlaceHolderLabel.attributedText = attrString;
}

#pragma mark -- Reachability method
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
        [self handleState:reachability];
    }
}

- (void)handleState:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"NotReachable");
            [[[UIAlertView alloc]initWithTitle:@"当前没有网络"
                                       message:@"请稍后重试"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil] show];
            break;
        }
            
        case ReachableViaWWAN:
        {
            if([reachability connectionRequired])
            {
                NSLog(@"当前是2.5G");
                _breakPointTime = _cpViewController.currentPlaybackTime;
                [_cpViewController stop];
                _isChangeSharpness = YES;
                [_cpViewController setContentString:__kMovieUrl1];
            }
            else
            {
                NSLog(@"当前是3G");
                _breakPointTime = _cpViewController.currentPlaybackTime;
                [_cpViewController stop];
                _isChangeSharpness = YES;
                [_cpViewController setContentString:__kMovieUrl2];
            }
            
            break;
        }
            
        case ReachableViaWiFi:
        {
            _breakPointTime = _cpViewController.currentPlaybackTime;
            [_cpViewController stop];
            _isChangeSharpness = YES;
            [_cpViewController setContentString:__kMovieUrl2];
            break;
        }
    }
}

#pragma mark -- Gesture delegate


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == _oprationViewPanGesture && _isPlaying)
    {
        _panGestureStartTime = _cpViewController.currentPlaybackTime;
        _panGestureStartPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    }
    return YES;
}

#pragma mark -- KVO method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == __kNotifyPanGestureRecognizerStateChange)
    {
        UIGestureRecognizerState state = [[change valueForKey:NSKeyValueChangeKindKey]integerValue];
        state == UIGestureRecognizerStatePossible? NSLog(@"------------ UIGestureRecognizerStatePossible"):@"s";
        state == UIGestureRecognizerStateBegan? NSLog(@"------------ UIGestureRecognizerStateBegan"):@"s";
        state == UIGestureRecognizerStateChanged? NSLog(@"------------ UIGestureRecognizerStateChanged"):@"s";
        state == UIGestureRecognizerStateEnded? NSLog(@"------------ UIGestureRecognizerStateEnded"):@"s";
        state == UIGestureRecognizerStateCancelled? NSLog(@"------------ UIGestureRecognizerStateCancelled"):@"s";
        state == UIGestureRecognizerStateFailed? NSLog(@"------------ UIGestureRecognizerStateFailed"):@"s";
        state == UIGestureRecognizerStateRecognized? NSLog(@"------------ UIGestureRecognizerStateRecognized"):@"s";
        
    }
}
@end
