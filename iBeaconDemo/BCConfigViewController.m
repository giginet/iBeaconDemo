//
//  BCConfigViewController.m
//  iBeaconDemo
//
//  Created by giginet on 2013/10/23.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "BCConfigViewController.h"

@interface BCConfigViewController ()

@end

@implementation BCConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initBeacon {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"BC609B17-6D25-449E-9371-A0498E1989C8"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:1
                                                                minor:1
                                                           identifier:@"org.kawaz.iBeaconDemo"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row != 4) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        switch (indexPath.row) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            case 0:
                cell.textLabel.text = @"UUID";
                cell.detailTextLabel.text = self.beaconRegion.proximityUUID.UUIDString;
                break;
            case 1:
                cell.textLabel.text = @"Major";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.major];
                break;
            case 2:
                cell.textLabel.text = @"Minor";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.minor];
                break;
            case 3:
                cell.textLabel.text = @"Identity";
                cell.detailTextLabel.text = self.beaconRegion.identifier;
                break;
            default:
                break;
        }
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = @"Start Transmit";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 4) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self transmitBeacon:cell];
    }
}

- (void)transmitBeacon:(id)sender {
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBeacon];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Power ON!!!");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Power OFF!!!");
        [self.peripheralManager stopAdvertising];
    }
}

@end
