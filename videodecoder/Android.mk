LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(TARGET_HAS_ISV),true)
LOCAL_CFLAGS += -DTARGET_HAS_ISV
endif

LOCAL_SRC_FILES := \
    VideoDecoderHost.cpp \
    VideoDecoderBase.cpp \
    VideoDecoderWMV.cpp \
    VideoDecoderMPEG4.cpp \
    VideoDecoderMPEG2.cpp \
    VideoDecoderAVC.cpp \
    VideoDecoderTrace.cpp

# VideoDecoderHost.cpp includes VideoDecoderWMV.h,
# which hides overloaded virtual function parseBuffer.
LOCAL_CLANG_CFLAGS += -Wno-overloaded-virtual

LOCAL_HEADER_LIBRARIES := intel_vbp_mix_headers wrs_omxil_core_headers
ifeq ($(USE_INTEL_SECURE_AVC),true)
LOCAL_CFLAGS += -DUSE_INTEL_SECURE_AVC
LOCAL_SRC_FILES += securevideo/$(TARGET_BOARD_PLATFORM)/VideoDecoderAVCSecure.cpp
LOCAL_C_INCLUDES += $(LOCAL_PATH)/securevideo/$(TARGET_BOARD_PLATFORM)
LOCAL_CFLAGS += -DUSE_INTEL_SECURE_AVC
endif

PLATFORM_USE_GEN_HW := \
    baytrail \
    cherrytrail

ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(PLATFORM_USE_GEN_HW)),)
    LOCAL_CFLAGS += -DUSE_AVC_SHORT_FORMAT -DUSE_GEN_HW
endif


PLATFORM_USE_HYBRID_DRIVER := \
    baytrail

ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(PLATFORM_USE_HYBRID_DRIVER)),)
    LOCAL_CFLAGS += -DUSE_HYBRID_DRIVER
endif

PLATFORM_SUPPORT_SLICE_HEADER_PARSER := \
    merrifield \
    moorefield

ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(PLATFORM_SUPPORT_SLICE_HEADER_PARSER)),)
    LOCAL_CFLAGS += -DUSE_SLICE_HEADER_PARSING
endif

LOCAL_SHARED_LIBRARIES := \
    liblog \
    libcutils \
    libva \
    libva-android \
    libva-tpi \
    libdl

LOCAL_EXPORT_HEADER_LIBRARY_HEADERS := intel_libmix_headers
LOCAL_CFLAGS += -Werror
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libva_videodecoder

ifeq ($(USE_HW_VP8),true)
LOCAL_SRC_FILES += VideoDecoderVP8.cpp
LOCAL_CFLAGS += -DUSE_HW_VP8
endif

# TODO: Fix this.
LOCAL_CFLAGS += -Wno-error=unused-variable

include $(BUILD_SHARED_LIBRARY)
