//
//  PlayPauseButton.h
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStatePlaying,
    PlayerStatePaused
};
// PlayPauseButton.h

@interface PlayPauseButton : UIControl

@property (nonatomic, assign) PlayerState playState;

@property (nonatomic, strong) UIColor *controlButtonColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;

@end
