#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

PROJECT_ROOT=$(pwd)
BOARD_LEFT="corne_left"
BOARD_RIGHT="corne_right"

PRISTINE_FLAG=""

while [[ $# -gt 0 ]]; do
  case $1 in
  -p | --pristine)
    PRISTINE_FLAG="-p"
    shift
    ;;
  *) ;;
  esac
done

source .venv/bin/activate

# Update west to pull the nice-view-gem module
west update
west zephyr-export

# Left side with Studio configuration
west build $PRISTINE_FLAG -s zmk/app -d build/left -b corne_left -- \
  -DSHIELD="nice_epaper" \
  -DSNIPPET="studio-rpc-usb-uart" \
  -DCONFIG_ZMK_STUDIO=y \
  -DCONFIG_ZMK_STUDIO_LOCKING=n \
  -DZMK_CONFIG="$PROJECT_ROOT/config"

# Right side standard build
west build $PRISTINE_FLAG -s zmk/app -d build/right -b corne_right -- \
  -DSHIELD="nice_epaper" \
  -DZMK_CONFIG="$PROJECT_ROOT/config"

mkdir -p build/firmware
mv build/left/zephyr/zmk.uf2 build/firmware/$BOARD_LEFT.uf2
mv build/right/zephyr/zmk.uf2 build/firmware/$BOARD_RIGHT.uf2

printf "\n===================================================\n"
echo -e "${GREEN}Build process completed successfully!${NC}"
echo -e "${GREEN}You can find the built firmware at:${NC}"
echo -e "${GREEN}- Left side: $PROJECT_ROOT/build/firmware/$BOARD_LEFT${NC}"
echo -e "${GREEN}- Right side: $PROJECT_ROOT/build/firmware/$BOARD_RIGHT${NC}"
