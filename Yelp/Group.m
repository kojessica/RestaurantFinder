//
//  Group.m
//  Yelp
//
//  Created by Jessica Ko on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Group.h"
#import "GroupCell.h"

@interface Group ()

@end

@implementation Group

- (id)initWithNSDictionary:(NSDictionary*)group {
    _group = group;
    self.name = group[@"name"];
    self.desc = group[@"snippet_text"];
    self.desc = [self.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.desc = [self.desc stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.reviewCount = (NSNumber *)group[@"review_count"];
    self.rating = (NSNumber *)group[@"rating"];
    self.imageurl = group[@"image_url"];
    return self;
}

@end
