BootStrap: docker
From: ubuntu:latest

%runscript
TEMPDIR="$(mktemp -d)"
echo "Creating and changing into temporary directory $TEMPDIR..."
cd "$TEMPDIR"

# Two hard coded paths for where the wineprefix.tgz goes and for 
# PeakSelector
APPDIR="/uufs/chpc.utah.edu/common/home/u0101881/WINE/PEAKSELECTOR"
PSDIR="/uufs/chpc.utah.edu/common/home/u0101881/physics/saveez/PeakSelector_V9.6"

PROFILEDIR="$HOME/WINE/PROFILES/${USER}@${HOSTNAME}"
mkdir -p $APPDIR
mkdir -p $PROFILEDIR

echo "Setting up wine prefix..."
export WINEPREFIX="$TEMPDIR/wineprefix"
export WINEARCH="win32"

if [ -f "$APPDIR/wineprefix.tgz" ]; then
    echo "Found existing wineprefix - restoring it..."
    mkdir -p "$WINEPREFIX"
    cd "$WINEPREFIX"
    tar xzf "$APPDIR/wineprefix.tgz"
else
  wineboot --init

  # Don't need DirectX for IDL
  #echo "Installing DirectX9..."
  #winetricks dlls directx9
  # Get and install IDL 6.4
  echo "This downloads IDL and starts the installation. Please, follow through the installation, and when the prompt comes back up in the terminal, type exit"
  wget http://docs.astro.columbia.edu/files/idl/6.4/idl64winx86_32.exe
  wine idl64winx86_32.exe
  cd "$WINEPREFIX"
fi

# creating shell function for Peakselector
    echo "
function Peakselector()
{
wine \$WINEPREFIX/drive_c/Program\\ Files/ITT/IDL64/bin/bin.x86/idlrt.exe \$PSDIR/Peakselector.sav
}
">> $WINEPREFIX/psinit
    source "$WINEPREFIX/psinit"

echo "Containerizing user profile..."
if [ -d "$PROFILEDIR" ]; then
    rm -rf "$WINEPREFIX/drive_c/users/$USER"
else
    echo "This user profile is newly generated..."
    mv "$WINEPREFIX/drive_c/users/$USER" "$PROFILEDIR"
fi
echo "Loading existing user profile"
ln -s "$PROFILEDIR" "$WINEPREFIX/drive_c/users/$USER"

# at first container start run bash to let user finish configuration
if [ ! -f "$APPDIR/wineprefix.tgz" ]; then
  env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" /bin/bash
fi

# run Peakselector
Peakselector

wineboot --end-session

if [ ! -f "$APPDIR/wineprefix.tgz" ]; then
 echo "Saving initial wineprefix..."
 cd $WINEPREFIX && tar czf "$APPDIR/wineprefix.tgz" . && sync
fi 

rm -rf "$TEMPDIR" 

%post
    dpkg --add-architecture i386 
    apt update
    apt -y install wget less vim software-properties-common python3-software-properties apt-transport-https winbind
    wget https://dl.winehq.org/wine-builds/Release.key
    apt-key add Release.key
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
    apt update
    apt install -y winehq-stable winetricks # this installs Wine2
    # Singularity 2.2.1 user can't write to these in %runscript so comment them out
    # use user home to store these instead
    # mkdir /APPS /PROFILES
    # chmod 0777 /APPS /PROFILES

    mkdir /uufs /scratch

