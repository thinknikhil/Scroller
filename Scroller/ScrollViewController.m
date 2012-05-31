//
//  ScrollViewController.m
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import "ScrollViewController.h"
#import "UserBoxView.h"

@implementation ScrollViewController

@synthesize scrollView;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    
    self.title = @"Scroller";
    
    [self.view setBackgroundColor:[UIColor grayColor]];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIBarButtonItem* addContactBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContact:)];
    self.navigationItem.rightBarButtonItem = addContactBarButton;
		
	scrollView  = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	scrollView.scrollViewDelegate = self;
	scrollView.backgroundColor = RGBACOLOR(0,0,0,0.2);
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:scrollView];
	
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray* peopleArray = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (id per in peopleArray) {
        ABRecordRef person = (__bridge ABRecordRef)per;
        [scrollView addUserInList:person];
    }
    CFRelease(addressBook);
    
	[scrollView bringViewAtIndexToFront:0 animated:YES];
    
    if ([peopleArray count] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Opps !!" message:@"No Contacts!  So Sad :( " delegate:nil cancelButtonTitle:@"I Got it!" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


-(void)addNewContact:(id)sender {

    ABNewPersonViewController* picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentModalViewController:navigation animated:YES];
	

    
}
#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller. 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[self dismissModalViewControllerAnimated:YES];
    if (person) {
        [scrollView addUserInList:person];
        [scrollView jumpToLast:YES];
    }
    
}

- (void) selectedView:(UserBoxView*)selectedview {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABRecordRef personRecordRef = ABAddressBookGetPersonWithRecordID(addressBook,selectedview.personRecordRefID);
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(personRecordRef, kABPersonFirstNameProperty);
    
    CFRelease(addressBook);

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Clicked !!" message:[NSString stringWithFormat:@"You Clicked %@ !",firstName] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
