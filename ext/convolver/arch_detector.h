#ifndef ARCH_DETECTOR_H
#define ARCH_DETECTOR_H

#if defined(__x86_64__) || defined(_M_X64)
    #define ARCH_X86
#elif defined(i386) || defined(__i386__) || defined(__i386) || defined(_M_IX86)
    #define ARCH_X86
#else
    #define ARCH_ARM
#endif

#endif