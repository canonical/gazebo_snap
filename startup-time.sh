#!/bin/bash

# This script allow you to test application startup times and compare them.
# You can test both cold startups (no data cached in memory)
# and hot startups (cached).

# If you have any suggestions for improvements, feel free to file a PR
# or email: snap-advocacy at canonical dot com.

#########################
##### Configuration #####
#########################

# Application to install (may have different name for pkg and snap)
STARGET="gazebo"
INSTALL_TARGET="gazebo_citadel_amd64.snap"
RUN_TARGET="gazebo.gz gazebo shapes.sdf"
WINDOW_TARGET="Gazebo"

# Native package manager commands (change to match the target system)
SNAPCMD=`which snap`

# Snap commands (options can be empty)
# Example for SNAPOPTIONS="--channel=edge"
SNAPINST="$SNAPCMD install"
SNAPUNINSTALL="$SNAPCMD remove --purge"
SNAPREFRESH="$SNAPCMD refresh"
SNAPOPTIONS="--dangerous"

# Tool to detect application window and close it
TIMER="xdotool"

# Log to save data
LOGF=~/startup-time-results.txt

#####################
##### Functions #####
#####################

snap_install()
{
    # If installed and/or does not refresh, the commands will complete without changes
    sudo $SNAPINST $SNAPOPTIONS $INSTALL_TARGET
}

snap_uninstall()
{
    sudo $SNAPUNINSTALL $STARGET
}

drop_caches()
{
    sudo sysctl -w vm.drop_caches=3
    sleep 2
}

detect_app_window()
{
    TIMERBIN=`which $TIMER`
    id=$1
    PIDS=()
    for w in $($TIMERBIN search --sync --onlyvisible --class "$id")
    do
	    PIDS+=$($TIMERBIN getwindowpid $w)
    done
    # Gazebo takes some time to be killable...
    #sleep 5
    for PID_TO_KILL in ${PIDS[@]}
    do
	    xargs kill -9 $PID_TO_KILL
    done
}

# Read the last line of the input file
sum_times()
{
    input_file=$1
    last_line=$(tail -n 1 $input_file)

    # Split the line into fields
    IFS=',' read -r -a fields <<< "$last_line"

    # Initialize the sum variable
    sum=0

    # Loop through the fields and add them to the sum
    for field in "${fields[@]}"; do
      sum=$(echo "$sum + $field" | bc)
    done

    # Replace the last line of the input file with the sum
    sed -i '$d' $input_file
    echo "$sum" >> $input_file
}

snap_run()
{
    echo -e "Snap package runtime results:" >> $LOGF
    detect_app_window $WINDOW_TARGET &
    sleep 2 # Make sure the detect_app_window is ready
    /usr/bin/time --quiet -f "%U,%S" -a -o $LOGF $SNAPCMD run $RUN_TARGET
    sum_times $LOGF
    echo "" >> $LOGF
    sleep 2
}

################
##### Main #####
################

snap_install

# Create log file
touch $LOGF

# Cold run
echo -e "Cold run:" >> $LOGF
# Uncomment the functions below to run
drop_caches
snap_run

# Hot run
echo -e "Hot run:" >> $LOGF
drop_caches
snap_run

snap_uninstall

exit 0

