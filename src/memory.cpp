#include "memory.hpp"

#if defined(_WIN32)
#include <windows.h>
#include <psapi.h>

#elif defined(__unix__) || defined(__unix) || defined(unix) || (defined(__APPLE__) && defined(__MACH__))
#include <unistd.h>
#include <sys/resource.h>

#if defined(__APPLE__) && defined(__MACH__)
#include <mach/mach.h>

#elif (defined(_AIX) || defined(__TOS__AIX__)) || (defined(__sun__) || defined(__sun) || defined(sun) && (defined(__SVR4) || defined(__svr4__)))
#include <fcntl.h>
#include <procfs.h>

#elif defined(__linux__) || defined(__linux) || defined(linux) || defined(__gnu_linux__)
#include <stdio.h>

#endif

#else
#error "Unknown OS."
#endif

#include <cstdint>

#if defined(HX_LINUX) || defined(HX_MACOS)
#include "sys/types.h"
#endif

#ifdef HX_LINUX
#include "stdlib.h"
#include "string.h"
int parseLine(char *line)
{
    // This assumes that a digit will be found and the line ends in " Kb".
    int i = strlen(line);
    const char *p = line;
    while (*p < '0' || *p > '9')
        p++;
    line[i - 3] = '\0';
    i = atoi(p);
    return i;
}
#elif HX_MACOS
#include "sysctl.h"
#endif



size_t hxhardware::getSystemTotalVirtualMemory()
{
#ifdef HX_WINDOWS
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);
    return (size_t)memInfo.ullTotalPageFile;
#elif HX_LINUX
    struct sysinfo memInfo;

    sysinfo(&memInfo);
    long long totalVirtualMem = memInfo.totalram;
    // Add other values in next statement to avoid int overflow on right hand side...
    totalVirtualMem += memInfo.totalswap;
    totalVirtualMem *= memInfo.mem_unit;
    return totalVirtualMem;
#elif HX_MACOS
    struct statfs stats;
    if (0 == statfs("/", &stats))
    {
        return (size_t)stats.f_bsize * stats.f_bfree;
    }
    return 0;
#else
    return 0;
#endif
}

size_t hxhardware::getSystemVirtualMemoryUsage()
{
#ifdef HX_WINDOWS
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);
    size_t usage = (memInfo.ullTotalPageFile - memInfo.ullAvailPageFile);
    if (usage > systemVirtualMemoryPeak)
    {
        systemVirtualMemoryPeak = usage;
    }
    return usage;
#elif HX_LINUX
    struct sysinfo memInfo;
    sysinfo(&memInfo);
    long long totalVirtualMem = memInfo.totalram;
    long long virtualMemUsed = memInfo.totalram - memInfo.freeram;
    // Add other values in next statement to avoid int overflow on right hand side...
    virtualMemUsed += memInfo.totalswap - memInfo.freeswap;
    virtualMemUsed *= memInfo.mem_unit;
    if (virtualMemUsed > systemVirtualMemoryPeak)
    {
        systemVirtualMemoryPeak = virtualMemUsed;
    }
    return virtualMemUsed;
#elif HX_MACOS
    xsw_usage vmusage = {0};
    size_t size = sizeof(vmusage);
    if (sysctlbyname("vm.swapusage", &vmusage, &size, NULL, 0) != 0)
    {
        perror("unable to get swap usage by calling sysctlbyname(\"vm.swapusage\",...)");
    }
    if (size > systemVirtualMemoryPeak)
    {
        systemVirtualMemoryPeak = size;
    }
    return (size_t)(size);
#else
    return 0;
#endif
}

size_t hxhardware::getSystemPeakVirtualMemoryUsage()
{
    return systemVirtualMemoryPeak;
}

size_t hxhardware::getProcessVirtualMemoryUsage()
{
#ifdef HX_WINDOWS
    PROCESS_MEMORY_COUNTERS_EX pmc;
    GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS *)&pmc, sizeof(pmc));
    size_t usage = pmc.PrivateUsage;
    if (usage > processVirtualMemoryPeak)
    {
        processVirtualMemoryPeak = usage;
    }
    return usage;
#elif HX_LINUX
    FILE *file = fopen("/proc/self/status", "r");
    int result = -1;
    char line[128];

    while (fgets(line, 128, file) != NULL)
    {
        if (strncmp(line, "VmSize:", 7) == 0)
        {
            result = parseLine(line);
            break;
        }
    }
    fclose(file);
    return (size_t)(result / 1000);
#elif HX_MACOS
    struct task_basic_info t_info;
    mach_msg_type_number_t t_info_count = TASK_BASIC_INFO_COUNT;

    if (KERN_SUCCESS != task_info(mach_task_self(),
                                  TASK_BASIC_INFO, (task_info_t)&t_info,
                                  &t_info_count))
    {
        return -1;
    }
    if (t_info.virtual_size > processVirtualMemoryPeak)
    {
        processVirtualMemoryPeak = t_info.virtual_size;
    }
    return (size_t)t_info.virtual_size;
#else
    return 0;
#endif
}

size_t hxhardware::getProcessPeakVirtualMemoryUsage()
{
    return processVirtualMemoryPeak;
}

size_t hxhardware::getSystemTotalPhysicalMemory()
{
#ifdef HX_WINDOWS
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);
    return memInfo.ullTotalPhys;
#elif HX_LINUX
    struct sysinfo memInfo;

    sysinfo(&memInfo);
    long long totalPhysMem = memInfo.totalram;
    // Multiply in next statement to avoid int overflow on right hand side...
    totalPhysMem *= memInfo.mem_unit;
    return totalPhysMem;
#elif HX_MACOS
    int mib[2];
    int64_t physical_memory;
    mib[0] = CTL_HW;
    mib[1] = HW_MEMSIZE;
    length = sizeof(int64_t);
    sysctl(mib, 2, &physical_memory, &length, NULL, 0);
    return physical_memory;
#else
    return 0;
#endif
}

size_t hxhardware::getSystemPhysicalMemoryUsage()
{
#ifdef HX_WINDOWS
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);
    size_t usage = memInfo.ullTotalPhys - memInfo.ullAvailPhys;
    if (usage > systemPhysicalMemoryPeak)
    {
        systemPhysicalMemoryPeak = usage;
    }
    return usage;
#elif HX_LINUX
    struct sysinfo memInfo;

    sysinfo(&memInfo);
    // Multiply in next statement to avoid int overflow on right hand side...
    long long physMemUsed = memInfo.totalram - memInfo.freeram;
    // Multiply in next statement to avoid int overflow on right hand side...
    physMemUsed *= memInfo.mem_unit;
    if (physMemUsed > systemPhysicalMemoryPeak)
    {
        systemPhysicalMemoryPeak = physMemUsed;
    }
    return physMemUsed;
#elif HX_MACOS
    int mib[2];
    int64_t physical_memory;
    mib[0] = CTL_HW;
    mib[1] = HW_MEMSIZE;
    length = sizeof(int64_t);
    sysctl(mib, 2, &physical_memory, &length, NULL, 0);
    if (physical_memory > systemPhysicalMemoryPeak)
    {
        systemPhysicalMemoryPeak = physical_memory;
    }
    return physical_memory;
#else
    return 0;
#endif
}

size_t hxhardware::getSystemPeakPhysicalMemoryUsage()
{
    return systemPhysicalMemoryPeak;
}

/**
 * Returns the peak (maximum so far) resident set size (physical
 * memory use) measured in bytes, or zero if the value cannot be
 * determined on this OS.
 */
size_t hxhardware::getProcessPeakPhysicalMemoryUsage()
{
#if defined(_WIN32)
    /* Windows -------------------------------------------------- */
    PROCESS_MEMORY_COUNTERS info;
    GetProcessMemoryInfo(GetCurrentProcess(), &info, sizeof(info));
    return (size_t)info.PeakWorkingSetSize;

#elif (defined(_AIX) || defined(__TOS__AIX__)) || (defined(__sun__) || defined(__sun) || defined(sun) && (defined(__SVR4) || defined(__svr4__)))
    /* AIX and Solaris ------------------------------------------ */
    struct psinfo psinfo;
    int fd = -1;
    if ((fd = open("/proc/self/psinfo", O_RDONLY)) == -1)
        return (size_t)0L; /* Can't open? */
    if (read(fd, &psinfo, sizeof(psinfo)) != sizeof(psinfo))
    {
        close(fd);
        return (size_t)0L; /* Can't read? */
    }
    close(fd);
    return (size_t)(psinfo.pr_rssize * 1024L);

#elif defined(__unix__) || defined(__unix) || defined(unix) || (defined(__APPLE__) && defined(__MACH__))
    /* BSD, Linux, and OSX -------------------------------------- */
    struct rusage rusage;
    getrusage(RUSAGE_SELF, &rusage);
#if defined(__APPLE__) && defined(__MACH__)
    return (size_t)rusage.ru_maxrss;
#else
    return (size_t)(rusage.ru_maxrss * 1024L);
#endif

#else
    /* Unknown OS ----------------------------------------------- */
    return (size_t)0L; /* Unsupported. */
#endif
}

/**
 * Returns the current resident set size (physical memory use) measured
 * in bytes, or zero if the value cannot be determined on this OS.
 */
size_t hxhardware::getProcessPhysicalMemoryUsage()
{
#if defined(_WIN32)
    /* Windows -------------------------------------------------- */
    PROCESS_MEMORY_COUNTERS info;
    GetProcessMemoryInfo(GetCurrentProcess(), &info, sizeof(info));
    return (size_t)info.WorkingSetSize;

#elif defined(__APPLE__) && defined(__MACH__)
    /* OSX ------------------------------------------------------ */
    struct mach_task_basic_info info;
    mach_msg_type_number_t infoCount = MACH_TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO,
                  (task_info_t)&info, &infoCount) != KERN_SUCCESS)
        return (size_t)0L; /* Can't access? */
    return (size_t)info.resident_size;

#elif defined(__linux__) || defined(__linux) || defined(linux) || defined(__gnu_linux__)
    /* Linux ---------------------------------------------------- */
    long rss = 0L;
    FILE *fp = NULL;
    if ((fp = fopen("/proc/self/statm", "r")) == NULL)
        return (size_t)0L; /* Can't open? */
    if (fscanf(fp, "%*s%ld", &rss) != 1)
    {
        fclose(fp);
        return (size_t)0L; /* Can't read? */
    }
    fclose(fp);
    return (size_t)rss * (size_t)sysconf(_SC_PAGESIZE);

#else
    /* AIX, BSD, Solaris, and Unknown OS ------------------------ */
    return (size_t)0L; /* Unsupported. */
#endif
}