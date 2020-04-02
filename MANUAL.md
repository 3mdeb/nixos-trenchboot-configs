## System configuration

1. Install the NixOS as it's shown in the [blog post](#).

2. Install the cachix package.

```
nix-env -iA cachix -f https://cachix.org/api/v1/install
```

3. Add the 3mdeb binary cache.

```
cachix use 3mdeb
```

3. Install the git package.

```
nix-env -iA nixos.git
```

4. Clone the 3mdeb nixpkgs fork.

```
git clone https://github.com/3mdeb/nixpkgs.git -b landing-zone
```

5. Clone the NixOS TrenchBoot configuration repo.

```
git clone https://github.com/3mdeb/nixos-trenchboot-configs.git
```

6. Copy the configuration files to `/etc/nixos`

```
cp nixos-trenchboot-configs/*.nix /etc/nixos
```

7. Update the system

Change the nixpkgs directory to the 3mdeb nixpkgs repository.

```
sudo nixos-rebuild switch -I nixpkgs=~/nixpkgs
```

8. Reboot the system


9. Install the trenchboot GRUB2 to `/dev/sdX`

```
grub-install /dev/sda
```

10. Ensure that slaunch modules are present in `/boot/grub/i386-pc`

```
# ls |grep slaunch
slaunch.mod
slaunch.module
```

11. Find landing zone package in nixos storage

```
# ls /nix/store/ |grep landing-zone

62ik61qxadavc2xix4sm8mbm0fcxlz2i-landing-zone-1.0
```

12. Copy `lz_header.bin` to boot directory

```
cp /nix/store/62ik61qxadavc2xix4sm8mbm0fcxlz2i-landing-zone-1.0/lz_header.bin /boot/lz_header
```

13. `cat` `/boot/grub/grub.cfg` and check `NixOS - Default` menu entry

```
menuentry "NixOS - Default" {
search --set=drive1 --fs-uuid 178473b0-282f-4994-96fc-a8e51e2cfdac
search --set=drive2 --fs-uuid 178473b0-282f-4994-96fc-a8e51e2cfdac
  linux ($drive2)/nix/store/ymvcgas7b1bv76n35r19g4p142v4cr0b-linux-5.1.0/bzImage systemConfig=/nix/store/b32wgz392q99cls12pkd8adddzbdkprn-nixos-system-nixos-20.09.git.50c3e448fceM init=/nix/store/b32wgz392q99cls12pkd8adddzbdkprn-nixos-system-nixos-20.09.git.50c3e448fceM/init console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 loglevel=4
  initrd ($drive2)/nix/store/zv2vl35xldkbss1y2fib1nifmw0yvick-initrd-linux-5.1.0/initrd
}
```

14. Check if `grub.extraEntries` in the `/etc/nixos/configuration.nix`has the
same `linux` and `initrd` cmdlines. If not, copy default cmdlines to
`grub.extraEntries`.

```
  boot.loader.grub.extraEntries = ''
    menuentry "NixOS - Secure Launch" {
    search --set=drive1 --fs-uuid 178473b0-282f-4994-96fc-a8e51e2cfdac
    search --set=drive2 --fs-uuid 178473b0-282f-4994-96fc-a8e51e2cfdac
      slaunch skinit
      slaunch_module ($drive2)/boot/lz_header
      linux ($drive2)/nix/store/ymvcgas7b1bv76n35r19g4p142v4cr0b-linux-5.1.0/bzImage systemConfig=/nix/store/b32wgz392q99cls12pkd8adddzbdkprn-nixos-system-nixos-20.09.git.50c3e448fceM init=/nix/store/b32wgz392q99cls12pkd8adddzbdkprn-nixos-system-nixos-20.09.git.50c3e448fceM/init console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 loglevel=4
      initrd ($drive2)/nix/store/zv2vl35xldkbss1y2fib1nifmw0yvick-initrd-linux-5.1.0/initrd
    }
  '';
```

15. If you have done any changes in the `/etc/nixos/configuration.nix`, update
the system

```
sudo nixos-rebuild switch -I nixpkgs=~/nixpkgs
```
