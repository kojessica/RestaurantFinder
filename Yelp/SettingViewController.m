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
@property (nonatomic, strong) NSMutableDictionary *currentParam;

@property (strong, nonatomic) NSArray *arrayCategories;
@property (nonatomic, assign) BOOL categoryIsCollpased;
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
    self.currentParam = self.searchParam;
    
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
    
    self.arrayCategories = @[@"food", @"consulting", @"sports", @"tv", @"real estate"];
    
    self.categoryIsCollpased = YES;
}

- (void)backToSearch
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    main.searchParam = self.searchParam;
    main.isSearchFirstResponder = NO;
    
    [self.navigationController pushViewController:main animated:YES];
}

- (void)settingCancel
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    main.searchParam = self.currentParam;
    [self.navigationController pushViewController:main animated:YES];
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
    if (indexPath.section == 0) {
		self.categoryIsCollpased = !self.categoryIsCollpased;
		[self.filterTable reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
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
        return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FilterOptionTableViewCell *cell = (FilterOptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FilterOptionTableViewCell"];
        if (cell == nil) {
            cell = [[FilterOptionTableViewCell alloc] init];
        }
        cell.name.text = [self.arrayCategories objectAtIndex:indexPath.row];
        
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            return cell;
            
        } else if (indexPath.row == 1) {
            SegmentFilterOptionCell *cell = (SegmentFilterOptionCell *)[tableView dequeueReusableCellWithIdentifier:@"SegmentFilterOptionCell"];
            if (cell == nil) {
                cell = [[SegmentFilterOptionCell alloc] init];
            }
            [cell.segments setTitle:@"0.3 miles" forSegmentAtIndex:0];
            [cell.segments setTitle:@"1 mile" forSegmentAtIndex:1];
            [cell.segments setTitle:@"5 miles" forSegmentAtIndex:2];
            [cell.segments setTitle:@"20 miles" forSegmentAtIndex:3];
            
            [cell.segments addTarget:self
                              action:@selector(pickSegment:)
                       forControlEvents:UIControlEventValueChanged];
            
            cell.segments.frame = CGRectMake(0, 0, 300, 100);
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        } else if (indexPath.row == 2) {
            SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            if (cell == nil) {
                cell = [[SwitchCell alloc] init];
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
