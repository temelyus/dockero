#!/usr/bin/env bash

# === TITLE ===
log.setline "Dockero - V$DOCKERO_VERSION"
echo "Dockero - Simplified Docker CLI"


help() { 
echo "
Usage 🪬 :"

log.sub "dockero run      ${YELLOW}<name> [<image>]                 ${RESET_COLOR}Run an existing container or create a new one."
log.sub "dockero list     ${YELLOW}[img | --img <name>]             ${RESET_COLOR}List containers or images."
log.sub "dockero stop     ${YELLOW}<container> [--time <seconds>]   ${RESET_COLOR}Stop a container with an optional delay."
log.sub "dockero setup    ${YELLOW}<project-path>                   ${RESET_COLOR}Set up a containerized environment for a project."
log.sub "dockero start    ${YELLOW}<container> [-c <command>]       ${RESET_COLOR}Start a container, optionally with a custom command."
log.sub "dockero export   ${YELLOW}<container-name>                 ${RESET_COLOR}Export a container as a .tar archive to \$HOME."
log.sub "dockero import   ${YELLOW}</path/to/archive.tar>           ${RESET_COLOR}Import a .tar archive as a container image."
log.sub "dockero rename   ${YELLOW}<current-name> <new-name>        ${RESET_COLOR}Rename an existing container."
log.sub "dockero remove   ${YELLOW}<container|image> [additional]   ${RESET_COLOR}Remove a container(s) or an image(s)."

log.endline
exit 0
}

help-() { help && exit 0; }
help-help() { help && exit 0; }


help-run() {
echo "
💠 dockero run <name>
  🔹 Launch an existing container by <name>.
  🔹 If the container is not found, create a new container using <name> as both the image and container name.

💠 dockero run <name> <image>
  🔹 Create a new container named <name> based on the specified <image>.

💠 Default Configuration:
  🔹 Port Mapping: Host 80 ➔ Container 80
  🔹 Volume Binding: /opt/<name> ➔ /workspace
  🔹 Host Integrations:
    🔸 DISPLAY environment variable for GUI support
    🔸 /dev/snd device access for audio output (if available)
"
exit 0
}

help-list(){
echo "
💠 dockero list
  🔹 List all existing containers.

💠 dockero list img
  🔹 List all existing images.

💠 dockero list --img <image-name>
  🔹 List all containers created from the specified image.
"
}

help-rename(){
echo "
💠 dockero rename <current-name> <new-name>
  🔹 Rename an existing container.
"
}

help-export(){
echo "
💠 dockero export <container-name>
  🔹 Export an existing container as a .tar archive to $HOME.
"
}

help-import(){
echo "
💠 dockero import </path/to/archive.tar>
  🔹 Import a .tar archive as a new image.
"
}

help-start(){
echo "
💠 dockero start <container-name>
  🔹 Start an existing container.

💠 dockero start <container-name> -c <command>
  🔹 Start an existing container and execute a specific command.
"
}

help-stop(){
echo "
💠 dockero stop <container-name>
  🔹 Gracefully stop an existing container.

💠 dockero stop <container-name> --time <seconds>
  🔹 Stop a container after a specified delay in seconds.
"
}

help-setup(){
echo "
💠 dockero setup <project-path>
  🔹 Create and configure a container for your project.
  🔹 A valid .dockero configuration file must exist at the project path.

💠 .dockero file format example
  🔹 'PORT' sets the external port mapping for the container.
  🔹 'VPATH' and 'PORT' entries are optional.

  [default]
  name = mydebian
  image = debian:latest
  command = echo hello from debian

  [volumes]
  data = /opt/mydebian:/workspace
  port = 8080:80
"
}

help-remove(){
echo "
💠 dockero remove <container-or-image>
  🔹 Remove a specified container or image.
"
}