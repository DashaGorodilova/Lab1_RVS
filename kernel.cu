﻿#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include "wb.h"

int main(int argc, char** argv)
{
    int deviceCount;
    wbArg_read(argc, argv);
    cudaGetDeviceCount(&deviceCount);
    wbTime_start(GPU, "Getting GPU Data."); //@@ Запуск таймера

    for (int dev = 0; dev < deviceCount; dev++)
    {
        cudaDeviceProp deviceProp;

        cudaGetDeviceProperties(&deviceProp, dev);

        if (dev == 0) {
            if (deviceProp.major == 9999 && deviceProp.minor == 9999) {
                wbLog(TRACE, "No CUDA GPU has been detected");
                return -1;
            }
            else if (deviceCount == 1) {
                //@@ WbLog предоставляет API логгирования (схожее с Log4J).
                //@@ Функции логгирования wbLog принимает уровень
                //@@ логгирования, который может быть одним из
                //@@ OFF, FATAL, ERROR, WARN, INFO, DEBUG или TRACE, и
                //@@ сообщение, которое нужно напечатать.
                wbLog(TRACE, "There is 1 device supporting CUDA");
            }
            else {
                wbLog(TRACE, "There are ", deviceCount,
                    " devices supporting CUDA");
            }
        }

        wbLog(TRACE, "Device ", dev, " name: ", deviceProp.name);
        wbLog(TRACE, " Computational Capabilities: ", deviceProp.major, ".", deviceProp.minor);
        wbLog(TRACE, " Maximum global memory size: ", deviceProp.totalGlobalMem);
        wbLog(TRACE, " Maximum constant memory size: ", deviceProp.totalConstMem);
        wbLog(TRACE, " Maximum shared memory size per block: ", deviceProp.sharedMemPerBlock);
        wbLog(TRACE, " Maximum block dimensions: ", deviceProp.maxThreadsDim[0], " x ", deviceProp.maxThreadsDim[1], " x ", deviceProp.maxThreadsDim[2]);
        wbLog(TRACE, " Maximum grid dimensions: ", deviceProp.maxGridSize[0], " x ", deviceProp.maxGridSize[1], " x ", deviceProp.maxGridSize[2]);
        wbLog(TRACE, " Warp size: ", deviceProp.warpSize);
    }

    wbTime_stop(GPU, "Getting GPU Data."); //@@ остановка таймера

    return 0;
}
