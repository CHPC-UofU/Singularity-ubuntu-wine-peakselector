Ubuntu container running 32 bit Windows version of IDL 6.4 using Wine

The IDL runtime is then used to run the PeakSelector IDL application for one of our users (so it will only work on CHPC clusters where the PeakSelector is installed).

The Wine container is based on [this work](https://singularity-hub.org/containers/955/). More details are at the [Dolmades page](http://secret4u.spdns.org/home).

Essentially in the %post section install the necessary Ubuntu dependencies and Wine.

Then in the %runscript section at the first run, install the needed programs (IDL in this case), and then package the whole Wine environment into a directory, in this case, in my home, `$HOME/WINE/IDL` for future use.

On a subsequent execution of the container, the Wine environment gets restored, so, one can run the program (in this case PeakSelector via IDL runtime), which was installed in the first run.

User home directory inside of the container is available as usual, e.g. `/uufs/chpc.utah.edu/common/home/u0101881/physics/saveez/PeakSelector_V9.6/Peakselector.sav`. Inside of Windows, the `/` is mapped as drive `Z:`, or, we can map file system mounted in the container to a Windows drive as e.g. `ln -s $HOME wineprefix/dosdevices/d:`

One can also manually configure things via `winecfg`.

In this particular container, only the IDL runtime is available (no license is set up), so, we can only run the IDL `sav` files, e.g.
```
wine $WINEPREFIX/drive_c/Program\ Files/ITT/IDL64/bin/bin.x86/idlrt.exe /uufs/chpc.utah.edu/common/home/u0101881/physics/saveez/PeakSelector_V9.6/Peakselector.sav
```

TODO: Add license to IDL

