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
#import  "QuartzCore/QuartzCore.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

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
    
    self.arrayCategories = @[@"food", @"consulting", @"sports", @"tv", @"real estate"];
    
    self.categoryIsCollpased = YES;
}

- (void)backToSearch
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    main.isSearchFirstResponder = YES;
    [self.navigationController pushViewController:main animated:YES];
}

- (void)settingCancel
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:main animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.categoryIsCollpased) {
            return [self.arrayCategories count];
        }
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        view.layer.cornerRadius = 5;
    } else {
        view.layer.cornerRadius = 0;
    }
    view.backgroundColor = [UIColor whiteColor];
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
        cell.categoryName.text = [self.arrayCategories objectAtIndex:indexPath.row];
        
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
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 20.0);
    switch (section)
    {
        case 0:
            headerLabel.text = @"Categories";
            break;
        case 1:
            headerLabel.text = @"Best match";
            break;
        case 2:
            headerLabel.text = @"Radius";
            break;
        case 3:
            headerLabel.text = @"Deals";
            break;
        default:
            headerLabel.text = @"";
            break;
    }
    [headerLabel setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 11]];
    [headerLabel setTextColor:[UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:1]];
    [customView addSubview:headerLabel];
    return customView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
