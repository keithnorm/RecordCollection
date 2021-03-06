//
//  Theme.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "Theme.h"
#import "PlayPauseButton.h"
#import "Player.h"
#import "ScrubberBar.h"
#import "NextButton.h"
#import "ScrubberBarProgressBar.h"
#import "UIView+CSS.h"
#import "UIImage+Gradient.h"
#import "UILabel+AppearanceFix.h"
#import "MenuViewController.h"
#import "MenuItem.h"
#import "ViewController.h"
#import "AlbumsView.h"
#import "AlbumCell.h"
#import "AlbumCard.h"
#import "NoAlbumsView.h"
#import "OpenDrawerBtn.h"
#import "UIFont+Scale.h"
#import "OCAEditableCollectionViewFlowLayoutCell.h"

#define RGBCOLOR(r, g, b)                   [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : 1]
#define RGBACOLOR(r, g, b, a)               [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : (a)]
#define RGBA(r, g, b, a)                    (r) / 255.0, (g) / 255.0, (b) / 255.0, (a)

CGImageRef CGGenerateNoiseImage(CGSize size, CGFloat factor) {
    NSUInteger bits = fabs(size.width) * fabs(size.height);
    char *rgba = (char *)malloc(bits);
    srand(124);
    
    for(int i = 0; i < bits; ++i)
        rgba[i] = (rand() % 256) * factor;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(rgba, fabs(size.width), fabs(size.height),
                                                       8, fabs(size.width), colorSpace, 0);
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    
    CFRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    free(rgba);
    
    return image;
}

CGFloat fontScale;

@implementation Theme

+ (void)setup {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontScale = 1.3f;
    } else {
        fontScale = 1.0f;
    }
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(44, 44, 44)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIFontDescriptor *titleDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    titleDescriptor = [UIFontDescriptor fontDescriptorWithName:@"Airstream" size:[titleDescriptor pointSize] * 1.6 * fontScale];
    UIFont *titleFont = [UIFont fontWithDescriptor:titleDescriptor size:0];
    NSDictionary *navBarTextAttributes = @{
                                           NSForegroundColorAttributeName : RGBCOLOR(190, 190, 190),
                                           NSFontAttributeName: titleFont
                                           };
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTextAttributes];
    [[UISearchBar appearance] setBarTintColor:[UIColor blackColor]];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBCOLOR(190, 190, 190)}
//                                                forState:UIControlStateNormal];
    [[AlbumsView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern3.jpg"]]];
    CSSBorder *imageBorder = [[CSSBorder alloc] init];
    imageBorder.color = [UIColor whiteColor];
    [[AlbumCard appearance] setImageBorder:imageBorder];
    //    [[AlbumCard appearance] setImageBorderRadius:imageBorderRadius];
    CSSBorderRadius *imageBorderRadius = [[CSSBorderRadius alloc] init];
    imageBorderRadius.radius = 15.0f;
    [[UIImageView appearanceWhenContainedIn:[AlbumCard class], nil] setBorderRadius:imageBorderRadius];
    
    [[PlayPauseButton appearance] setControlButtonColor:[UIColor whiteColor]];
    [[PlayPauseButton appearance] setBackgroundColor:[UIColor clearColor]];
    [[PlayPauseButton appearance] setPadding:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[NextButton appearance] setTintColor:[UIColor whiteColor]];
    // cool way to set a gradient background
//    NSArray *colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//    [[Player appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradientWithColors:colors height:100]]];
    [[Player appearance] setBackgroundColor:RGBCOLOR(44, 44, 44)];
    [[ScrubberBar appearance] setBackgroundColor:RGBCOLOR(218, 128, 111)];
    [[ScrubberBarProgressBar appearance] setBackgroundColor:RGBCOLOR(255, 149, 128)];
    
    
    [[UILabel appearanceWhenContainedIn:[Player class], nil] setTextColor:[UIColor whiteColor]];
//    [self styleCaption1Label:[UILabel appearanceWhenContainedIn:[Player class], nil]];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody scale:fontScale]];
    
    CSSBorder *border = [[CSSBorder alloc] init];
    border.color = [UIColor darkGrayColor];
    border.width = 1.0f;
    border.sides = CSSBorderSideTop;
    CSSDropshadow *shadow = [[CSSDropshadow alloc] init];
    shadow.color = [UIColor darkGrayColor];
    [[Player appearance] setBorder:border];
    
//    [[Player appearance] setDropShadow:shadow];
    
//    [self stylePrimaryButton:[UIButton appearance]];
    
    [[UITableView appearanceWhenContainedIn:[MenuViewController class], nil] setBackgroundColor:RGBCOLOR(44, 44, 44)];
    CSSBorder *cellBorderBottom = [[CSSBorder alloc] init];
    cellBorderBottom.sides = CSSBorderSideBottom;
    cellBorderBottom.color = RGBCOLOR(21, 21, 21);
    CSSBorder *cellBorderTop = [[CSSBorder alloc] init];
    cellBorderTop.sides = CSSBorderSideTop;
    cellBorderTop.color = RGBCOLOR(70, 70, 70);
    [[MenuItem appearanceWhenContainedIn:[MenuViewController class], nil] setBorderTop:cellBorderTop];
    [[MenuItem appearanceWhenContainedIn:[MenuViewController class], nil] setBorderBottom:cellBorderBottom];
    [[MenuItem appearanceWhenContainedIn:[MenuViewController class], nil] setContentInsets:UIEdgeInsetsMake(10, 10, 0, 0)];
//    [[MenuItem appearanceWhenContainedIn:[MenuViewController class], nil] setBackgroundColor:RGBCOLOR(61, 61, 61)];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil]
     setTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(146, 146, 146)}];
    [[MenuItem appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithCGImage:CGGenerateNoiseImage(CGSizeMake(100, 100), 0.15f)]]];
    
    [[OCAEditableCellDeleteButton appearance] setBackgroundColor:[UIColor orangeColor]];
    [[OCAEditableCellDeleteButton appearance] setStrokeColor:[UIColor whiteColor]];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
    
    [[OpenDrawerBtn appearance] setLineColor:RGBCOLOR(146, 146, 146)];
    [[OpenDrawerBtn appearance] setBackgroundColor:[UIColor clearColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setupiPad];
    }
}

+ (void)setupiPad {
    [[Player appearance] setHeight:140.0f];
    [[PlayPauseButton appearance] setLineWidth:8.0f];
    [[PlayPauseButton appearance] setPadding:UIEdgeInsetsMake(10, 10, 10, 13)];
}

+ (void)styleCaption1Label:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1 scale:fontScale]];
}

+ (void)styleCaption2Label:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2 scale:fontScale]];
}

+ (void)styleHeaderLabel:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline scale:fontScale]];
}

+ (void)styleStrongLabel:(UILabel *)label {
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
    CGFloat size = font.pointSize * fontScale;
    font = [UIFont fontWithDescriptor:descriptor size:size];
    [label setFont:font];
}

+ (void)stylePrimaryButton:(UIButton *)button {
//    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradientWithColors:@[(id)[UIColor lightGrayColor].CGColor, (id)[UIColor whiteColor].CGColor]]]];
    [button setBackgroundImage:[UIImage gradientWithColors:@[(id)[UIColor lightGrayColor].CGColor, (id)[UIColor whiteColor].CGColor] height:34] forState:UIControlStateNormal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    CSSBorder *border = [[CSSBorder alloc] init];
    border.color = [UIColor darkGrayColor];
    border.width = 1.0f;
    border.sides = CSSBorderSideAll;
    [button setBorder:border];
    CSSBorderRadius *borderRadius = [[CSSBorderRadius alloc] init];
    borderRadius.radius = 5.0f;
    borderRadius.corners = UIRectCornerAllCorners;
    [button setBorderRadius:borderRadius];
}

+ (void)styleIconButton:(UIButton *)button {
    CGFloat fontSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        fontSize = 30.0f;
    } else {
        fontSize = 15.0f;
    }
    [button setBackgroundImage:[UIImage gradientWithColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor lightGrayColor].CGColor] height:30] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage gradientWithColors:@[(id)[UIColor lightGrayColor].CGColor, (id)[UIColor whiteColor].CGColor] height:30] forState:UIControlStateHighlighted];
    [button setContentEdgeInsets:UIEdgeInsetsMake(fontSize / 3.0f, fontSize / 1.5f, fontSize / 3.0f, fontSize / 1.5f)];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]];
    CSSBorderRadius *borderRadius = [[CSSBorderRadius alloc] init];
    borderRadius.radius = fontSize + 2.0f;
    borderRadius.corners = UIRectCornerAllCorners;
    
    [button invalidateIntrinsicContentSize];
    
    [button setBorderRadius:borderRadius];
}

+ (void)styleMyCollectionLink:(MenuItem *)menuItem {
    [menuItem setContentInsets:UIEdgeInsetsMake(12, 40, 0, 0)];
    UIImage *icon = [UIImage imageNamed:@"turntable"];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    iconView.image = icon;
    [menuItem addSubview:iconView];
}

+ (void)styleRecentlyPlayedLink:(MenuItem *)menuItem {
    [menuItem setContentInsets:UIEdgeInsetsMake(12, 40, 0, 0)];
    UIImage *icon = [UIImage imageNamed:@"headphones"];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    iconView.image = icon;
    [menuItem addSubview:iconView];
}

+ (void)styleSweetTunesButton:(UIButton *)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIFontDescriptor *titleDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    titleDescriptor = [UIFontDescriptor fontDescriptorWithName:@"Airstream" size:[titleDescriptor pointSize] * 1.6 * fontScale];
    UIFont *titleFont = [UIFont fontWithDescriptor:titleDescriptor size:0];
    button.titleLabel.font = titleFont;
    NSArray *colors = [NSArray arrayWithObjects:(id)RGBCOLOR(209, 106, 90).CGColor, (id)RGBCOLOR(209, 106, 90).CGColor, nil];
    [button setBackgroundImage:[UIImage gradientWithColors:colors height:button.bounds.size.height] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [button invalidateIntrinsicContentSize];
    CSSBorderRadius *radius = [[CSSBorderRadius alloc] init];
    radius.radius = 7.0f;
    button.borderRadius = radius;
}

+ (void)styleHeavyRotationButton:(UIButton *)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIFontDescriptor *titleDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    titleDescriptor = [UIFontDescriptor fontDescriptorWithName:@"Airstream" size:[titleDescriptor pointSize] * 1.6 * fontScale];
    UIFont *titleFont = [UIFont fontWithDescriptor:titleDescriptor size:0];
    button.titleLabel.font = titleFont;
    NSArray *colors = [NSArray arrayWithObjects:(id)RGBCOLOR(190, 190, 190).CGColor, (id)RGBCOLOR(190, 190, 190).CGColor, nil];
    [button setBackgroundImage:[UIImage gradientWithColors:colors height:button.bounds.size.height] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [button invalidateIntrinsicContentSize];
    CSSBorderRadius *radius = [[CSSBorderRadius alloc] init];
    radius.radius = 7.0f;
    button.borderRadius = radius;
}


@end
