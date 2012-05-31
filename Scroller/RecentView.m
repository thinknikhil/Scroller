//
//  RecentView.m
//  Scroller
//
//  Created by reefaq on 25/04/12.
//  Copyright (c) 2012 raw engineering. All rights reserved.
//

#import "RecentView.h"
#import "UserBoxView.h"

@interface RecentView (hidden)

- (void) animateToIndex:(int)index  animated:(BOOL)animated;
- (void) load;
- (void) setup;
@end


@implementation RecentView

@synthesize recentViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self load];
		currentSize = frame.size;
		
		super.delegate = self;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
        [self setBounces:NO];
        
        //initalize soundfile
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/Tock.wav"];
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecentChat:) name:@"ReceivedChatMessage" object:nil];
		
    }
    return self;
}

- (void) load {
	self.backgroundColor = [UIColor blackColor];
	
	views = [[NSMutableArray alloc] init];
	
	currentIndex = -1;
	coverSize = CGSizeMake(224, 200);
	spaceFromCurrent = coverSize.height/2.4;
	[self setup];
}

- (void) setup {
	
	for(UIView *v in views) [v removeFromSuperview];
	[views removeAllObjects];
	
	currentSize = self.frame.size;
	currentIndex = -1;
	self.contentOffset = CGPointZero;
	
}

- (void) animateToIndex:(int)index animated:(BOOL)animated {
	
	NSString *string = @"";
	if(velocity> 200) animated = NO;
	
	if(animated){
		float speed = 0.21;
		if(velocity>80)speed=0.05;
		[UIView beginAnimations:string context:nil];
		[UIView setAnimationDuration:speed];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}

    int currentViewIndex = 0;
	for(UIView *v in views){
		v.alpha = 1;
		if (currentViewIndex == index) {
			[v setBackgroundColor:RGBACOLOR(255,255,255,1)];
			v.layer.transform = CATransform3DMakeTranslation(-(spaceFromCurrent-30), 0, -300);
		}else {
			[v setBackgroundColor:RGBACOLOR(255,255,255,0.8)];
			if (currentViewIndex == index-1 || currentViewIndex == index + 1) {
				v.alpha = 0.9;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.8, 0.8, 1),CATransform3DMakeTranslation(-(spaceFromCurrent-70), 0, -300));
			}else if (currentViewIndex == index-2 || currentViewIndex == index + 2) {
				v.alpha = 0.7;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.7, 0.7, 1),CATransform3DMakeTranslation(-(spaceFromCurrent-90), (currentViewIndex > index? -8:8), -300));
			}else if (currentViewIndex == index-3 || currentViewIndex == index + 3) {
				v.alpha = 0.5;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.6, 0.6, 1),CATransform3DMakeTranslation(-(spaceFromCurrent-110), (currentViewIndex > index? -22:22), -300));
			}else if (currentViewIndex == index-4 || currentViewIndex == index + 4) {
				v.alpha = 0;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.6, 0.6, 1),CATransform3DMakeTranslation(-(spaceFromCurrent-130), (currentViewIndex > index? -38:38), -300));
			}else{
				v.alpha = 0;
				v.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.6, 0.6, 1),CATransform3DMakeTranslation(-(spaceFromCurrent-300), (currentViewIndex > index? -8:8), -300));
			}
		}
        currentViewIndex++;
	}
	if(animated) [UIView commitAnimations];
    
    [self playSound];
	
}

#pragma mark UIScrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    	
	float yOffset = scrollView.contentOffset.y;
    
	velocity = abs(pos - yOffset);
	pos = yOffset;
	
	CGFloat num = totalViews;
	CGFloat per = (scrollView.contentOffset.y) / (self.contentSize.height - currentSize.height);
	CGFloat ind = num * per;
	CGFloat mi = ind / (totalViews/2);
	
	mi = 1 - mi;
	mi = mi / 2;
	int index = (int)(ind+mi);

	index = MIN(MAX(0,index),totalViews-1);
	
	if(index == currentIndex) return;

	currentIndex = index;
	
	if(velocity < 180)
		[self animateToIndex:index animated:YES];

}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if(!scrollView.tracking && !scrollView.decelerating){
		[self snapToAlbum:YES];
	} 
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!scrollView.decelerating && !decelerate){
		[self snapToAlbum:YES];
	}
}

- (void) snapToAlbum:(BOOL)animated{
	
	if (currentIndex < totalViews) {
		UIView *v = [views objectAtIndex:currentIndex];
		
		if((NSObject*)v!=[NSNull null]) {
			[self setContentOffset:CGPointMake(0, (v.center.y  - (currentSize.height/2.2))) animated:animated];

            [self playSound];
		}
	}
	
}

#pragma mark Touch Events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if(touch.view != self &&  [touch locationInView:touch.view].y < coverSize.height){
		currentTouch = touch.view;
	}
	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if(touch.view == currentTouch){
		if(touch.tapCount == 1 && currentIndex == [views indexOfObject:currentTouch]){
            if ([self.recentViewDelegate respondsToSelector:@selector(selectedView:)]) {
                [self.recentViewDelegate selectedView:(UserBoxView*)currentTouch];
            }
		}
	}
	
	currentTouch = nil;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(currentTouch!= nil) currentTouch = nil;
}

////////////////////////////////////////////////////////////////
// public method
////////////////////////////////////////////////////////////////

- (void) bringViewAtIndexToFront:(int)index animated:(BOOL)animated{
    if(index == currentIndex) return;

	if (index < totalViews) {

		currentIndex = index;
		
		[self snapToAlbum:animated];
		[self animateToIndex:index animated:animated];
	}else {
		return;
	}
	
}

-(void)addUserInList:(ABRecordRef)personRef  {

	float ypos = 0;
	
	ypos = currentSize.height /2.4;
	
	if (totalViews > 0) {
		ypos  += totalViews * 50 ;
	}
	
	UserBoxView* boxView = [[UserBoxView alloc] initWithFrame:CGRectMake(70, ypos, 250, 50)];
	[boxView.userImageView setImage:[UIImage imageNamed:@"defaultPersonImage.png"]];
    boxView.personRecordRefID = ABRecordGetRecordID(personRef);
    
    
	
    NSString* firstName = (__bridge_transfer NSString*) ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*) ABRecordCopyValue(personRef, kABPersonLastNameProperty);
    
    CFDataRef image = ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatThumbnail);

    NSData* imageData = (__bridge_transfer NSData*)image;
    
    //CFRelease(image);
    [boxView.displayTextLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,(lastName.length>0 ? lastName : @"")]];
	if (imageData != nil) {
		[boxView.userImageView setImage:[UIImage imageWithData:imageData]];
	}else {
        [boxView.userImageView setImage:[UIImage imageNamed:@"userdefault.jpg"]];
    }
	
	//[boxView.unreadMsgLabel setText:[NSString stringWithFormat:@" %d ",[xmppUserObject.unreadMessages intValue]]];
	[views addObject:boxView];
	
	[self addSubview:boxView];
	ypos  = ypos + 50 ;
    //RELEASE_SAFELY(boxView);
	
	ypos = ypos + (currentSize.height/2.2);
	totalViews = [views count];
	self.contentSize = CGSizeMake(currentSize.width, ypos);
}

-(void)jumpToLast:(BOOL)animated {
    int lastIndex = totalViews - 1 ;
    [self bringViewAtIndexToFront:lastIndex animated:animated];
}

-(void)playSound {
	AudioServicesPlaySystemSound(soundID);
}

- (void) dealloc {	
    AudioServicesDisposeSystemSoundID(soundID);
    self.recentViewDelegate = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
