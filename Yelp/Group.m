//
//  Group.m
//  Yelp
//
//  Created by Jessica Ko on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Group.h"

@interface Group ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation Group

-(void) setGroup:(NSDictionary*)group {
    _group = group;
    self.name = group[@"name"];
    self.desc = group[@"desc"];
    self.profileImage = group[@"iamge"];
}

@end
