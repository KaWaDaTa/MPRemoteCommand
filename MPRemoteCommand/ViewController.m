//
//  ViewController.m
//  MPRemoteCommand
//
//  Created by appteam on 2017/3/4.
//  Copyright © 2017年 colin.liu. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, strong) MPRemoteCommand * mprcNext, * mprcPlay, * mprcPause, * mprcPrevious;

@property (nonatomic, strong) MPFeedbackCommand * mpfbLike, * mpfbDislike, * mpfbBookMark;
@property (nonatomic) BOOL bookmark;
@end

@implementation ViewController
@synthesize player;
@synthesize mprcNext,mprcPlay,mprcPause,mprcPrevious;
@synthesize mpfbLike,mpfbDislike,mpfbBookMark;
@synthesize bookmark;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"m4a"]] error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [self.player setDelegate:self];
    [self.player prepareToPlay];
    [self.player play];
    [self.player setNumberOfLoops:-1];
    [self.player setVolume:1];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.mprcNext = [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand;
    [self.mprcNext addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mprcNext setEnabled:YES];
    [self.mprcNext addTarget:self action:@selector(nextTrackCommand:)];
    self.mprcPlay = [MPRemoteCommandCenter sharedCommandCenter].playCommand;
    [self.mprcPlay addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mprcPlay setEnabled:YES];
    [self.mprcPlay addTarget:self action:@selector(playCommand:)];
    self.mprcPause = [MPRemoteCommandCenter sharedCommandCenter].pauseCommand;
    [self.mprcPause addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mprcPause setEnabled:YES];
    [self.mprcPause addTarget:self action:@selector(pauseCommand:)];
    
    self.mprcPrevious = [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand;
    [self.mprcPrevious addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mprcPrevious setEnabled:YES];
    [self.mprcPrevious addTarget:self action:@selector(previousTrackCommand:)];
    self.mpfbLike = [MPRemoteCommandCenter sharedCommandCenter].likeCommand;
    [self.mpfbLike addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mpfbLike setEnabled:YES];
    [self.mpfbLike addTarget:self action:@selector(likeCommand:)];
    [self.mpfbLike setLocalizedTitle:@"喜欢这首歌"];
    [self.mpfbLike setLocalizedShortTitle:@"喜欢"];
    
    self.mpfbDislike =[MPRemoteCommandCenter sharedCommandCenter].dislikeCommand;
    [self.mpfbDislike addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mpfbDislike addTarget:self action:@selector(dislikeCommand:)];
    [self.mpfbDislike setEnabled:YES];
    [self.mpfbDislike setLocalizedTitle:@"不喜欢这首歌"];
    [self.mpfbDislike setLocalizedShortTitle:@"不喜欢"];
    
    self.mpfbBookMark = [MPRemoteCommandCenter sharedCommandCenter].bookmarkCommand;
    [self.mpfbBookMark addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [self.mpfbBookMark setEnabled:YES];
    [self.mpfbBookMark addTarget:self action:@selector(bookmarkCommand:)];
    [self.mpfbBookMark setLocalizedTitle:@"书签"];
    [self.mpfbBookMark setLocalizedShortTitle:@"书签"];
    self.bookmark = NO;
}

- (void)bookmarkCommand:(MPFeedbackCommandEvent *)sender
{
    self.bookmark = !self.bookmark;
    NSLog(@"Bookmark");
}

- (void)dislikeCommand:(MPFeedbackCommandEvent *)sender
{
    [self.mpfbDislike setEnabled:NO];
    [self.mpfbLike setEnabled:YES];
    NSLog(@"Dislike");
}

- (void)likeCommand:(MPFeedbackCommandEvent *)sender
{
    [self.mpfbLike setEnabled:NO];
    [self.mpfbDislike setEnabled:YES];
    NSLog(@"Like");
}

- (void)previousTrackCommand:(MPRemoteCommandEvent *)sender
{
    NSLog(@"Previous Track");
}

- (void)playCommand:(MPRemoteCommandEvent *)sender
{
    NSLog(@"Play in MPRemoteCommandEvent");
}

- (void)pauseCommand:(MPRemoteCommandEvent *)sender
{
    NSLog(@"Pause in MPRemoteCommandEvent");
}

- (void)nextTrackCommand:(MPRemoteCommandEvent *)sender
{
    NSLog(@"Next Track");
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            NSLog(@"Play in RemoteControlEvent");
            break;
        case UIEventSubtypeRemoteControlPause:
            NSLog(@"Pause in RemoteControlEvent");
            break;
        default:
            break;
    }
}

@end
