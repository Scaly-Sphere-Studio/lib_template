# Set PLATFORM_DIR
if (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(PLATFORM_DIR "")
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(PLATFORM_DIR "x64")
else()
    message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

# Set BUILD_DIR
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    set(BUILD_DIR "Release")
endif()
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    set(BUILD_DIR "Debug")
endif()

# Set paths to binaries and headers
set(BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")
get_filename_component(PKG_NAME "${BASE_DIR}" NAME)
set(INC_DIR  "${BASE_DIR}/include")
set(DLL_PATH "${BASE_DIR}/${PLATFORM_DIR}/${BUILD_DIR}/${PKG_NAME}.dll")
set(PDB_PATH "${BASE_DIR}/${PLATFORM_DIR}/${BUILD_DIR}/${PKG_NAME}.pdb")
set(LIB_PATH "${BASE_DIR}/${PLATFORM_DIR}/${BUILD_DIR}/${PKG_NAME}.lib")

# Ensure binaries are present
if (NOT EXISTS "${DLL_PATH}")
    message(FATAL_ERROR "File does not exist: ${DLL_PATH}")
endif()
if (NOT EXISTS "${PDB_PATH}")
    message(FATAL_ERROR "File does not exist: ${PDB_PATH}")
endif()
if (NOT EXISTS "${LIB_PATH}")
    message(FATAL_ERROR "File does not exist: ${LIB_PATH}")
endif()

# Create directories: /bin, lib/, include/, debug/, and share/
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(MAKE_DIRECTORY
        "${CURRENT_PACKAGES_DIR}/bin"
        "${CURRENT_PACKAGES_DIR}/lib"
    )
endif()
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(MAKE_DIRECTORY
        "${CURRENT_PACKAGES_DIR}/debug/bin"
        "${CURRENT_PACKAGES_DIR}/debug/lib"
    )
endif()
file(MAKE_DIRECTORY
    "${CURRENT_PACKAGES_DIR}/include/SSS"
    "${CURRENT_PACKAGES_DIR}/share/${PKG_NAME}"
)

# Copy .dll, .lib, and headers
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    message(STATUS "Copying release binaries...")
    file(COPY ${DLL_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    file(COPY ${PDB_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    file(COPY ${LIB_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
endif()
if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    message(STATUS "Copying debug binaries...")
    file(COPY ${DLL_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    file(COPY ${PDB_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    file(COPY ${LIB_PATH}  DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
endif()
message(STATUS "Copying headers...")
file(GLOB HEADERS_PATH
  "${INC_DIR}/*.h"
)
file(COPY
    "${HEADERS_PATH}"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/SSS"
)

# Create copyright file
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PKG_NAME}/copyright" "SSS use only")
