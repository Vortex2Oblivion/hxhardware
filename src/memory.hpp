#pragma once

#include <cstddef>
#include <cstdint>


namespace hxprocessinfo
{

    uint64_t getSystemTotalVirtualMemory();
    uint64_t getSystemVirtualMemoryUsage();
    uint64_t getSystemTotalPhysicalMemory();
    uint64_t getSystemPhysicalMemoryUsage();
    size_t getProcessPhysicalMemoryUsage();
    size_t getProcessPeakPhysicalMemoryUsage();
    uint64_t getProcessVirtualMemoryUsage();
}