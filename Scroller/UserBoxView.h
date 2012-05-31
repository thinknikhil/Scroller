//
//  UserBoxView.h
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserBoxView : UIView {

	UIImageView* _userImageView;
	UILabel* _displayTextLabel;
//	UILabel* _unreadMsgLabel;
	
}

@property (nonatomic) UIImageView* userImageView;
@property (nonatomic) UILabel* displayTextLabel;
@property (nonatomic,assign) NSInteger personRecordRefID;
//@property (nonatomic,retain) UILabel* unreadMsgLabel;


@end
