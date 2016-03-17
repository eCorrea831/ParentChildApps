//
//  ViewController.h
//  Child App
//
//  Created by Erica Correa on 3/14/16.
//  Copyright © 2016 Turn to Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

//properties to patch username to site
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (nonatomic) NSString *userID;

//properties to print child lat & long
@property (weak, nonatomic) IBOutlet UILabel  *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (nonatomic) CLLocationManager *locationManager;

//property to patch child status info to site
- (IBAction)submitButton:(UIButton *)sender;


@end

