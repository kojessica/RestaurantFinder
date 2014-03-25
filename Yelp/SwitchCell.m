//
//  SwitchCell.m
//  Yelp
//
//  Created by Jessica Ko on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

-(void)didChangeValue:(id)sender;

@end

@implementation SwitchCell

- (void)awakeFromNib
{
    // Initialization code
    [self.switchControl addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didChangeValue:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sender:didChangeValue:)]) {
        [self.delegate sender:self didChangeValue:self.switchControl.on];
    }
}

@end
