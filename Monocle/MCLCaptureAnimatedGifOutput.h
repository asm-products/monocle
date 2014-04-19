#import <AVFoundation/AVFoundation.h>

@interface MCLCaptureAnimatedGifOutput : AVCaptureVideoDataOutput <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong) NSMutableArray *frames;
@property (strong) NSMutableArray *frameTimestamps;
@property (strong) NSURL *destinationURL;

- (id)initWithDestinationURL:(NSURL *)destinationURL;

- (void)compileFramesIntoImageDestinationAsync;
- (void)addSampleBufferAsNextFrame:(CMSampleBufferRef)sampleBuffer;

@end
