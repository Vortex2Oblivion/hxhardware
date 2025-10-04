#pragma once

#include <cstddef>

namespace hxprocessinfo
{

    void init();
    double getCpuUsage();
    size_t getPeakRSS();
    size_t getCurrentRSS();
}