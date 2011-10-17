//
//  ColorView.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorView.h"

#define BORDER_RADIUS 16
#define MARGIN 1

@implementation ColorView

@synthesize color;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.color = [UIColor blackColor];
    }
    return self;
}

- (void)setColor:(UIColor *)aColor {
	[color release];
	color = aColor;
	[color retain];	
	[self setNeedsDisplay];
}

- (void)drawRoundedRect:(CGContextRef)context withRect:(CGRect)rect {
	CGFloat xLeft = rect.origin.x;
	CGFloat xRight = rect.origin.x + rect.size.width;
	CGFloat yTop = rect.origin.y;
	CGFloat yBottom = rect.origin.y + rect.size.height;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, xRight - BORDER_RADIUS, yTop);
	
	// Top right corner
	CGContextAddArcToPoint(context, xRight, yTop, xRight, yTop + 1, BORDER_RADIUS);
	CGContextAddLineToPoint(context, xRight, yBottom - BORDER_RADIUS);

	// Bottom right 
	CGContextAddArcToPoint(context, xRight, yBottom, xRight - 1, yBottom, BORDER_RADIUS);
	CGContextAddLineToPoint(context, xLeft + BORDER_RADIUS, yBottom);
	
	// Bottom left
	CGContextAddArcToPoint(context, xLeft, yBottom, xLeft, yBottom - 1, BORDER_RADIUS);
	CGContextAddLineToPoint(context, xLeft, yTop + BORDER_RADIUS);
	
	// Top left
	CGContextAddArcToPoint(context, xLeft, yTop, xLeft + 1, yTop, BORDER_RADIUS);
	
	CGContextClosePath(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0f);
	[[UIColor blackColor] setStroke];
	[self.color setFill];
	
	CGRect roundRect = rect;
	roundRect.origin.x += MARGIN;
	roundRect.origin.y += MARGIN;
	roundRect.size.width -= MARGIN * 2;
	roundRect.size.height -= MARGIN * 2;
	
	if (self.color) {
		[self drawRoundedRect:context withRect:roundRect];
		CGContextFillPath(context);
	}
	
	[self drawRoundedRect:context withRect:roundRect];
	CGContextStrokePath(context);
}

- (void)dealloc {
	[color release];
    [super dealloc];
}


@end
