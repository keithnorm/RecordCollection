//
//  Player.h
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Player : UIView

@property (nonatomic, assign) CGFloat height UI_APPEARANCE_SELECTOR;

+(instancetype)sharedPlayer;

@end
