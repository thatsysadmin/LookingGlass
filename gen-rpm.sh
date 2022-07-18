#!/bin/sh

# Export filepaths
export BUILDDIR=/LookingGlass/build
export BUILDROOT=~/rpmbuild/
export RPMSRC=~/rpmbuild/SOURCES
export RPMSPEC=~/rpmbuild/SPECS
export RPMBUILD=~/rpmbuild/BUILD

# Check if user's rpmbuild folder is there, if so, temoprairly rename it.
if [ -d ~/rpmbuild ]; then
	echo "Backing up rpmbuild"
	~/rpmbuild ~/rpmbuild.bkp
	export RPMBUILDEXISTS=TRUE
else
	export RPMBUILDEXISTS=FALSE
fi

# Create rpmbuild folder structure
mkdir ~/rpmbuild
mkdir ~/rpmbuild/BUILD
mkdir ~/rpmbuild/BUILDROOT
mkdir ~/rpmbuild/RPMS
mkdir ~/rpmbuild/SOURCES
mkdir ~/rpmbuild/SPECS
mkdir ~/rpmbuild/SRPMS

# Create LookingGlass .spec file with preinstall and postinstall scripts
cat << 'EOF' > $RPMSPEC/LookingGlass.spec
Name:           LookingGlass
Version:        0.0.1
Release:        1%{?dist}
Summary:        High performance VM screen share with shared memory
BuildArch:      x86_64

License:        GPLv3
URL:            https://github.com/thatsysadmin/LookingGlass
Source0:        LookingGlass-0.0.1_bin.tar.gz

Requires:       bash

%description
High performance VM screen share with shared memory

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_bindir}
cp looking-glass-client $RPM_BUILD_ROOT/%{_bindir}/looking-glass-client

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/looking-glass-client

%changelog
* Sat Mar 12 2022 h <65380846+thatsysadmin@users.noreply.github.com>
- Initial packaging of LookingGlass.
EOF

# Copy over LookingGlass binary and supplemental files into rpmbuild/BUILD/
mkdir genrpm
mkdir genrpm/LookingGlass-0.0.1
#ls /LookingGlass/build/src/
cp /LookingGlass/client/build/looking-glass-client genrpm/LookingGlass-0.0.1/looking-glass-client
cd genrpm

# tarball everything as if it was a source file for rpmbuild
tar --create --file LookingGlass-0.0.1_bin.tar.gz LookingGlass-0.0.1/
mv LookingGlass-0.0.1_bin.tar.gz ~/rpmbuild/SOURCES

# Use rpmbuild to build the RPM package.
rpmlint ~/rpmbuild/SPECS/LookingGlass.spec
QA_RPATHS=$(( 0x0001|0x0010 )) rpmbuild -bb $RPMSPEC/LookingGlass.spec

# Move RPM package into pickup location
mv ~/rpmbuild/RPMS/x86_64/LookingGlass-0.0.1-1.fc*.x86_64.rpm /LookingGlass/LookingGlass.rpm
pwd
ls /LookingGlass

# Clean up; delete the rpmbuild folder we created and move back the original one
if [ "$RPMBUILDEXISTS" == "TRUE" ]; then
        echo "Removing and replacing original rpmbuild folder."
        rm -rf ~/rpmbuild
        mv ~/rpmbuild.bkp ~/rpmbuild
fi
exit 0