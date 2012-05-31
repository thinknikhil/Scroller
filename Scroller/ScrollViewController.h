//
//  ScrollViewController.h
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollView.h"
#import <AddressBookUI/AddressBookUI.h>


@interface ScrollViewController : UIViewController<ScrollViewDelegate,ABNewPersonViewControllerDelegate> {
	ScrollView* scrollView;
}
@property (nonatomic, readonly) ScrollView* scrollView;
@end
