#include "ClariusCastImpl.hpp"
#include <cast/cast.h>

namespace fast {
     int ClariusCastImpl::Init(int argc,
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
    ) {
         return cusCastInit(argc, argv, dir, newProcessedImage, newRawImage, newSpectralImage, freeze, btn, progress, err, width, height);
     }

     int ClariusCastImpl::Destroy() { 
        return cusCastDestroy();
     }

     int ClariusCastImpl::Connect(const char* ipAddress, unsigned int port, ClariusReturnFn fn) {
        return cusCastConnect(ipAddress, port, fn);
     }

     int ClariusCastImpl::Disconnect(ClariusReturnFn fn) {
        return cusCastDisconnect(fn);
     }

     int ClariusCastImpl::IsConnected() { 
        return cusCastIsConnected();
     }

     int ClariusCastImpl::ProbeInfo(ClariusProbeInfo* info) {
         return cusCastProbeInfo(info);
     }

     int ClariusCastImpl::SetOutputSize(int w, int h) { 
        return cusCastSetOutputSize(w, h);
     }

     int ClariusCastImpl::SeparateOverlays(int en) {
        return cusCastSeparateOverlays(en);
     }

     int ClariusCastImpl::SetFormat(int format) {
        return cusCastSetFormat(format);
     }

     int ClariusCastImpl::SetRawImageFn(ClariusNewRawImageFn fn) {
        return cusCastSetRawImageFn(fn);
     }

     int ClariusCastImpl::SetProcessedImageFn(ClariusNewProcessedImageFn fn) {
        return cusCastSetProcessedImageFn(fn);
     }

     int ClariusCastImpl::SetSpectralImageFn(ClariusNewSpectralImageFn fn) {
        return cusCastSetSpectralImageFn(fn);
     }

     int ClariusCastImpl::SetFreezeFn(ClariusFreezeFn fn) {
        return cusCastSetFreezeFn(fn);
     }

     int ClariusCastImpl::SetButtonFn(ClariusButtonFn fn) {
        return cusCastSetButtonFn(fn);
     }

     int ClariusCastImpl::SetProgressFn(ClariusProgressFn fn) {
        return cusCastSetProgressFn(fn);
     }

     int ClariusCastImpl::SetErrorFn(ClariusErrorFn fn) {
        return cusCastSetErrorFn(fn);
     }

     int ClariusCastImpl::RequestRawData(long long int start, long long int end, ClariusReturnFn fn) {
        return cusCastRequestRawData(start, end, fn);
     }

     int ClariusCastImpl::ReadRawData(void** data, ClariusReturnFn fn) {
        return cusCastReadRawData(data, fn);
     }

     int ClariusCastImpl::UserFunction(int cmd, double val, ClariusReturnFn fn) {
        return cusCastUserFunction(cmd, val, fn);
     }
}
