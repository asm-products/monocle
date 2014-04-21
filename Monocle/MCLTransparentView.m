#import "MCLTransparentView.h"

@implementation MCLTransparentView

- (void)drawRect:(NSRect)rect
{
    [[NSColor clearColor] set];
    NSRectFill(rect);
}

@end
