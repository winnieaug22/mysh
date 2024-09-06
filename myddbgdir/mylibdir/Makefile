TARGET_LIB = libmylib.a

AR = ar
ARFLAGS = rcs
# Add any other object files to this list below
C_SRCS = mylib.c
C_OBJS = $(patsubst %.c,%.o,$(wildcard $(C_SRCS)))

INCLUDES += -I../
# CFLAGS += -Wall -Wextra -g
# CFLAGS += -DMYDDBG
CFLAGS ?= $(shell echo $(MYCFLAGS))

all: build

build: $(TARGET_LIB)

$(C_OBJS): $(C_SRCS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $(C_SRCS)

$(TARGET_LIB): $(C_OBJS)
	$(AR) $(ARFLAGS) $@ $^

clean:
	rm -f $(TARGET_LIB) *.o

.PHONY: all clean
