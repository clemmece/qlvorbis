#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <Engine.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    /*
     * I was unable to find an official list of valid values for the options dictionary in any of the Apple Docs. The information
     * below is the best I was able to determine after trial and error using the debug output of qlmanage along with some console
     * output generated from using CFDictionaryApplyFunction to print the values in the CFDictionaryRef parameter.
     *
     * Further Reading
     * https://developer.apple.com/library/mac/documentation/userexperience/Reference/QLPreviewRequest_Ref/Reference/reference.html
     *
     * from the above URL:
     *  options:
     *  A dictionary of options for processing the preview. Options may be passed from the client (for example, Finder or
     *  Spotlight).
     *
     * From what I can determine, clients can pass several different preview modes per client. In the case of calls from
     * Finder, QLPreviewMode was set to 1 when a file was simply selected (highlighted) in Finder and
     * set to 5 when a highlighted file was previewed by pressing the spacebar.
     *
     * QLPreviewMode Values from Finder
     * 1 = file highlighted
     * 5 = activated by spacebar
     */
    
    /*************************************************************************/
    //CFDictionaryApplyFunction(options, printKeys, NULL); //uncomment to print out the key/value pairs in options
    NSDictionary *dict = (__bridge NSDictionary *)options;
    NSNumber *previewMode = (NSNumber *)[dict objectForKey:@"QLPreviewMode"];
    if([previewMode longValue] != 5) return noErr; //return if QL hasn't been activated by spacebar in Finder
    /*************************************************************************/
    Engine* engine = [[Engine alloc] initWithContentsOfURL:(__bridge NSURL *)url];
    [engine prepareAudioBuffers];
    [engine playAudio];
    [engine dealloc];
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
