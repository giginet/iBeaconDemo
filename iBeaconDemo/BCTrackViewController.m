//
//  BCTrackViewController.m
//  iBeaconDemo
//
//  Created by giginet on 2013/10/23.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "BCTrackViewController.h"

@interface BCTrackViewController ()

@end

@implementation BCTrackViewController

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
    self.statusDictionary = [@{
                               @"isFound" : @"NO",
                               @"proximityUUID" : @"",
                               @"major" : @"",
                               @"minor" : @"",
                               @"accuracy" : @"",
                               @"distance" : @"",
                               @"rssi" : @""
                               } mutableCopy];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
	// Do any additional setup after loading the view.
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"BC609B17-6D25-449E-9371-A0498E1989C8"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"org.kawaz.iBeaconDemo"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *labels = @[@"isFound", @"proximityUUID", @"major", @"minor", @"accuracy", @"distance", @"rssi"];
        cell.textLabel.text = labels[indexPath.row];
        cell.detailTextLabel.text = self.statusDictionary[labels[indexPath.row]];
    }
    return cell;
}

#pragma mark CLLocationManagerDelegate

- 
(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    self.statusDictionary[@"isFound"] = @"NO";
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [CLBeacon new];
    beacon = [beacons lastObject];
    self.statusDictionary[@"isFound"] = @"YES";
    self.statusDictionary[@"major"] = [NSString stringWithFormat:@"%@", beacon.major];
    self.statusDictionary[@"minor"] = [NSString stringWithFormat:@"%@", beacon.minor];
    self.statusDictionary[@"accuracy"] = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
       self.statusDictionary[@"distance"] = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
       self.statusDictionary[@"distance"] = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
       self.statusDictionary[@"distance"] = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
       self.statusDictionary[@"distance"] = @"Far";
    }
    self.statusDictionary[@"rssi"] = [NSString stringWithFormat:@"%i", beacon.rssi];
    [self.tableView reloadData];
}

@end
