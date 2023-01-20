<h1 align="center" default="https://ignitionrobotics.org/home">
  <a href="https://ignitionrobotics.org/home">
    <img src="/snap/gui/icon.svg" alt="Gazebo">
  </a>
  <br />
  Gazebo
</h1>

<p align="center"><b>This is the snap for Gazebo</b>, a curated set of open-source libraries
that encapsulate all the essentials for robotic simulation.</p>

<!-- Uncomment and modify this when you are provided a build status badge
<p align="center">
<a href="https://build.snapcraft.io/user/snapcrafters/fork-and-rename-me"><img src="https://build.snapcraft.io/badge/snapcrafters/fork-and-rename-me.svg" alt="Snap Status"></a>
</p>
-->

## Install

    sudo snap install gazebo --beta

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

<!-- Uncomment and modify this when you have a screenshot
![my-snap-name](screenshot.png?raw=true "my-snap-name")
-->

## Run

You can run the command-line `ignition-robotics.ign` has the Ignition CLI tool,
e.g. `ignition-robotics.ign gazebo empty.sdf` opens the Ignition Gazebo simulator
with an empty world.

You can also simply search for `Ignition-robotics` in the dash.
It open gazebo and is equivalent to the command `ignition-robotics.ign gazebo`.

## Troubleshooting

```bash
Qt: Session management error: Could not open network socket
```

Try the following before launching Gazebo,

```bash
unset SESSION_MANAGER
```
## Benchmarking
the script `startup-time.sh` is used to measure "cold" and "warn" start of the snap. The script will append the results of the experiment in a file giving for both cases the sum of total number of CPU-seconds that the process used directly (in user mode) and total number of CPU-seconds used by the system on behalf of the process (in kernel mode), in seconds to depend as little as possible on the load of the computer. The file is saved at `~/startup-time-results.txt`

