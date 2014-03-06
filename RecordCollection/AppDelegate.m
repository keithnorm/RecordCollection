//
//  AppDelegate.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "ICSDrawerController.h"
#import "CoreDataHelper.h"
#import "User.h"
#import "Album.h"
#import "Album+BusinessLogic.h"
#import "NSManagedObject+Helper.h"
#import "NSTimer+Blocks.h"
#import "ViewController.h"
#import "MenuViewController.h"
#import "Theme.h"
#import "PlayQueue.h"
#import "PlaybackManager.h"
#include "appkey.c"

#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate() <SPSessionDelegate>

@property (nonatomic, strong) ICSDrawerController *drawer;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"7b4f16d17c36f90270ae068e9040a5ee898b7ed9"];
    [Theme setup];
    NSError *error = nil;
    NSData *key = [[NSData alloc] initWithBytes:g_appkey length:g_appkey_size];
    if (![SPSession initializeSharedSessionWithApplicationKey:key userAgent:@"com.app.RecordCollection" error:&error]) {
        NSLog(@"Failed to create session: %@", error.description);
        abort();
    }
    [[SPSession sharedSession] setDelegate:self];
    
    self.drawer = (ICSDrawerController *)self.window.rootViewController;
    
    UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *menu = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *main = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
    self.drawer.leftViewController = menu;
    self.drawer.centerViewController = main;
    
    UIView *player = [[[NSBundle mainBundle] loadNibNamed:@"Player" owner:nil options:nil] objectAtIndex:0];
    player.translatesAutoresizingMaskIntoConstraints = NO;
    [main.view addSubview:player];
    [main.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[player]|" options:0 metrics:nil views:@{@"player": player}]];
    [main.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[player]|" options:0 metrics:nil views:@{@"player": player}]];
    self.window.tintColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[CoreDataHelper sharedHelper] iCloudAccountIsSignedIn];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    __block UIBackgroundTaskIdentifier identifier = [application   beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
    
    [[SPSession sharedSession] flushCaches:^{
        NSLog(@"Flush Cache");
        
        if (identifier != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
    __block UIBackgroundTaskIdentifier identifier = [application   beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
    
    [[SPSession sharedSession] flushCaches:^{
        NSLog(@"Flush Cache");
        
        if (identifier != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
}

- (void)session:(SPSession *)session didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {
    User *user = [User findFirstWithDict:@{@"userName": userName}];
    if (!user) {
        user = [User new];
        user.userName = userName;
        user.credentials = credential;
        [[CoreDataHelper sharedHelper] saveContext];
    }
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession {

}

- (void)didAddAlbumToCollection:(SPAlbum *)album {
    Album *alreadyAdded = [Album findFirstWithDict:@{@"spotifyUrl": album.spotifyURL}];
    if (alreadyAdded) {
        NSLog(@"already added");
        return;
    }
    
    Album *albumObj = [Album new];
    albumObj.name = album.name;
    albumObj.spotifyUrl = album.spotifyURL;
    albumObj.cover = album.cover.image;
    albumObj.artistName = album.artist.name;
    User *user = [User first];
    
    [user addAlbumsObject:albumObj];
    [[CoreDataHelper sharedHelper] saveContext];
    
    [[[SPSession sharedSession] userPlaylists] createPlaylistWithName:[albumObj playlistName] callback:^(SPPlaylist *createdPlaylist) {
        __block SPPlaylist *weakPlaylist = createdPlaylist;
        SPAlbumBrowse *browse = [SPAlbumBrowse browseAlbum:album inSession:[SPSession sharedSession]];
        [SPAsyncLoading waitUntilLoaded:browse timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            weakPlaylist = createdPlaylist;
            [createdPlaylist addItems:browse.tracks atIndex:0 callback:^(NSError *error) {
                [SPAsyncLoading waitUntilLoaded:weakPlaylist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                    weakPlaylist.markedForOfflinePlayback = YES;
                }];
                
            }];
        }];
    }];
    
    [self.drawer peak];
    UIImage *cover = album.cover.image;
    UIImageView *coverView = [[UIImageView alloc] initWithImage:cover];
    coverView.frame = CGRectMake(150, 44, cover.size.width, cover.size.height);
    MenuViewController *menu = (MenuViewController *)self.drawer.leftViewController;
    [NSTimer scheduledTimerWithTimeInterval:0.3 block:^{
        [self.window addSubview:coverView];
        UITableViewCell *myCollectionCell = [menu.navigationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGRect destination = CGRectOffset(myCollectionCell.frame, 0, menu.navigationTable.frame.origin.y);
        
        coverView.alpha = 1.0f;
        CGRect imageFrame = coverView.frame;
        //Your image frame.origin from where the animation need to get start
        CGPoint viewOrigin = coverView.frame.origin;
        viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
        viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
        
        // Set up fade out effect
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
        fadeOutAnimation.fillMode = kCAFillModeForwards;
        fadeOutAnimation.removedOnCompletion = NO;
        
        // Set up scaling
        CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
        [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / imageFrame.size.width))]];
        resizeAnimation.fillMode = kCAFillModeForwards;
        resizeAnimation.removedOnCompletion = NO;
        
        // Set up path movement
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        //Setting Endpoint of the animation
        CGPoint endPoint = CGPointMake(destination.origin.x, destination.origin.y);
        //to end animation in last tab use
        //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGPathMoveToPoint(curvedPath, NULL, coverView.center.x, coverView.center.y);
        CGPathAddCurveToPoint(curvedPath, NULL, 320, -20, 100, 0, endPoint.x + 50, endPoint.y + 25);
        pathAnimation.path = curvedPath;
        CGPathRelease(curvedPath);
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
        group.duration = 0.7f;
        group.delegate = self;
        [group setValue:@"groupAnimation" forKey:@"animationName"];
        [group setValue:coverView forKey:@"imageViewBeingAnimated"];
        [group setValue:myCollectionCell forKey:@"destinationView"];
        
        [coverView.layer addAnimation:group forKey:@"savingAnimation"];
        
    } repeats:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"changed %@", keyPath);
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    if (finished) {
        NSString *animationName = [animation valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"groupAnimation"]) {
            UIImageView *imageView = [animation valueForKey:@"imageViewBeingAnimated"];
            [imageView removeFromSuperview];
            UITableViewCell *cell = [animation valueForKey:@"destinationView"];
            cell.highlighted = YES;
            cell.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
                cell.highlighted = NO;
                cell.selected = NO;
                [self.drawer close];
            }];
        }
    }
}

- (void)userDidSelectPlayNext:(id)sender {
//    [self playNext];
    [[PlaybackManager sharedManager] playNext];
}

- (void)userDidSeek:(NSNumber *)position {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    [playbackManager seekToTrackPosition:[position floatValue]];
}

- (void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage {
    NSLog(@"CocoaLS DEBUG: %@", aMessage);
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [[SPSession sharedSession] setPlaying:NO];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [[SPSession sharedSession] setPlaying:YES];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[PlaybackManager sharedManager] playPrev];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [[PlaybackManager sharedManager] playNext];
                break;
                
            default:
                break;
        }
    }
}

@end
