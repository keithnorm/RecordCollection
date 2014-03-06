//
//  NoAlbumsView.m
//  RecordCollection
//
//  Created by Keith Norman on 3/5/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NoAlbumsView.h"
#import "UIView+Event.h"
#import "UIView+StyleClass.h"

@interface NoAlbumsView()

@property (nonatomic, strong) IBOutlet UIButton *findSweetTunesButton;
@property (nonatomic, strong) IBOutlet UIButton *heavyRotationButton;

@end

@implementation NoAlbumsView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.findSweetTunesButton addTarget:self action:@selector(onTapSweetTunes:) forControlEvents:UIControlEventTouchUpInside];
    [self.heavyRotationButton addTarget:self action:@selector(onTapHeavyRotation:) forControlEvents:UIControlEventTouchUpInside];
    self.findSweetTunesButton.styleClass = @"sweetTunesButton";
    self.heavyRotationButton.styleClass = @"heavyRotationButton";
}

- (void)onTapSweetTunes:(UIButton *)sender {
    [self fireEvent:@"userDidTapFindSweetTunes" withObject:nil];
}

- (void)onTapHeavyRotation:(UIButton *)sender {
    [self fireEvent:@"userDidTapHeavyRotation" withObject:nil];
}

@end
