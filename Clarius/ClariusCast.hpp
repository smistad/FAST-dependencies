#pragma once

#include <cast/cast_def.h>    
#include <cast/ClariusCastExport.hpp>

namespace fast {

/**
 * A wrapper for the Clarius Cast API.
 * Needed to load the library at runtime.
 */
class CLARIUSCASTWRAPPER_EXPORT ClariusCast {
    public:
            /// initializes the casting functionality
    /// @param[in] argc the argument count for input parameters to pass to the library
    /// @param[in] argv the arguments to pass to the library, possibly required for qt graphics buffer initialization
    /// @param[in] dir the directory to store security keys
    /// @param[in] newProcessedImage new processed image callback (scan-converted image)
    /// @param[in] newRawImage new raw image callback - (pre scan-converted image or rf signal)
    /// @param[in] newSpectralImage new processed spectral image callback
    /// @param[in] freeze freeze state callback
    /// @param[in] btn button press callback
    /// @param[in] progress readback progress callback
    /// @param[in] err error message callback
    /// @return success of the call
    /// @retval 0 the initialization was successful
    /// @retval -1 the initialization was not successful
    /// @note must be called before any other functions will succeed
     virtual int Init(int argc,
        char** argv,
        const char* dir,
        ClariusNewProcessedImageFn newProcessedImage,
        ClariusNewRawImageFn newRawImage,
        ClariusNewSpectralImageFn newSpectralImage,
        ClariusFreezeFn freeze,
        ClariusButtonFn btn,
        ClariusProgressFn progress,
        ClariusErrorFn err,
        int width,
        int height
    ) = 0;

    /// cleans up memory allocated by the caster
    /// @retval 0 the destroy attempt was successful
    /// @retval -1 the destroy attempt was not successful
    /// @note should be called prior to exiting the application
     virtual int Destroy() = 0;

    /// tries to connect to a probe that is on the same network as the caller
    /// @param[in] ipAddress the ip address of the probe
    /// @param[in] port the probe's tcp casting port
    /// @param[in] fn callback to obtain success of call. the return value will be the udp port used if successful
    /// @return success of the call
    /// @retval 0 the connection attempt was successful
    /// @retval -1 the connection attempt was not successful
     virtual int Connect(const char* ipAddress, unsigned int port, ClariusReturnFn fn) = 0;

    /// disconnects from an existing connection
    /// @param[in] fn callback to obtain success of call
    /// @return success of the call
    /// @retval 0 the disconnect to the specified connection was successful
    /// @retval -1 the disconnect was unsuccessful
     virtual int Disconnect(ClariusReturnFn fn) = 0;

    /// retrieves the current connected state of the module
    /// @return the connected state of the module
    /// @retval 0 there is currently no connection
    /// @retval 1 there is currently a connection
    /// @retval -1 the module is not initialized
     virtual int IsConnected() = 0;

    /// retrieves the current probe information
    /// @param[out] info the probe information
    /// @return success of the call
    /// @retval 0 the information was retrieved
    /// @retval -1 the information could not be retrieved
     virtual int ProbeInfo(ClariusProbeInfo* info) = 0;

    /// sets the dimensions of the output display for scan conversion
    /// @param[in] w the number of pixels in the horizontal direction
    /// @param[in] h the number of pixels in the vertical direction
    /// @return success of the call
    /// @retval 0 the output size was successfully programmed
    /// @retval -1 the output size could not be set
    /// @note the output will always result in a 1:1 pixel ratio, depending on geometry of scanning array, and parameters
    ///       the frame will have various sizes of black borders around the image
     virtual int SetOutputSize(int w, int h) = 0;

    /// sets a flag to separate overlays into separate images, for example if color/power Doppler or strain
    /// imaging is enabled, two callbacks will be generated, one with the greyscale frame, and the other with the overlay
    /// @param[in] en the enable flag for separating overlays
    /// @return success of the call
    /// @retval 0 the flag was successfully programmed
    /// @retval -1 the flag could not be set
     virtual int SeparateOverlays(int en) = 0;

    /// sets the format for processed images, by default the format will be raw argb
    /// @param[in] format the format of the image (see definitions above)
    /// @return success of the call
    /// @retval 0 the format was successfully set
    /// @retval -1 the format could not be set
     virtual int SetFormat(int format) = 0;

    /// sets the callback for when new raw images are acquired and streamed to the caster
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetRawImageFn(ClariusNewRawImageFn fn) = 0;

    /// sets the callback for when new processed images are acquired and streamed to the caster
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetProcessedImageFn(ClariusNewProcessedImageFn fn) = 0;

    /// sets the callback for when new spectral images are acquired and streamed to the caster
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetSpectralImageFn(ClariusNewSpectralImageFn fn) = 0;

    /// sets the callback for when there is a change in the freeze state
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetFreezeFn(ClariusFreezeFn fn) = 0;

    /// sets the callback for when there is a button press
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetButtonFn(ClariusButtonFn fn) = 0;

    /// sets the callback for when there is a change in the readback progress
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetProgressFn(ClariusProgressFn fn) = 0;

    /// sets the callback for when an error occurs
    /// @param[in] fn a pointer to the callback function
    /// @return success of the call
    /// @retval 0 the callback function was successfully set
    /// @retval -1 the callback function could not be set
     virtual int SetErrorFn(ClariusErrorFn fn) = 0;

    /// makes a request for raw data from the probe
    /// @param[in] start the first frame to request, as determined by timestamp in nanoseconds, set to 0 along with end to requets all data in buffer
    /// @param[in] end the last frame to request, as determined by timestamp in nanoseconds, set to 0 along with start to requets all data in buffer
    /// @param[in] fn callback to obtain the raw data size result, -1 if the request failed, 0 if no raw data exists, otherwise the raw data size
    /// @return success of the call
    /// @retval 0 the request was successfully made
    /// @retval -1 the request could not be made
    /// @note the probe must be frozen and in a raw data buffering mode in order for the call to succeed
     virtual int RequestRawData(long long int start, long long int end, ClariusReturnFn fn) = 0;

    /// retrieves raw data from a previous request
    /// @param[out] data a pointer to a buffer that has been allocated to read the raw data into, this must be pre-allocated with
    ///             the size returned from a previous call to clariusRequestRawData
    /// @param[in] fn callback to obtain success of call, upon returning 0, the data pointer can be accessed for the size resulting from the raw data request
    /// @return success of the call
    /// @retval 0 the data was successfully read into the buffer
    /// @retval -1 the data could not be read
    /// @note the probe must be frozen and a successful call to clariusRequestRawData must have taken place in order for the call to succeed
     virtual int ReadRawData(void** data, ClariusReturnFn fn) = 0;

    /// performs a user function on a connected probe
    /// @param[in] cmd the user command to run
    /// @param[in] val the value to set if the function supports setting of values
    ///            USER_FN_SET_DEPTH supports setting depth in cm
    ///            USER_FN_SET_GAIN supports setting gain in %
    /// @param[in] fn callback to obtain success of call
    /// @return success of the call
    /// @retval 0 the call was successful
    /// @retval -1 the call was not successful
     virtual int UserFunction(int cmd, double val, ClariusReturnFn fn) = 0;
};

} // End namespace fast
