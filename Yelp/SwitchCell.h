//
//  SwitchCell.h
//  Yelp
//
//  Created by Jessica Ko on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

@optional
-(void)sender:(SwitchCell *)sender didChangeValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell <SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

@end

