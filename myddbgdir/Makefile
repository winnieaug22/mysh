TARGET = tt

# Add any other object files to this list below
C_SRCS = tt.c
C_OBJS = $(patsubst %.c,%.o,$(wildcard $(C_SRCS)))

# INCLUDES += -I$(MYLIBA_DIR)
CFLAGS += -Wall -Wextra -g
CFLAGS += -DMYDDBG

# MYLIBA_DIR = librealupdate
# LDFLAGS += -L$(MYLIBA_DIR) -lrealupdate

all: build

build: $(TARGET)

$(C_OBJS): $(C_SRCS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $(C_SRCS)

$(TARGET): $(C_OBJS)
	$(CC) -o $@ $(C_OBJS) $(LDFLAGS)
clean:
	rm -f $(TARGET) *.o

.PHONY: all clean
