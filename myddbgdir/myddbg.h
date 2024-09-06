#ifndef MYDDBG_H
#define MYDDBG_H

#ifdef MYDDBG
    #define MYDDBG_P 1
#else
    #define MYDDBG_P 0
#endif

#define myddbg_p(fmt, ...) \
        do { if (MYDDBG_P) fprintf(stderr, "%s:%d:%s(): " fmt, __FILE__, \
                                __LINE__, __func__, __VA_ARGS__); } while (0)

#endif /* MYDDBG_H */
