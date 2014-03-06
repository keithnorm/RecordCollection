//
//  NoAlbumsView.m
//  RecordCollection
//
//  Created by Keith Norman on 3/5/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NoAlbumsView.h"
#import "UIView+Event.h"

@interface NoAlbumsView()

@property (nonatomic, strong) IBOutlet UIButton *findSweetTunesButton;

@end

@implementation NoAlbumsView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.findSweetTunesButton addTarget:self action:@selector(onTapSweetTunes:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapSweetTunes:(UIButton *)sender {
    [self fireEvent:@"userDidTapFindSweetTunes" withObject:nil];
}

@end
