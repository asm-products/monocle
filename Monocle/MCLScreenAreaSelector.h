#import <Foundation/Foundation.h>

@interface MCLScreenAreaSelector : NSObject

@property (strong) NSMutableArray *windows;

- (void)startSelectingScreenArea;
- (void)stopSelectingScreenArea;

@end
