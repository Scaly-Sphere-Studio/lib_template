$ErrorActionPreference = "Stop";

# Source pkg parameters
. .\variables.ps1;

# Build all binaries
.\build.ps1

# Create (or recreate) export dir
if (Test-Path $export_dir) {
    Remove-Item -Recurse -Force $export_dir
}
New-Item -ItemType directory $export_dir | Out-Null;

# Copy binaries and headers, along with vcpkg files
Copy-Item -Recurse -Path "$pkg_dir\Debug"       -Destination "$export_dir\Debug";
Copy-Item -Recurse -Path "$pkg_dir\Release"     -Destination "$export_dir\Release";
Copy-Item -Recurse -Path "$pkg_dir\x64\Debug"   -Destination "$export_dir\x64\Debug";
Copy-Item -Recurse -Path "$pkg_dir\x64\Release" -Destination "$export_dir\x64\Release";
Copy-Item -Recurse -Path "$inc_dir"             -Destination "$export_dir\include";
Copy-Item -Recurse -Path "export_files\*"       -Destination "$export_dir";

# Create export archive
Compress-Archive -Update -Path "$export_dir" -DestinationPath "$export_zip"

# Output success
"`nvcpkg export archive ready at: '$export_zip'";
