startdir=$(pwd)

# cd to the path of the script
cd "$(dirname "$0")"

# update the submodules
git submodule update --init --recursive

# Path to the libui source code
cd vendor/libui-ng

# Build libui
meson setup build
ninja -C build install

# cd back to the original directory
cd $startdir