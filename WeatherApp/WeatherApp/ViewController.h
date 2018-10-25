//
//  ViewController.h
//  WeatherApp
//
//  Created by Guest-BCA-GSIT-iMac 1 on 23/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchLocation;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
@property (strong, nonatomic) IBOutlet UILabel *degreeLbl;
@property (strong, nonatomic) IBOutlet UILabel *weatherLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *temperatureSet;


@end

