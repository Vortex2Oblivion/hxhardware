#pragma once

namespace hxhardware
{
    void init();

    void initSystem();

    void initProcess();

    double getSystemTotalCPUUsage();
    double getSystemTotalPeakCPUUsage();

    double getProcessCPUUsage();
    double getProcessPeakCPUUsage();

    static double peakProcessCPU;
    static double peakSystemCPU;
}