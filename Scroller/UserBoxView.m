//
//  UserBoxView.m
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import "UserBoxView.h"


@implementation UserBoxView

@synthesize userImageView = _userImageView, displayTextLabel = _displayTextLabel, personRecordRefID; // unreadMsgLabel = _unreadMsgLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		self.layer.cornerRadius = 5;
		[self setBackgroundColor:RGBACOLOR(255,255,255,1)];
		
		_userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 46, 47)];
		[_userImageView setBackgroundColor:[UIColor clearColor]];
		_userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_userImageView.layer.borderWidth = 2;
		[_userImageView setImage:[UIImage imageNamed:@"defaultPersonImage.png"]];
		[self addSubview:_userImageView];
		
		
		_displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width - 50, self.frame.size.height)];//with unreadMsgLabel width should be -75
		[_displayTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[_displayTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [_displayTextLabel setContentMode:UIViewContentModeCenter];
		[_displayTextLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_displayTextLabel];
		
		
//		_unreadMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 25, (self.frame.size.height/2) -10, 20, 20)];
//		[_unreadMsgLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//		[_unreadMsgLabel setContentMode:UIViewContentModeCenter];
//		[_unreadMsgLabel setTextAlignment:UITextAlignmentCenter];
//		[_unreadMsgLabel setBackgroundColor:RGBCOLOR(182,224,13)];
//		_unreadMsgLabel.layer.cornerRadius = 3;
//		[self addSubview:_unreadMsgLabel];
		
    }
    return self;
}



@end
