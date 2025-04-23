#!/usr/bin/env bash

# === TITLE ===
log.setline "Dockero - V$DOCKERO_VERSION"
echo "Dockero - Simplified Docker CLI"


help() { 
echo "
Usage 🪬 :"

log.sub "dockero run      <name> <image>                 Run or create container."
log.sub "dockero list     [img:--img] <:name>            List containers."
log.sub "dockero stop     <container> --time <second>    Stop a container with provided time as delay"
log.sub "dockero setup    <project path>                 Setup a container for project."
log.sub "dockero start    <container> -c <command>       Start a container with provided command."
log.sub "dockero export   <container name>               Export container as .tar."
log.sub "dockero rename   <container> <new name>         Rename container."
log.sub "dockero remove   <container:image> [more...]    Remove container or image"

log.endline
exit 0
}
help-() { help && exit 0; }
help-help() { help && exit 0; }


help-run() {
echo "
💠 dockero run <name>
  🔹 Run existing container
  🔹 If container doesn't exist create a new one and use <name> as image and container name.

💠 dockero run <name> <image>
  🔹 Create container with name declaration - default port 80.
"
exit 0
}

help-list(){
echo "
💠 dockero list
  🔹 List all exist containers.

💠 dockero list img
  🔹 List all exist images.

💠 dockero list --img <name>
  🔹 List exist containers which has same image.
"
}

help-rename(){
echo "
💠 dockero rename <name> <new name>
  🔹 rename exist container
"
}

help-export(){
echo "
💠 dockero export <container name>
  🔹 export exist container as .tar file to $HOME
"
}

help-start() {
echo "
💠 dockero start <container name>
  🔹 Start a container

💠 dockero start <container name> -c <command>
  🔹 Start a container with provided command
"
}

help-stop() {
echo "
💠 dockero stop <container name>
  🔹 Stop a container

💠 dockero stop <container name> --time <second>
  🔹 Stop a container with provided time as delay
"
}

help-setup(){
echo "
💠 dockero setup <project path>
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
💠 dockero remove <container:image>
  🔹 remove container or image
"
}