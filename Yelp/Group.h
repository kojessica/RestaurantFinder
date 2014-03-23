//
//  Group.h
//  Yelp
//
//  Created by Jessica Ko on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *reviewCount;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSDictionary *group;
- (id)initWithNSDictionary:(NSDictionary*)group;

@end
