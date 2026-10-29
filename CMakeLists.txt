cmake_minimum_required(VERSION 3.14)

project(EasyBMP VERSION 1.06 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(EASYBMP_VERSION "1.06")
set(EASYBMP_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/EasyBMP")
set(EASYBMP_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/EasyBMP")
set(EASYBMP_INSTALL_PKGCONFIGDIR "${CMAKE_INSTALL_LIBDIR}/pkgconfig")

add_library(EasyBMP STATIC EasyBMP.cpp)
add_library(EasyBMP::EasyBMP ALIAS EasyBMP)

if(MSVC)
    set_target_properties(EasyBMP PROPERTIES DEBUG_POSTFIX d)
endif()

target_include_directories(EasyBMP PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${EASYBMP_INSTALL_INCLUDEDIR}>
)

set_target_properties(EasyBMP PROPERTIES EXPORT_NAME EasyBMP)

install(TARGETS EasyBMP
    EXPORT EasyBMPTargets
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
)

install(FILES
    EasyBMP.h
    EasyBMP_DataStructures.h
    EasyBMP_BMP.h
    EasyBMP_VariousBMPutilities.h
    DESTINATION "${EASYBMP_INSTALL_INCLUDEDIR}"
)

install(EXPORT EasyBMPTargets
    FILE EasyBMPTargets.cmake
    NAMESPACE EasyBMP::
    DESTINATION "${EASYBMP_INSTALL_CMAKEDIR}"
)

configure_package_config_file(
    cmake/EasyBMPConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/EasyBMPConfig.cmake"
    INSTALL_DESTINATION "${EASYBMP_INSTALL_CMAKEDIR}"
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/EasyBMPConfigVersion.cmake"
    VERSION "${EASYBMP_VERSION}"
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/EasyBMPConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/EasyBMPConfigVersion.cmake"
    DESTINATION "${EASYBMP_INSTALL_CMAKEDIR}"
)

configure_file(cmake/EasyBMP.pc.in EasyBMP.pc @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/EasyBMP.pc"
    DESTINATION "${EASYBMP_INSTALL_PKGCONFIGDIR}"
)

configure_file(cmake/cmake_uninstall.cmake.in cmake_uninstall.cmake @ONLY)
add_custom_target(uninstall
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
)

message(STATUS "EasyBMP install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "EasyBMP library directory: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
message(STATUS "EasyBMP include directory: ${CMAKE_INSTALL_PREFIX}/${EASYBMP_INSTALL_INCLUDEDIR}")
message(STATUS "EasyBMP CMake package directory: ${CMAKE_INSTALL_PREFIX}/${EASYBMP_INSTALL_CMAKEDIR}")
message(STATUS "EasyBMP pkg-config directory: ${CMAKE_INSTALL_PREFIX}/${EASYBMP_INSTALL_PKGCONFIGDIR}")
