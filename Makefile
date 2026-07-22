THEOS_DEVICE_IP = 192.168.1.65

ifneq ($(THEOS_PACKAGE_SCHEME),)
ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
else
ARCHS = armv7 arm64 arm64e
TARGET = iphone:clang:latest:7.0
endif

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DaemonDisabler

DaemonDisabler_FILES = Tweak.x
DaemonDisabler_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += daemondisablerprefs
SUBPROJECTS += launchctl_wrapper
include $(THEOS_MAKE_PATH)/aggregate.mk
