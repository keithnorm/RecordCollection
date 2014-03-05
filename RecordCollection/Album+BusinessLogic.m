//
//  Album+BusinessLogic.m
//  RecordCollection
//
//  Created by Keith Norman on 3/4/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "Album+BusinessLogic.h"

@implementation Album (BusinessLogic)

- (NSString *)playlistName {
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.artistName];
}

@end
