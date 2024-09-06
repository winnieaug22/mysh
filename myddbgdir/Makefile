TARGET = tt

# Add any other object files to this list below
C_SRCS = tt.c
C_OBJS = $(patsubst %.c,%.o,$(wildcard $(C_SRCS)))

MYLIBA_DIR = mylibdir/
MYLIBA = $(MYLIBA_DIR)libmylib.a
LDFLAGS += -L$(MYLIBA_DIR) -lmylib

INCLUDES += -I$(MYLIBA_DIR)
CFLAGS += -Wall -Wextra -g
CFLAGS += -DMYDDBG
export MYCFLAGS=$(CFLAGS)


all: build

build: $(TARGET)

$(C_OBJS): $(C_SRCS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $(C_SRCS)

$(TARGET): $(C_OBJS) $(MYLIBA)
	$(CC) -o $@ $(C_OBJS) $(LDFLAGS)

$(MYLIBA):
	$(MAKE) -C $(MYLIBA_DIR)

clean:
	rm -f $(TARGET) *.o
	$(MAKE) -C $(MYLIBA_DIR) clean

.PHONY: all clean
