# DaemonDisabler

Disable / enable launch daemons on the fly from the Settings app.

Original tweak by [level3tjg](https://github.com/level3tjg). This fork adds support for iOS 16 on RootHide (Dopamine).

`launchctl`'s binary path is resolved with `jbroot()` so `posix_spawn` works under roothide's randomized layout. The deprecated `load`/`unload` calls are replaced with `enable`/`disable` plus an immediate `bootstrap`/`bootout` so changes take effect without a reboot. The plist path passed to `bootstrap` uses `rootfs()`, since `launchctl` is a procursus tool that reads `/` as jbroot.

Preferences are stored under `jbroot()` at `/var/mobile/Library/Preferences/com.level3tjg.daemondisabler.plist`, following the usual roothide convention.

Long-press a daemon row to copy its label or full path. The switch now reverts correctly when a confirmation is cancelled, and the enable path has the same confirmation dialog as disable.

Tested on RootHide Dopamine, iOS 16. Not tested on plain rootless jailbreaks.

## License

See [LICENSE](LICENSE).
