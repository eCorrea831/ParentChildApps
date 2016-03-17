//
//  ViewController.h
//  Parent App
//
//  Created by Erica Correa on 3/14/16.
//  Copyright © 2016 Turn to Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDelegate>

//properties for username
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (nonatomic) NSString *userID;

//properties for location services
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;
@property (nonatomic) NSString *radius;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (nonatomic) CLLocationManager *locationManager;

//property for posting to site
- (IBAction)submitButton:(UIButton *)sender;

//property for patching new radius to site
@property (nonatomic) NSString *updatedRadius;
@property (nonatomic) BOOL didClickUpdateRadius;
- (IBAction)updateRadiusButton:(UIButton *)sender;

//properties for getting child status
@property (weak, nonatomic) IBOutlet UILabel *childStatus;
- (IBAction)getChildStatusButton:(UIButton *)sender;
@property (nonatomic) NSMutableData *receivedData;
@property (nonatomic) NSURLConnection *theConnection;
@property (nonatomic) BOOL didClickStatus;
- (void) convertToDictionary;

@end

