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

#import <CocoaLibSpotify/CocoaLibSpotify.h>

NSString * const kMBUserAgent = @"com.example.musiccollection";

const uint8_t g_appkey[] = {
	0x01, 0x56, 0xFC, 0x14, 0x35, 0x86, 0x20, 0xF1, 0x69, 0xC6, 0x9B, 0x7C, 0xD3, 0x11, 0xAB, 0x56,
	0x3E, 0x1F, 0xF3, 0xB1, 0x58, 0xD4, 0x07, 0xF3, 0x51, 0xCF, 0xC1, 0x1D, 0xF8, 0xCF, 0x49, 0x73,
	0x9F, 0xFC, 0x66, 0x02, 0xA1, 0xCE, 0x82, 0x08, 0xBE, 0xF3, 0x89, 0xAA, 0xBD, 0x75, 0x42, 0x19,
	0x60, 0x45, 0xBF, 0x39, 0x70, 0x8C, 0x6E, 0xA9, 0x37, 0xE1, 0x5B, 0x54, 0xD9, 0x29, 0x1D, 0xEE,
	0xBF, 0x2B, 0x11, 0xD2, 0xF0, 0x28, 0xF3, 0xD4, 0x1D, 0x26, 0x99, 0xA6, 0x8A, 0xC8, 0xA8, 0xAE,
	0xC1, 0x98, 0x87, 0x4B, 0x4A, 0xB9, 0xD6, 0x6A, 0x90, 0x51, 0xA0, 0x4D, 0x4D, 0xA5, 0xCB, 0x66,
	0xC8, 0x5D, 0x3F, 0xE8, 0x1B, 0x6E, 0x22, 0xFF, 0x4F, 0xA5, 0x5C, 0x06, 0x14, 0x25, 0xD0, 0x74,
	0xBD, 0x81, 0x48, 0xDE, 0x47, 0x69, 0x4D, 0xF4, 0xE5, 0x6E, 0xB8, 0x26, 0x3B, 0x06, 0xFE, 0x0D,
	0x84, 0x55, 0x3F, 0x37, 0x67, 0x11, 0x14, 0xF3, 0x4A, 0x17, 0xC0, 0x50, 0x9D, 0x48, 0x9D, 0x95,
	0x93, 0xB4, 0x27, 0xB6, 0x27, 0x51, 0x99, 0xCA, 0xA7, 0xB3, 0xE9, 0x1C, 0x3B, 0x89, 0x2A, 0xE7,
	0x18, 0xFF, 0xF6, 0xB6, 0xAE, 0xB2, 0x17, 0x5A, 0x33, 0x61, 0x08, 0x9D, 0xE3, 0x03, 0xFD, 0x7D,
	0x12, 0x68, 0x24, 0x6D, 0xCF, 0x6F, 0xA8, 0x87, 0x06, 0x27, 0xED, 0x4A, 0xB7, 0x13, 0x23, 0xAA,
	0x62, 0xA2, 0x21, 0xC0, 0x0E, 0x2F, 0xF3, 0x47, 0x1D, 0xFD, 0x3D, 0x06, 0x10, 0x7D, 0xA2, 0xFB,
	0x63, 0xF9, 0x04, 0x20, 0x20, 0xE7, 0x28, 0x6B, 0x6F, 0xD6, 0x7A, 0x61, 0x33, 0x76, 0x2A, 0xA4,
	0x3E, 0xEE, 0x40, 0xE8, 0x07, 0x99, 0xDA, 0xEA, 0x63, 0x65, 0x21, 0x22, 0x30, 0x0A, 0xF1, 0xD5,
	0x46, 0xAA, 0x8C, 0x06, 0x57, 0xB7, 0xB4, 0x8A, 0xDE, 0xFE, 0xA9, 0xB8, 0xA3, 0x03, 0xF0, 0xDB,
	0x4C, 0x38, 0xC0, 0x57, 0xC1, 0x47, 0xBD, 0xC7, 0x24, 0x7E, 0xBB, 0x37, 0xD2, 0xFA, 0x4D, 0x5F,
	0x03, 0x23, 0xC6, 0x53, 0xD9, 0x43, 0xCA, 0xDF, 0x84, 0x72, 0x1A, 0x06, 0xF1, 0x93, 0xAB, 0x2A,
	0x52, 0xAB, 0xEB, 0x79, 0x9F, 0x74, 0xBF, 0xE7, 0xAC, 0x95, 0xCB, 0x63, 0xCE, 0x18, 0x08, 0x99,
	0x19, 0x17, 0x36, 0x9D, 0x9C, 0x7E, 0x82, 0xDC, 0x83, 0xDC, 0xA8, 0x8D, 0x30, 0x2D, 0xF4, 0xC7,
	0xD6
};
static const size_t g_appkey_size = sizeof(g_appkey);

@interface AppDelegate() <SPSessionDelegate>

@property (nonatomic, strong) ICSDrawerController *drawer;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Theme setup];
    NSError *error = nil;
    NSData *key = [[NSData alloc] initWithBytes:g_appkey length:g_appkey_size];
    if (![SPSession initializeSharedSessionWithApplicationKey:key userAgent:kMBUserAgent error:&error]) {
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

- (void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage {
    NSLog(@"CocoaLS DEBUG: %@", aMessage);
}

@end
