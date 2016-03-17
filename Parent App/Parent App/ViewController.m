//
//  ViewController.m
//  Parent App
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

//setting action for submit button
- (IBAction)submitButton:(UIButton *)sender {
    NSLog(@"username & radius submitted");
    self.userID = self.userNameTextField.text;
    self.radius = self.radiusTextField.text;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    [self.userNameTextField resignFirstResponder]; //closes keyboard
}

//setting action for update radius button
- (IBAction)updateRadiusButton:(UIButton *)sender {
    self.didClickUpdateRadius = true;
    self.updatedRadius = self.radiusTextField.text;
    [self.radiusTextField resignFirstResponder]; //closes keyboard
    
    //converting NSDictionary to JSON string for patch request
    NSDictionary *userDetails = @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID,@"radius":self.updatedRadius}, @"commit":@"Create User", @"action":@"update", @"controller":@"users"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
    
    //patching string to server
    NSString *patchUrl = [NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@", self.userID];
    
    NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchUrl]];
    
    [patchRequest setHTTPMethod:@"PATCH"];
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Acccept"];
    [patchRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [patchRequest setHTTPBody:jsonData];
    
    //connecting patchrequest to server
    NSURLConnection *patchConnection = [[NSURLConnection alloc] initWithRequest:patchRequest delegate:self];
    
    //alerting user that the zone was updated
    UIAlertController *updateRadiusAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Your zone has been updated." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *successAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[updateRadiusAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [updateRadiusAlert addAction:successAction];
    [self presentViewController:updateRadiusAlert animated:YES completion:nil];
}

//setting error messages for locationManager method
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[errorAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [errorAlert addAction:alertAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

//setting locationManager method to retrieve and print lat & long & post data to server
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //formats lat & long for printing to the screen
    CLLocation *crnLoc = [locations lastObject];
    self.latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    
    //converting NSDictionary to JSON string for post request
    
    NSDictionary *userDetails = @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID,@"latitude":self.latitude.text,@"longitude":self.longitude.text,@"radius":self.radius}, @"commit":@"CreateUser", @"action":@"update", @"controller":@"users"};
    
    //setting error handling for post request
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
    
    //posting string to server
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://protected-wildwood-8664.herokuapp.com/users/"]];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Acccept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:jsonData];
    
    //connecting postrequest to server
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    [manager stopUpdatingLocation];
}

//hiding keyboard if you touch elsewhere on the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameTextField resignFirstResponder];
    [[self view] endEditing:YES];
    [self.radiusTextField resignFirstResponder];
    [[self view] endEditing:YES];
}

- (IBAction)getChildStatusButton:(UIButton *)sender {
    
    self.didClickStatus = true;
    
    //formatting the url to be dynamic in terms of username
    NSString *getUrl = [NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@.json", self.userID];
    
    //creating the get request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]];
    
    //creating the url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) convertToDictionary {
    NSLog(@"Connection made");
    NSError *error;
    
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&error];
    NSLog(@"MYDICTIONARY %@\n", myDictionary);
    
    //parse through data
    NSDictionary *zone = [myDictionary objectForKey:@"is_in_zone"];


    //create if statement to handle variable
    if (zone > 0) self.childStatus.text = [NSString stringWithFormat:@"In zone"];
    else if (zone == 0) self.childStatus.text = [NSString stringWithFormat:@"Out of zone"];
    else self.childStatus.text = [NSString stringWithFormat:@"Unknown"];
}

#pragma mark NSURLConnection Delegate Methods (Get Request

//initializing the instance var when response received to append data to it in didReceiveData method
//calling each time there is a redirect so reinitializing it also serves to clear it
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _receivedData = [[NSMutableData alloc] init];
}

// appending the new data to the instance variable
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

// returning nil to indicate not necessary to store a cached response for this connection
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

//signaling that request is complete and data has been received
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.didClickStatus) [self convertToDictionary];
}

//signaling that request has failed for some reason
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //too many HTTP redirects is unavoidable error so this makes it an exception
    if (![error.localizedDescription  isEqual: @"too many HTTP redirects"]) {
        
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[errorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorAlert addAction:alertAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}

@end