#pragma once

namespace hxhardware
{
    double getSystemTotalGPUUsage();
    double getSystemTotalPeakGPUUsage();

    static double peakSystemGPU = 0;
} // namespace hxhardware
