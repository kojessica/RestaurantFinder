//
//  GroupCell.m
//  Yelp
//
//  Created by Jessica Ko on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "GroupCell.h"
#import "Group.h"

@implementation GroupCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
    
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

- (void)setGroup:(Group*)group;
{
    self.name.text = group.name;
    self.desc.text = group.desc;
    self.desc.numberOfLines = 5;
    
    int formattedReviewCount = [group.reviewCount floatValue];
    self.reviewCount.text = [NSString stringWithFormat:@"%d\n%@", (int)formattedReviewCount, @"reviews"];
    
    float formattedRating = [group.rating floatValue];
    self.rating.text = [NSString stringWithFormat:@"%.01f/5\n%@", (float)formattedRating, @"rating"];
    
    NSURL *url = [NSURL URLWithString:group.imageurl];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileimg.image = [UIImage imageWithData:imageData];
        });
    });
    
    CALayer * l = [self.profileimg layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    /*NSDictionary *options = @{ NSFontAttributeName: self.name.font };
    CGRect boundingRect = [group.name boundingRectWithSize:CGSizeMake(300.f, NSIntegerMax)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:options context:nil];*/
    //NSLog(@"%@", NSStringFromCGRect(boundingRect));
    //NSLog(@"%f", boundingRect.size.height);
    //NSLog(@"%@", group.reviewCount);
    //NSLog(@"%@", group.rating);
    //NSLog(@"%@", group.imageurl);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
