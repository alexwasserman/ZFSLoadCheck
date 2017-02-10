ZFSLoadCheck
============

1. Copy the com.alexwasserman.zfsloadcheck.plist to /Library/LaunchAgents
2. Unzip ZFSLoadCheck.zip
3. Move ZFSLoadCheck.app to /Library/PrivilegedHelperTools
4. Create .zfsloadcheck in our $USERS

This is entirely ripped from: https://developer.apple.com/library/content/samplecode/PreLoginAgents/Introduction/Intro.html#//apple_ref/doc/uid/DTS10004414-Intro-DontLinkElementID_2

I just updated it to check for the file and update the label.

