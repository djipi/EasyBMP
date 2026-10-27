	
# PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif
ifdef MINGW_PREFIX
	PREFIX := $(MINGW_PREFIX)
endif

PKGCONFIG_DIR ?= $(PREFIX)/lib/pkgconfig
PC_FILE = $(PKGCONFIG_DIR)/EasyBMP.pc

BUILD_DIR = build

all: $(BUILD_DIR)/EasyBMP.a

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/EasyBMP.a: $(BUILD_DIR)/EasyBMP.o
	@echo -e "\033[01;33m***\033[00;32m Building the library...\033[00m"
	@ar -r $@ $<
	
$(BUILD_DIR)/EasyBMP.o: EasyBMP.cpp | $(BUILD_DIR)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	@gcc -Ofast -Wall -c -o $@ $<

clean:
	@echo -e "\033[01;33m***\033[00;32m Cleaning...\033[00m"
	@rm $(BUILD_DIR)/EasyBMP.a $(BUILD_DIR)/EasyBMP.o

pkgconfig:
	@echo -e "\033[01;33m***\033[00;32m Create pkgconfig...\033[00m"
	@mkdir -p $(PKGCONFIG_DIR)
	@echo "prefix=$(PREFIX)" > $(PC_FILE)
	@echo "exec_prefix=\$${prefix}" >> $(PC_FILE)
	@echo "libdir=\$${exec_prefix}/lib" >> $(PC_FILE)
	@echo "includedir=\$${prefix}/include/EasyBMP" >> $(PC_FILE)
	@echo "" >> $(PC_FILE)
	@echo "Name: EasyBMP" >> $(PC_FILE)
	@echo "Description: EasyBMP image library" >> $(PC_FILE)
	@echo "Version: 1.06" >> $(PC_FILE)
	@echo "Libs: -L\$${libdir} -lEasyBMP" >> $(PC_FILE)
	@echo "Cflags: -I\$${includedir}" >> $(PC_FILE)

uninstall:
	@echo -e "\033[01;33m***\033[00;32m Uninstalling the library...\033[00m"
	@rm $(DESTDIR)$(PREFIX)/lib/libEasyBMP.a
	@rm -rf $(DESTDIR)$(PREFIX)/include/EasyBMP
	@rm $(PKGCONFIG_DIR)/EasyBMP.pc

install: $(BUILD_DIR)/EasyBMP.a pkgconfig 
	@echo -e "\033[01;33m***\033[00;32m Installing the library...\033[00m"
	install -d $(DESTDIR)$(PREFIX)/lib/
	install -m 644 $(BUILD_DIR)/EasyBMP.a $(DESTDIR)$(PREFIX)/lib/libEasyBMP.a
	install -d $(DESTDIR)$(PREFIX)/include/EasyBMP/
	install -m 644 EasyBMP.h $(DESTDIR)$(PREFIX)/include/EasyBMP/
	install -m 644 EasyBMP_DataStructures.h $(DESTDIR)$(PREFIX)/include/EasyBMP/
	install -m 644 EasyBMP_BMP.h $(DESTDIR)$(PREFIX)/include/EasyBMP/
	install -m 644 EasyBMP_VariousBMPutilities.h $(DESTDIR)$(PREFIX)/include/EasyBMP/
