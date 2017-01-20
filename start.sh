#!/bin/bash

IMAGE="resin.png"

LOCALPATH=`dirname "$0"`
OVERLAYPATH="$LOCALPATH/images/$OVERLAY.png"

if [ -n "$OVERLAY" ]
then
  echo "Compositing image"
  if [ ! -r "$OVERLAYPATH" ]
  then
    echo "ERROR: $OVERLAYPATH not found!  Skipping compositing."
    cp "images/$IMAGE images/display.png"
  else
    composite -gravity south "$OVERLAYPATH" "images/$IMAGE" "images/display.png"
  fi
else
  cp "images/$IMAGE" images/display.png
fi

echo "Rendering image"

ROTATE=${ROTATE:-0}
if [ "$OVERLAY" == "niskayuna" ]
then
  # Quick and dirty hack to correct for GE beast using a different rotational axis
  case $ROTATE in
  0)
    ROTATE=180
    ;;
  90)
    ROTATE=270
    ;;
  180)
    ROTATE=0
    ;;
  270)
    ROTATE=90
    ;;
  esac
fi

convert images/display.png -rotate $ROTATE images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

sleep infinity
