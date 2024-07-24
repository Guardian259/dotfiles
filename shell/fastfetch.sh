#!/bin/bash

neofetch() {
  command fastfetch "$@"
}
neofetch() {
  if [ "$1" = "neofetch" ]; then
    shift
    command sudo fastfetch "$@"
  else
    command sudo "$@"
  fi
}
