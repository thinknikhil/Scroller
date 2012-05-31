//
//  RecentViewController.h
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentView.h"
#import <AddressBookUI/AddressBookUI.h>


@interface RecentScrollViewController : UIViewController<RecentViewDelegate,ABNewPersonViewControllerDelegate> {
	RecentView* recentView;
}
@property (nonatomic, readonly) RecentView* recentView;
@end
