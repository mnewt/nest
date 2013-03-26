nest
====

A command line utility that automatically configures your Mac when the network connection state changes.

### When your Mac does things:

 * Connects to a network
 * Resumes from sleep
 * Disconnects from a network
 * Starts up
 
### nest responds by taking acton:

 * Sets the Network Location
 * (Re)Connects to a VPN
 * (Re)Connects to an SSH tunnel
 
## Usage

```
% nest help
nest manages Mac OS X network connectivity
it can set:
 - location
 - VPN
 - SSH tunnel
for most other settings, such as proxy or IP address, you can configure a location
from the Mac OS X GUI and then have nest set the location for you.

nest can also configure itself to run on any network connectivity even, enabling
it to reconnect you to after events such as:
 - resume from sleep
 - startup
 - connecting to a wireless or Ethernet network

profiles are stored in '~/.nest/'

Usage:

nest [-lv] [arguments]

  $ nest -v                  # enable verbose logging to stdout (and logfile, if enabled)
  $ nest -l logfile          # enable logging and log to specified file
  $ nest                     # run without arguments to reconnect the active profile
  $ nest <profile>           # activates profile (see example for what a profile looks like)
  $ nest status              # prints status of profile, connectivity, and daemon
  $ nest auto                # tries to auto detect which profile to enable
  $ nest enable [arguments]  # enables launchd daemon, calls nest with arguments specified
  $ nest disable             # removes launchd daemon
  $ nest help                # prints this usage guide
 ```
 
## Profiles

nest decides which action to take based on the **profiles** you configure. A profile is a file with some properties defined (technically it's just a shell script):

```
PROFILE="Coffee Shop"
LOCATION="Public"
VPN="myvpn"
SSH="ssh -f -N -C -D 1080 user@example.com -L 8080/localhost/8080"
MACADDR="0:11:22:33:44:55"
SSID="AT&T"
```

In fact, since **profiles** are shell scripts, you can get fancy and override some of the routines that handle connects and disconnects.

So, if you want to customize `nest` to connect to `Viscosity` instead of the builtin VPN, you would define a **profile** like this:

```
# Connects VPN. Does nothing if VPN is already connected
# Takes one argument, the name of the VPN as from the Network Preferences / Network Services list
vpn_connect() {
  if [ -n "$1" ]; then
    /usr/bin/env osascript >/dev/null <<EOF
tell application "Viscosity" to connect (connections where name is "$1")
EOF
  fi
}

# Disconnects VPN
# Takes one argument, the name of the VPN as from the Network Preferences / Network Services list
vpn_disconnect() {
  if [ -n "$1" ]; then
    /usr/bin/env osascript >/dev/null <<EOF
tell application "Viscosity" to disconnect (connections where name is "$1")
EOF
  fi
}

# Returns 0 (success) if VPN is connected, 1 (failure) if VPN is not connected
# Takes one argument, the name of the VPN as from the Network Preferences / Network Services list
vpn_is_connected() {
  if [ -n "$1" ]; then
    if pgrep "Viscosity"; then
      /usr/bin/env osascript >/dev/null <<EOF
tell application "Viscosity" to set state to state of connections where name is equal to "$1"
EOF
      if [ "$state" == "Connected" ]; then
        return 0
      fi
    fi
  fi
  return 1
}
```

The possibilities are endless.

If you like `nest` or--better yet--create your own profile scripts, please let me know. Pull requests welcome.

## License

The MIT License (MIT)
Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
