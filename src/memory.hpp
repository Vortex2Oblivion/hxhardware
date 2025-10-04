#pragma once

#include <cstddef>
#include <cstdint>

namespace hxprocessinfo
{

    size_t getSystemTotalVirtualMemory();
    size_t getSystemVirtualMemoryUsage();
    size_t getSystemPeakVirtualMemoryUsage();

    size_t getSystemTotalPhysicalMemory();
    size_t getSystemPhysicalMemoryUsage();
    size_t getSystemPeakPhysicalMemoryUsage();

    size_t getProcessPhysicalMemoryUsage();
    size_t getProcessPeakPhysicalMemoryUsage();

    size_t getProcessVirtualMemoryUsage();
    size_t getProcessPeakVirtualMemoryUsage();

    static size_t systemVirtualMemoryPeak = 0;
    static size_t processVirtualMemoryPeak = 0;
    static size_t systemPhysicalMemoryPeak = 0;
}