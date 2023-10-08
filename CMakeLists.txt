cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

project(nelua-lang C)

################################################################################
# Set target arch type if empty. Visual studio solution generator provides it.
################################################################################
if(NOT CMAKE_VS_PLATFORM_NAME)
    set(CMAKE_VS_PLATFORM_NAME "Win32")
endif()
message("${CMAKE_VS_PLATFORM_NAME} architecture in use")

if(NOT ("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64"
     OR "${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Win32"))
    message(FATAL_ERROR "${CMAKE_VS_PLATFORM_NAME} arch is not supported!")
endif()

################################################################################
# Global configuration types
################################################################################
set(CMAKE_CONFIGURATION_TYPES
    "Debug"
    "Release"
    CACHE STRING "" FORCE
)

################################################################################
# Global compiler options
################################################################################
if(MSVC)
    # remove default flags provided with CMake for MSVC
    set(CMAKE_C_FLAGS "")
    set(CMAKE_C_FLAGS_DEBUG "")
    set(CMAKE_C_FLAGS_RELEASE "")
	
	# Set this option to mimic gcc behavior
	set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

################################################################################
# Global linker options
################################################################################
if(MSVC)
    # remove default flags provided with CMake for MSVC
    set(CMAKE_EXE_LINKER_FLAGS "")
    set(CMAKE_MODULE_LINKER_FLAGS "")
    set(CMAKE_SHARED_LINKER_FLAGS "")
    set(CMAKE_STATIC_LINKER_FLAGS "")
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS}")
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_STATIC_LINKER_FLAGS_DEBUG "${CMAKE_STATIC_LINKER_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS}")
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_STATIC_LINKER_FLAGS_RELEASE "${CMAKE_STATIC_LINKER_FLAGS}")
endif()

################################################################################
# Nuget packages function stub.
################################################################################
function(use_package TARGET PACKAGE VERSION)
    message(WARNING "No implementation of use_package. Create yours. "
                    "Package \"${PACKAGE}\" with version \"${VERSION}\" "
                    "for target \"${TARGET}\" is ignored!")
endfunction()

################################################################################
# Common utils
################################################################################
include(CMake/Utils.cmake)

################################################################################
# Additional Global Settings(add specific info there)
################################################################################
include(CMake/GlobalSettingsInclude.cmake OPTIONAL)

################################################################################
# Use solution folders feature
################################################################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

################################################################################
# Sub-projects
################################################################################



























set(PROJECT_NAME nelua-lang)

################################################################################
# Source groups
################################################################################
set(no_group_source_files
    "docs/404.html"
    "docs/_includes/footer.html"
    "docs/_includes/head.html"
    "docs/_includes/navbar.html"
    "docs/_includes/toc.html"
    "docs/_layouts/default.html"
    "docs/_layouts/docs.html"
    "docs/index.html"
)
source_group("" FILES ${no_group_source_files})

set(Header_Files
    "src/lua/lapi.h"
    "src/lua/lauxlib.h"
    "src/lua/lcode.h"
    "src/lua/lctype.h"
    "src/lua/ldebug.h"
    "src/lua/ldo.h"
    "src/lua/lfunc.h"
    "src/lua/lgc.h"
    "src/lua/ljumptab.h"
    "src/lua/llex.h"
    "src/lua/llimits.h"
    "src/lua/lmem.h"
    "src/lua/lobject.h"
    "src/lua/lopcodes.h"
    "src/lua/lopnames.h"
    "src/lua/lparser.h"
    "src/lua/lprefix.h"
    "src/lua/lstate.h"
    "src/lua/lstring.h"
    "src/lua/ltable.h"
    "src/lua/ltm.h"
    "src/lua/lua.h"
    "src/lua/luaconf.h"
    "src/lua/lualib.h"
    "src/lua/lundump.h"
    "src/lua/lvm.h"
    "src/lua/lzio.h"
    "src/luainit.h"
)
source_group("Header Files" FILES ${Header_Files})

set(Source_Files
    "src/hasher.c"
    "src/lfs.c"
    "src/lpeglabel/lplcap.c"
    "src/lpeglabel/lplcode.c"
    "src/lpeglabel/lplprint.c"
    "src/lpeglabel/lpltree.c"
    "src/lpeglabel/lplvm.c"
    "src/luainit.c"
    "src/onelua.c"
    "src/srpmalloc/srpmalloc.c"
    "src/sys.c"
)
source_group("Source Files" FILES ${Source_Files})

set(ALL_FILES
    ${no_group_source_files}
    ${Header_Files}
    ${Source_Files}
)

################################################################################
# Target
################################################################################
add_library(${PROJECT_NAME} SHARED ${ALL_FILES})

use_props(${PROJECT_NAME} "${CMAKE_CONFIGURATION_TYPES}" "${DEFAULT_CXX_PROPS}")
set_target_properties(${PROJECT_NAME} PROPERTIES
    VS_GLOBAL_KEYWORD "Win32Proj"
)
################################################################################
# Include directories
################################################################################
if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
    target_include_directories(${PROJECT_NAME} PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/src/lua"
    )
elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Win32")
    target_include_directories(${PROJECT_NAME} PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/src/lua"
    )
endif()

################################################################################
# Compile definitions
################################################################################
if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        "$<$<CONFIG:Debug>:"
            "_DEBUG;"
            "_DEBUG"
        ">"
        "$<$<CONFIG:Release>:"
            "NDEBUG;"
            "NDEBUG"
        ">"
        "_WINDOWS;"
        "_USRDLL;"
        "NELUALANG_EXPORTS;"
        "MAXRECLEVEL=400;"
        "LUA_USE_RPMALLOC;"
        "_CRT_SECURE_NO_WARNINGS;"
        "_CRT_NONSTDC_NO_WARNINGS"
    )
elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Win32")
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        "$<$<CONFIG:Debug>:"
            "_DEBUG;"
            "_DEBUG"
        ">"
        "$<$<CONFIG:Release>:"
            "NDEBUG;"
            "NDEBUG"
        ">"
        "WIN32;"
        "LUA_BUILD_AS_DLL;"
        "LUA_CORE;"
        "LUA_LIB;"
        "_WINDOWS;"
        "_USRDLL;"
        "NELUALANG_EXPORTS;"
        "MAXRECLEVEL=400;"
        "LUA_USE_RPMALLOC;"
        "_CRT_SECURE_NO_WARNINGS;"
        "_CRT_NONSTDC_NO_WARNINGS"
    )
endif()

################################################################################
# Compile and link options
################################################################################
if(MSVC)
    if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
        target_compile_options(${PROJECT_NAME} PRIVATE
            /W3;
            ${DEFAULT_CXX_DEBUG_INFORMATION_FORMAT};
            ${DEFAULT_CXX_EXCEPTION_HANDLING}
        )
    elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Win32")
        target_compile_options(${PROJECT_NAME} PRIVATE
            /W3;
            ${DEFAULT_CXX_DEBUG_INFORMATION_FORMAT};
            ${DEFAULT_CXX_EXCEPTION_HANDLING}
        )
    endif()
    if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
        target_link_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /OPT:REF;
                /OPT:ICF
            >
            /DEBUG;
            /SUBSYSTEM:WINDOWS;
            /INCREMENTAL
        )
    elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "Win32")
        target_link_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /OPT:REF;
                /OPT:ICF
            >
            /DEBUG;
            /SUBSYSTEM:WINDOWS;
            /INCREMENTAL
        )
    endif()
endif()

