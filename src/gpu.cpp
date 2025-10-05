#include "gpu.hpp"

// https://gist.github.com/fecf/2103a82afc76b5c88829c4383944a5aa

#ifdef HX_WINDOWS
#include <chrono>
#include <iostream>
#include <regex>
#include <vector>

#include <pdh.h>
#include <pdhmsg.h>
#include <strsafe.h>
#include <tchar.h>

#pragma comment(lib, "pdh.lib")

// https://docs.microsoft.com/en-us/windows/win32/perfctrs/enumerating-process-objects
std::vector<std::pair<int, int>> GetGPURunningTimeProcess()
{
    std::vector<std::pair<int, int>> ret;

    DWORD counterListSize = 0;
    DWORD instanceListSize = 0;
    DWORD dwFlags = 0;
    const auto COUNTER_OBJECT = TEXT("GPU Engine");
    PDH_STATUS status = ERROR_SUCCESS;
    status = PdhEnumObjectItems(nullptr, nullptr, COUNTER_OBJECT, nullptr,
                                &counterListSize, nullptr, &instanceListSize,
                                PERF_DETAIL_WIZARD, dwFlags);
    if (status != PDH_MORE_DATA)
    {
        throw std::runtime_error("failed PdhEnumObjectItems()");
    }

    std::vector<TCHAR> counterList(counterListSize);
    std::vector<TCHAR> instanceList(instanceListSize);
    status = ::PdhEnumObjectItems(
        nullptr, nullptr, COUNTER_OBJECT, counterList.data(), &counterListSize,
        instanceList.data(), &instanceListSize, PERF_DETAIL_WIZARD, dwFlags);
    if (status != ERROR_SUCCESS)
    {
        throw std::runtime_error("failed PdhEnumObjectItems()");
    }

    for (TCHAR *pTemp = instanceList.data(); *pTemp != 0;
         pTemp += _tcslen(pTemp) + 1)
    {
        if (::_tcsstr(pTemp, TEXT("engtype_3D")) == NULL)
        {
            continue;
        }

        TCHAR buffer[1024];
        ::StringCchCopy(buffer, 1024, TEXT("\\GPU Engine("));
        ::StringCchCat(buffer, 1024, pTemp);
        ::StringCchCat(buffer, 1024, TEXT(")\\Running time"));

        HQUERY hQuery = NULL;
        status = ::PdhOpenQuery(NULL, 0, &hQuery);
        if (status != ERROR_SUCCESS)
        {
            continue;
        }

        HCOUNTER hCounter = NULL;
        status = ::PdhAddCounter(hQuery, buffer, 0, &hCounter);
        if (status != ERROR_SUCCESS)
        {
            continue;
        }

        status = ::PdhCollectQueryData(hQuery);
        if (status != ERROR_SUCCESS)
        {
            continue;
        }

        status = ::PdhCollectQueryData(hQuery);
        if (status != ERROR_SUCCESS)
        {
            continue;
        }

        const DWORD dwFormat = PDH_FMT_LONG;
        PDH_FMT_COUNTERVALUE ItemBuffer;
        status =
            ::PdhGetFormattedCounterValue(hCounter, dwFormat, nullptr, &ItemBuffer);
        if (ERROR_SUCCESS != status)
        {
            continue;
        }

        if (ItemBuffer.longValue > 0)
        {
#ifdef _UNICODE
            std::wregex re(TEXT("pid_(\\d+)"));
            std::wsmatch sm;
            std::wstring str = pTemp;
#else
            std::regex re(TEXT("pid_(\\d+)"));
            std::smatch sm;
            std::string str = pTemp;
#endif
            if (std::regex_search(str, sm, re))
            {
                int pid = std::stoi(sm[1]);
                ret.push_back({pid, ItemBuffer.longValue});
            }
        }

        ::PdhCloseQuery(hQuery);
    }

    return ret;
}

int64_t GetGPURunningTimeTotal()
{
    int64_t total = 0;
    std::vector<std::pair<int, int>> list = GetGPURunningTimeProcess();
    for (const std::pair<int, int> &v : list)
    {
        if (v.second > 0)
        {
            total += v.second;
        }
    }
    return total;
}
#endif

double hxhardware::getSystemTotalGPUUsage()
{
#ifdef HX_WINDOWS
    static std::chrono::steady_clock::time_point prev_called =
        std::chrono::steady_clock::now();
    static int64_t prev_running_time = GetGPURunningTimeTotal();

    std::chrono::steady_clock::time_point now = std::chrono::steady_clock::now();
    std::chrono::steady_clock::duration elapsed = now - prev_called;

    int64_t elapsed_sec =
        std::chrono::duration_cast<std::chrono::nanoseconds>(elapsed).count();
    int64_t running_time = GetGPURunningTimeTotal();

    double percentage =
        (double)(running_time - prev_running_time) / elapsed_sec * 100;
    // printf("percent = (%lld - %lld) / %lld * 100 = %f\n", running_time,
    // prev_running_time, elapsed_sec, percentage);

    prev_called = now;
    prev_running_time = running_time;

    if (percentage > 1.0)
        percentage = 1.0;
    else if (percentage < 0.0)
        percentage = 0.0;

    if (percentage * 100 > peakSystemGPU)
    {
        peakSystemGPU = percentage * 100;
    }
    
    return percentage * 100;
#else
    return 0;
#endif
}

double hxhardware::getSystemTotalPeakGPUUsage()
{
    return peakSystemGPU;
}