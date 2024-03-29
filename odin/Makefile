OC = odin
BUILD_DIR = build
SRC_DIR = src
TARGET := $(BUILD_DIR)/raymond
OFLAGS := -out:$(TARGET) -vet
ODIN_FILES := $(SRC_DIR)/main.odin

ifeq ($(DEBUG),1)
	OFLAGS += -o:none -debug
else
	OFLAGS += -o:speed
endif

default: all

all: clean $(TARGET)

clean:
	@rm -rf build

$(TARGET): $(ODIN_FILES)
	@mkdir -p $(BUILD_DIR)
	@$(OC) build $(SRC_DIR) $(OFLAGS)

.SECONDARY:
.PHONY: all clean default
