//
//  SettingViewController.h
//  Yelp
//
//  Created by Jessica Ko on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"

@interface SettingViewController : UIViewController <SwitchCellDelegate>

@property (nonatomic, strong) NSMutableDictionary *searchParam;
@property (nonatomic, strong) NSMutableDictionary *searchParamOld;

@end
