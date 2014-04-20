#import "MCLScreenAreaSelectorView.h"

@implementation MCLScreenAreaSelectorView
{
    NSPoint mouseDownPoint;
    NSRect selectionRect;
}

- (void)mouseDown:(NSEvent *)event
{
	mouseDownPoint = [event locationInWindow];
}

- (void)mouseUp:(NSEvent *)event
{
	NSPoint mouseUpPoint = [event locationInWindow];
    selectionRect = [self calculateRectWithStartPoint:mouseDownPoint andEndPoint:mouseUpPoint];
    // do something with selectionRect
}

- (void)mouseDragged:(NSEvent *)event
{
	NSPoint currentPoint = [event locationInWindow];
	NSRect previousSelectionRect = selectionRect;
    selectionRect = [self calculateRectWithStartPoint:mouseDownPoint andEndPoint:currentPoint];
	[self setNeedsDisplayInRect:NSUnionRect(selectionRect, previousSelectionRect)];
}

- (NSRect)calculateRectWithStartPoint:(NSPoint)startPoint andEndPoint:(NSPoint)endPoint
{
    return NSMakeRect(MIN(startPoint.x, endPoint.x),
                      MIN(startPoint.y, endPoint.y),
                      MAX(startPoint.x, endPoint.x) - MIN(startPoint.x, endPoint.x),
                      MAX(startPoint.y, endPoint.y) - MIN(startPoint.y, endPoint.y));
}

- (void)drawRect:(NSRect)rect
{
	[[NSColor clearColor] set];
	NSRectFill(rect);

    [[NSColor colorWithWhite:0 alpha:0.1] set];
	NSRectFill(selectionRect);

	[[NSColor whiteColor] set];
	NSFrameRect(selectionRect);
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)canBecomeKeyView
{
    return YES;
}

@end
