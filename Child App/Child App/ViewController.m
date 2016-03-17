//
//  ViewController.m
//  Child App
//
//  Created by Erica Correa on 3/14/16.
//  Copyright © 2016 Turn to Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //creating instance of location manager for getting lat & long & starting it
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//setting action for submit button
- (IBAction)submitButton:(UIButton *)sender {
    NSLog(@"username submitted");
    self.userID = self.userNameTextField.text;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    [self.userNameTextField resignFirstResponder]; //closes keyboard
}

//setting error messages for locationManager method
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[errorAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [errorAlert addAction:alertAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

//setting locationManager method to retrieve and print lat & long
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *crnLoc = [locations lastObject];
    self.latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    
    //converting NSDictionary to JSON string
    NSDictionary *childDict = @{@"utf8": @" ", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID,@"current_lat":self.latitude.text,@"current_longitude":self.longitude.text}, @"commit":@"CreateUser", @"action":@"update", @"controller":@"users"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:childDict options:0 error:&error];
    
    if (!jsonData) NSLog(@"JSON error: %@", error);
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog(@"JSON OUTPUT: %@",JSONString);
    }
    
    //patching string to server
    NSString *url = [NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@", self.userID];
    
    NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [patchRequest setHTTPMethod:@"PATCH"];
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Acccept"];
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [patchRequest setHTTPBody:jsonData];
    
    //connecting postrequest to server
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:patchRequest delegate:self];
}

//hides keyboard if you touch elsewhere on the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameTextField resignFirstResponder];
}

@end
