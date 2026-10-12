# How to compile the kernel/m1n1
### i really had to make one because the process is probably one of the most annoying one i've ever seen. However, its "easy" if you just start from the beginning
## 1.0 - Linux Kernel
**Install Compiler Dependencies**  
```
sudo apt install bison flex libssl-dev libelf-dev bc python3 gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu rustup
```  
**Install Rustup Dependencies**
```
rustup default stable
```
```
rustup target add aarch64-unknown-none-softfloat
```
**Compile Kernel**  
```
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```
```
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- KBUILD_DTBS=arch/arm64/boot/dts/apple dtbs
```