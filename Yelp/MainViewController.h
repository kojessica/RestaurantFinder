//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, assign) bool isSearchFirstResponder;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic) int indexCategory;

@end
