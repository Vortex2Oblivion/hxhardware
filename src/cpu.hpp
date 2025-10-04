#pragma once

namespace hxprocessinfo
{
    void init();

    void initSystem();

    void initProcess();

    double getSystemTotalCPUUsage();
    double getProcessCPUUsage();
}