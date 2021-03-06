//
//  SettingViewController.m
//  Yelp
//
//  Created by Jessica Ko on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SettingViewController.h"
#import "MainViewController.h"
#import "Group.h"
#import "FilterOptionTableViewCell.h"
#import "SegmentFilterOptionCell.h"
#import "SwitchCell.h"
#import  "QuartzCore/QuartzCore.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSArray *arrayCategories;
@property (strong, nonatomic) NSArray *arrayCategoryKeys;
@property (nonatomic, assign) BOOL categoryIsCollpased;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

- (void)settingCancel;
- (void)backToSearch;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indexOfSelectedCategoryOld = self.indexOfSelectedCategory;
    self.searchParamOld = [[NSMutableDictionary alloc] initWithDictionary:self.searchParam copyItems:YES];
    [self.cancelButton addTarget:self action:@selector(settingCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton addTarget:self action:@selector(backToSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 0.0;
    self.cancelButton.clipsToBounds = YES;
    self.searchButton.layer.cornerRadius = 5;
    self.searchButton.layer.borderWidth = 0.0;
    self.searchButton.clipsToBounds = YES;
    
    UINib *filterOptionCellNib =[UINib nibWithNibName:@"FilterOptionTableViewCell" bundle:nil];
    [self.filterTable registerNib:filterOptionCellNib forCellReuseIdentifier:@"FilterOptionTableViewCell"];

    UINib *segmentOptionCellNib =[UINib nibWithNibName:@"SegmentFilterOptionCell" bundle:nil];
    [self.filterTable registerNib:segmentOptionCellNib forCellReuseIdentifier:@"SegmentFilterOptionCell"];
    
    UINib *switchCellNib =[UINib nibWithNibName:@"SwitchCell" bundle:nil];
    [self.filterTable registerNib:switchCellNib forCellReuseIdentifier:@"SwitchCell"];
    
    self.arrayCategories = @[@"Active Life", @"Arts & Entertainment", @"Automotive", @"Beauty & Spas", @"Education", @"Event Planning & Services", @"Financial Services", @"Food", @"Health & Medical", @"Home Services", @"Hotels & Travel", @"Local Flavor", @"Local Services", @"Mass Media", @"Nightlife", @"Pets", @"Professional Services", @"Public Services & Government", @"Real Estate", @"Religious Organizations", @"Restaurants"];
    
    self.arrayCategoryKeys = @[@"active", @"arts", @"auto", @"beautysvc", @"education", @"eventservices", @"financialservices", @"food", @"health", @"homeservices", @"hotelstravel", @"localflavor", @"localservices", @"massmedia", @"nightlife", @"pets", @"professional", @"publicservicesgovt", @"realestate", @"religiousorgs", @"restaurants"];
    
    self.categoryIsCollpased = YES;
}

- (void)backToSearch
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    main.param = self.searchParam;
    main.indexCategory = self.indexOfSelectedCategory;
    //NSLog(@"%@", self.searchParamOld);
    
    main.isSearchFirstResponder = NO;
    
    [self.navigationController pushViewController:main animated:YES];
}

- (void)settingCancel
{
    MainViewController *mainC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainC.param = self.searchParamOld;
    mainC.indexCategory = self.indexOfSelectedCategoryOld;
    
    [self.navigationController pushViewController:mainC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 15;
    }
    return 25;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", self.categoryIsCollpased);
    if (indexPath.section == 0) {
        if (self.categoryIsCollpased) {
            self.categoryIsCollpased = !self.categoryIsCollpased;
            [self.filterTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            self.categoryIsCollpased = !self.categoryIsCollpased;
            self.lastIndexPath = indexPath;
            [self.searchParam setObject:self.arrayCategoryKeys[indexPath.row] forKey:@"category_filter"];
            self.indexOfSelectedCategory = indexPath.row;
            NSLog(@"%@", [self.searchParam objectForKey:@"category_filter"]);
            
            [self.filterTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.categoryIsCollpased) {
            return [self.arrayCategories count];
        }
        return self.indexOfSelectedCategory + 1;
    } else if (section == 2) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            return 45;
        }
        return 50;
    } else if (indexPath.section == 0) {
        if (self.categoryIsCollpased) {
            if (indexPath.row != self.indexOfSelectedCategory) {
                return 0;
            } else {
                return 40;
            }
        }
        return 40;
    } else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];

    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:0.7] CGColor];
    cell.backgroundView = view;
}

- (void)sender:(SwitchCell *)sender didChangeValue:(BOOL)value {
    [self.searchParam setObject:@(value) forKey:@"deals_filter"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FilterOptionTableViewCell *cell = (FilterOptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FilterOptionTableViewCell"];
        if (cell == nil) {
            cell = [[FilterOptionTableViewCell alloc] init];
        }
        cell.name.text = [self.arrayCategories objectAtIndex:indexPath.row];
        NSLog(@"asdfsadfsd%d", self.indexOfSelectedCategory);
        if (indexPath.row == self.indexOfSelectedCategory)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.hidden = NO;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (self.categoryIsCollpased) {
                cell.hidden = YES;
            }
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            SegmentFilterOptionCell *cell = (SegmentFilterOptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SegmentFilterOptionCell"];
            if (cell == nil) {
                cell = [[SegmentFilterOptionCell alloc] init];
            }
            [cell.segments setTitle:@"Best Match" forSegmentAtIndex:0];
            [cell.segments setTitle:@"Distance" forSegmentAtIndex:1];
            [cell.segments setTitle:@"Highly Rated" forSegmentAtIndex:2];

            [cell.segments addTarget:self
                              action:@selector(pickSegment:)
                    forControlEvents:UIControlEventValueChanged];
            
            [cell.segments removeSegmentAtIndex:3 animated:NO];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.segments.selectedSegmentIndex = [[self.searchParam objectForKey:@"sort"] intValue];
            
            return cell;
            
        } else if (indexPath.row == 1) {
            SegmentFilterOptionCell *cell = (SegmentFilterOptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SegmentFilterOptionCell"];
            if (cell == nil) {
                cell = [[SegmentFilterOptionCell alloc] init];
            }
            [cell.segments setTitle:@"0.3 miles" forSegmentAtIndex:0];
            [cell.segments setTitle:@"1 mile" forSegmentAtIndex:1];
            [cell.segments setTitle:@"5 miles" forSegmentAtIndex:2];
            
            if (cell.segments.numberOfSegments == 4) {
                [cell.segments setTitle:@"20 miles" forSegmentAtIndex:3];
            } else {
                [cell.segments insertSegmentWithTitle:@"20 miles" atIndex:3 animated:NO];
            }
            [cell.segments addTarget:self
                              action:@selector(pickSegment:)
                       forControlEvents:UIControlEventValueChanged];
            
            cell.segments.frame = CGRectMake(0, 0, 300, 100);
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            int radiusFilterIndex = 0;
            int radius = [[self.searchParam objectForKey:@"radius_filter"] intValue];
            if (radius == 500) {
                radiusFilterIndex = 0;
            } else if (radius == 1500) {
                radiusFilterIndex = 1;
            } else if (radius == 8000) {
                radiusFilterIndex = 2;
            } else if (radius == 32000) {
                radiusFilterIndex = 3;
            }
            cell.segments.selectedSegmentIndex = radiusFilterIndex;
            
            return cell;
            
        } else if (indexPath.row == 2) {
            SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            if (cell == nil) {
                cell = [[SwitchCell alloc] init];
            }
            cell.delegate = self;
            if ([[self.searchParam objectForKey:@"deals_filter"] intValue]) {
                [cell.switchControl setOn:YES animated:NO];
            } else {
                [cell.switchControl setOn:NO animated:NO];
            }

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        } else {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] init];
            }
            NSLog(@"%d%d", indexPath.row, indexPath.section);
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        NSLog(@"%d%d", indexPath.row, indexPath.section);
        
        UIButton *lgSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lgSearchButton addTarget:self
                   action:@selector(backToSearch)
         forControlEvents:UIControlEventTouchUpInside];
        [lgSearchButton setTitle:@"Search" forState:UIControlStateNormal];
        lgSearchButton.frame = CGRectMake(0.0, 0.0, 300.0, 40.0);
        lgSearchButton.layer.backgroundColor = [[UIColor colorWithRed:(37/255.0) green:(64/255.0) blue:(75/255.0) alpha:1] CGColor];
        [cell addSubview:lgSearchButton];
        [lgSearchButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.layer.cornerRadius = 5.0;
        [cell setClipsToBounds:YES];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.frame = CGRectMake(5.0, 0.0, 300.0, 15.0);
    switch (section)
    {
        case 0:
            headerLabel.text = @"Filter Results By";
            break;
        case 1:
            headerLabel.text = @"Sort Results By";
            break;
        default:
            headerLabel.text = @"";
            break;
    }
    [headerLabel setTextColor:[UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:1]];
    [customView addSubview:headerLabel];
    return customView;
}

- (void)pickSegment:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *selected = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    if ([selected isEqualToString:@"Best Match"]) {
        [self.searchParam setValue:@"0" forKey:@"sort"];
    } else if ([selected isEqualToString:@"Distance"]) {
        [self.searchParam setValue:@"1" forKey:@"sort"];
    } else if ([selected isEqualToString:@"Highly Rated"]) {
        [self.searchParam setValue:@"2" forKey:@"sort"];
    } else if ([selected isEqualToString:@"0.3 miles"]) {
        [self.searchParam setValue:@"500" forKey:@"radius_filter"];
    } else if ([selected isEqualToString:@"1 mile"]) {
        [self.searchParam setValue:@"1500" forKey:@"radius_filter"];
    } else if ([selected isEqualToString:@"5 miles"]) {
        [self.searchParam setValue:@"8000" forKey:@"radius_filter"];
    } else if ([selected isEqualToString:@"20 miles"]) {
        [self.searchParam setValue:@"32000" forKey:@"radius_filter"];
    }
    
    NSLog(@"%@", selected);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
