#!/bin/bash
# Refered to ffmpeg source from (MX player):
#       https://sites.google.com/site/mxvpen/download
# @note Changed armeabi names in v7x models by reason of bugs of HTC Desire / Motorola Milestone and more.
# @see http://groups.google.com/group/android-ndk/browse_thread/thread/464bab5543c672d4

# Below using NDK API 21, rand(), atof() stdc API not exists.
# Because of this reason, Using API 16 except x86_64 model.

# Latest modified : 03-10-2015, Raphael Kim <rage.kim@gmail.com>

# Test parameter
if [ "$1" == "" ]; then
    echo "Error: requires one parameter for TARGET."
    exit 0
fi

# Test Android NDK exists.
if [ "$NDK" == "" ]; then
    echo "Error: Android NDK seems not configured."
    exit 0
fi

TARGET=$1
COPY=0
BUILD=0
PROFILE=0
CPU_CORE=12

MAKE=$NDK/ndk-build

prepare()
{
	rm -r ../obj/local
}

prepare_mips()
{
	rm -r ../obj/local
}

prepare_x86()
{
	rm -r ../obj/local
}

# MIPS32 revision 2
mips32r2() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.MIPS32 rev.2...\n\n'
		prepare_mips
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_ABI=mips \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=15-mips \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=mips32r2 \
				  -e NDK_APP_DST_DIR=libs/mips \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi
}

x86_64() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86_64...\n\n'
		prepare_x86
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_ABI=x86_64 \
				  -e APP_PLATFORM=android-21 \
				  -e LINK_AGAINST=21-x86_64 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=atom \
				  -e NDK_APP_DST_DIR=libs/x86_64 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi
}

# x86 (Atom)
x86() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86 Atom...\n\n'
		prepare_x86
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_ABI=x86 \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-x86 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=atom \
				  -e NDK_APP_DST_DIR=libs/x86 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi
}

# x86 (sse2)
x86_sse2() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86 SSE2...\n\n'
		prepare_x86
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_ABI=x86 \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-x86 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=i686 \
				  -e NDK_APP_DST_DIR=libs/x86-sse2 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi
}

neon() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.neon...\n\n'
		prepare
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=neon \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/neon \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/neon/lib$TARGET.so libs/output/videoplayer/armeabi-v7a/
	fi
}

tegra3() 
{
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.tegra3...\n\n'
		prepare
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=neon \
				  -e UNALIGNED_ACCESS=0 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/tegra3 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/tegra3/lib$TARGET.so libs/output/videoplayer/armeabi-v7a/
	fi
}

# ARMv7a + VFPv3-D16 (tegra2)
tegra2()
{
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.tegra2...\n\n' 
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=vfpv3-d16 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/vfpv3-d16 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/vfpv3-d16/lib$TARGET.so libs/output/videoplayer/armeabi-v7a
	fi
}

# ARMv7a
v7a()
{
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v7a...\n\n' 
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=vfp \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/lib$TARGET.so libs/output/videoplayer/armeabi-v7a
	fi
}

# ARMv6 + VFP
v6_vfp()
{
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v6+vfp...\n\n' 
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv6 \
				  -e VFP=vfp \
				  -e NDK_APP_DST_DIR=libs/armeabi-v6/vfp \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v6/vfp/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}

# ARMv6
v6()
{
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v6...\n\n' 
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv6 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v6 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v6/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}

# ARMv5TE
v5te()
{
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v5te...\n\n' 
		$MAKE NDK_DEBUG=0 \
				  -j$CPU_CORE \
				  -e APP_PLATFORM=android-19 \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv5te \
				  -e NDK_APP_DST_DIR=libs/armeabi-v5 \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v5/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}


if [ $TARGET == 'mxvp' ]
then
	/home/blue/workspace/GenSecureString/Debug/GenSecureString `pwd`/mxvp/android/sec_str
	/home/blue/workspace/GenSecureBytes/Debug/GenSecureBytes `pwd`/mxvp/android/sec_bytes
fi

# @note 'then' should appear next line of [] block. 'do' for 'for' seems to be same.. i don't know why ..
#if [ $# -eq 1 ]
#then
#	COPY=1
#	BUILD=1
#	v7a 
#else
	for p in $* 
	do
		case "$p" in
			copy)
				COPY=1 ;;
			build)
				BUILD=1 ;;
			mips)
				mips32r2 ;;
			x86_64)
				x86_64 ;;
			x86)
				x86 ;;
			x86_sse2)
				x86_sse2 ;;
			neon) 
				neon ;;
			tegra3)
				tegra3;;
			tegra2)
				tegra2;;
			v7a)
				v7a;;
			v6_vfp)
				v6_vfp ;;
			v6)
				v6 ;;
			v5te)
				v5te ;;
			profile)
				PROFILE=1 ;;
			4.8)
				export NDK_TOOLCHAIN_VERSION=4.8 ;;
		esac
	done
#fi

