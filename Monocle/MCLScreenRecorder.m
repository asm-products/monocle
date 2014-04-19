#import "MCLScreenRecorder.h"

@implementation MCLScreenRecorder

- (id)init
{
    images = [NSMutableArray new];
    imageProperties = @{
                        NSImageInterlaced: [NSNumber numberWithBool:NO],
                        NSImageCompressionFactor: [NSNumber numberWithFloat:1]
                        };
                        
    imageWritingQueue = dispatch_queue_create("imageWritingQueue", DISPATCH_QUEUE_SERIAL);

    self.captureSession = [AVCaptureSession new];

    if (![self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        NSLog(@"Could not set session preset to 'AVCaptureSessionPresetHigh'");
        return nil;
    }

    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];

    displayID = CGMainDisplayID();
    self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:displayID];

    if (![self.captureSession canAddInput:self.captureScreenInput]) {
        NSLog(@"Could not add input 'AVCaptureScreenInput'");
        return nil;
    }

    [self.captureSession addInput:self.captureScreenInput];

    captureVideoDataOutput = [AVCaptureVideoDataOutput new];
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("videoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [captureVideoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];

    captureVideoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};

    if (![self.captureSession canAddOutput:captureVideoDataOutput]) {
        NSLog(@"Could not add output 'AVCaptureVideoDataOutput'");
        return nil;
    }

    [self.captureSession addOutput:captureVideoDataOutput];

    return self;
}

- (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);

    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return CGImageRetain(quartzImage);
}

- (void)saveGifFromImageFrames
{
    NSLog(@"Start Generating GIF image");
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)([NSURL fileURLWithPath:@"/Users/vanstee/Desktop/screen.gif"]), kUTTypeGIF, [images count], NULL);

    NSDictionary *frameProperties = @{(NSString *)kCGImagePropertyGIFDictionary: @{(NSString *)kCGImagePropertyGIFDelayTime: [self averateFrameRate]}};

    for (NSValue *encodedImage in images) {
        CGImageRef image;
        [encodedImage getValue:&image];
        CGImageDestinationAddImage(destination, image, (__bridge CFDictionaryRef)(frameProperties));
    }

    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)(@{}));
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    NSLog(@"Finish Generating GIF image");
}

- (NSNumber *)averateFrameRate
{
    NSNumber *start = timestamps[0];
    NSNumber *average = [timestamps valueForKey:@"@avg"];
    return @([average floatValue] - [start floatValue]);
}

- (IBAction)startRecording:(id)sender
{
    NSLog(@"Starting recording");
    [self.captureSession startRunning];
}

- (IBAction)stopRecording:(id)sender
{
    NSLog(@"Stopping recording");
    [self.captureSession stopRunning];

    NSLog(@"Recorded %lu images", [images count]);
    [self saveGifFromImageFrames];
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"Dropped frame!");
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CGImageRef image = [self imageFromSampleBuffer:sampleBuffer];
    NSValue *encodedImage = [NSValue valueWithBytes:&image objCType:@encode(CGImageRef)];

    @synchronized(images) {
        [images addObject:encodedImage];
    }

    @synchronized(timestamps) {
        Float64 timestamp = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer));
        [timestamps addObject:@(timestamp)];
    }
}

@end
