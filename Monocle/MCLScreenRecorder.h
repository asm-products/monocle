#import <AVFoundation/AVFoundation.h>

@interface MCLScreenRecorder : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureVideoDataOutput *captureVideoDataOutput;
    CGDirectDisplayID displayID;
    dispatch_queue_t imageWritingQueue;
    NSMutableArray *images;
    NSDictionary *imageProperties;
    NSMutableArray *timestamps;
}

@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureScreenInput;

- (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

@end
