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
#import "UIView+CSS.h"
#import "UIImage+Gradient.h"
#import "UILabel+AppearanceFix.h"
#import "MenuViewController.h"
#import "MenuItem.h"
#import "ViewController.h"
#import "AlbumsView.h"
#import "AlbumCell.h"
#import "AlbumCard.h"

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

@implementation Theme

+ (void)setup {
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(44, 44, 44)];
    [[UINavigationBar appearance] setTintColor:RGBCOLOR(44, 44, 44)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(190, 190, 190)}];
    [[UISearchBar appearance] setBarTintColor:[UIColor blackColor]];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBCOLOR(190, 190, 190)}
//                                                forState:UIControlStateNormal];
    [[AlbumsView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern3.jpg"]]];
    CSSBorder *imageBorder = [[CSSBorder alloc] init];
    imageBorder.color = [UIColor whiteColor];
    CSSBorderRadius *imageBorderRadius = [[CSSBorderRadius alloc] init];
    imageBorderRadius.radius = 15.0f;
    [[AlbumCard appearance] setImageBorder:imageBorder];
    [[AlbumCard appearance] setImageBorderRadius:imageBorderRadius];
    
    [[PlayPauseButton appearance] setControlButtonColor:[UIColor whiteColor]];
    [[PlayPauseButton appearance] setBackgroundColor:[UIColor clearColor]];
    NSArray *colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [[Player appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradientWithColors:colors height:100]]];
    [[UILabel appearanceWhenContainedIn:[Player class], nil] setTextColor:[UIColor whiteColor]];
    [self styleCaption1Label:[UILabel appearanceWhenContainedIn:[Player class], nil]];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    UILabel *label;
    
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    CSSBorder *border = [[CSSBorder alloc] init];
    border.color = [UIColor darkGrayColor];
    border.width = 1.0f;
    border.sides = CSSBorderSideTop;
    CSSDropshadow *shadow = [[CSSDropshadow alloc] init];
    shadow.color = [UIColor lightGrayColor];
    [[Player appearance] setBorder:border];
    [[Player appearance] setDropShadow:shadow];
    
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
}

+ (void)styleCaption1Label:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
}

+ (void)styleCaption2Label:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]];
}

+ (void)styleHeaderLabel:(UILabel *)label {
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
}

+ (void)styleStrongLabel:(UILabel *)label {
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
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
    [button setBackgroundImage:[UIImage gradientWithColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor lightGrayColor].CGColor] height:30] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage gradientWithColors:@[(id)[UIColor lightGrayColor].CGColor, (id)[UIColor whiteColor].CGColor] height:30] forState:UIControlStateHighlighted];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    CSSBorderRadius *borderRadius = [[CSSBorderRadius alloc] init];
    borderRadius.radius = 17;
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


@end
