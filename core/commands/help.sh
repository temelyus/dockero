#!/usr/bin/env bash

# === TITLE ===
log.setline "Dockero - V$DOCKERO_VERSION"
echo "Dockero - Simplified Docker CLI"


help() { 
echo "
Usage 🪬 :"

log.sub "$0 run      <name> <image>                 Run or create container."
log.sub "$0 list     [img:--img] <:name>            List containers."
log.sub "$0 stop     <container> --time <second>    Stop a container with provided time as delay"
log.sub "$0 setup    <project path>                 Setup a container for project."
log.sub "$0 start    <container> -c <command>       Start a container with provided command."
log.sub "$0 export   <container name>               Export container as .tar."
log.sub "$0 rename   <container> <new name>         Rename container."
log.sub "$0 remove   <container:image> [more...]    Remove container or image"

log.endline
exit 0
}
help-() { help && exit 0; }
help-help() { help && exit 0; }


help-run() {
echo "
💠 $0 run <name>
  🔹 Run existing container
  🔹 If container doesn't exist create a new one and use <name> as image and container name.

💠 $0 run <name> <image>
  🔹 Create container with name declaration - default port 80.
"
exit 0
}

help-list(){
echo "
💠 $0 list
  🔹 List all exist containers.

💠 $0 list img
  🔹 List all exist images.

💠 $0 list --img <name>
  🔹 List exist containers which has same image.
"
}

help-rename(){
echo "
💠 $0 rename <name> <new name>
  🔹 rename exist container
"
}

help-export(){
echo "
💠 $0 export <container name>
  🔹 export exist container as .tar file to $HOME
"
}

help-start() {
echo "
💠 $0 start <container name>
  🔹 Start a container

💠 $0 start <container name> -c <command>
  🔹 Start a container with provided command
"
}

help-stop() {
echo "
💠 $0 stop <container name>
  🔹 Stop a container

💠 $0 stop <container name> --time <second>
  🔹 Stop a container with provided time as delay
"
}

help-setup(){
echo "
💠 $0 setup <project path>
  🔹 Create a container for your project.
  🔹 .dockero file must be included at project path.

💠 .dockero format example
  🔹 PORT is sets outter port of container.
  🔹 VPATH and PORT is optional
  
  [default]
  name = mydebian
  image = debian:latest
  command = echo hello from debian

  [volumes]
  data = /opt/mydebian:/workspace
  port = 8080:80
"
}

help-remove() {
echo "
💠 $0 remove <container:image>
  🔹 remove container or image
"
}