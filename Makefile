include $(DEVKITARM)/3ds_rules

TARGET		:= tiny.3gx

SRC			:= start.s
BUILD		:= build
LD			:= $(CC)

ifneq ($(BUILD),$(notdir $(CURDIR)))

export VPATH	:= $(CURDIR)
export DEPSDIR	:= $(CURDIR)/$(BUILD)
export OFILES	:= $(SRC:.s=.o)
export LDFLAGS	:= -T $(CURDIR)/3gx.ld -Wl,--gc-sections

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $@ -f $(CURDIR)/Makefile

clean:
	@rm -rf $(BUILD) $(TARGET)

re: clean all

else

$(TARGET): $(OFILES)

.PRECIOUS: %.elf

%.3gx: %.elf
	@echo creating $@
	@3gxtool -d -s $(word 1, $^) /dev/null ../$@

-include $(OFILES:.o=.d)

endif