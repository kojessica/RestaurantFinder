//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "GroupCell.h"
#import "AFNetworking.h"
#import "Group.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "SettingViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) NSArray *groups;
@property (nonatomic) CGFloat cellHeight;
@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property (weak, nonatomic) IBOutlet UICollectionView *YelpCollection;
-(void)openSettings;
-(void)imgSlideInFromLeft:(UIView *)view;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", [response objectForKey:@"businesses"]);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.groups = [response objectForKey:@"businesses"];
            [self.YelpCollection reloadData];
            
            NSLog(@"%d", [self.groups count]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.YelpCollection registerClass:[GroupCell class] forCellWithReuseIdentifier:@"GroupCell"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.YelpCollection addSubview:refreshControl];
    
    [self.filterButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    self.filterButton.layer.cornerRadius = 5;
    self.filterButton.layer.borderWidth = 0.0;
    self.filterButton.clipsToBounds = YES;
    
    if (self.isSearchFirstResponder) {
        [self.searchInput becomeFirstResponder];
    } else {
    }
    
}

- (void)imgSlideInFromLeft:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}

- (void)openSettings
{
    
    SettingViewController *filterView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs insertObject:filterView atIndex:[vcs count]-1];
    [self.navigationController setViewControllers:vcs animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"%@", self.navigationController);
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", [response objectForKey:@"businesses"]);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.groups = [response objectForKey:@"businesses"];
        [self.YelpCollection reloadData];
        
        NSLog(@"%d", [self.groups count]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groups count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"GroupCell";
    GroupCell *cell = (GroupCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GroupCell alloc] init];
    }
    
    Group *group = [[Group alloc] initWithNSDictionary:[self.groups objectAtIndex:indexPath.row]];
    [cell setGroup:group];

    //NSLog(@"%f", self.cellHeight);
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *name = [self.groups objectAtIndex:indexPath.row][@"name"];
    UIFont *fontName = [UIFont fontWithName:@"ProximaNovaRegular" size:15];

    //NSLog(@"%@", font);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributesName = @{ NSFontAttributeName : fontName };
    CGSize sizeName = [name boundingRectWithSize:CGSizeMake(134, CGFLOAT_MAX) options:options attributes:attributesName context:nil].size;
    
    //NSLog(@"%f", sizeName.height);
    
    return CGSizeMake(300, sizeName.height + 108);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
