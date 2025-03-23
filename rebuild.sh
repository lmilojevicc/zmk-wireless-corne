#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'
PROJECT_ROOT=$(pwd)

source .venv/bin/activate

west update
west zephyr-export

west build -s zmk/app -d build/left -b "corne_left" -- \
  -DSHIELD="nice_view" \
  -DZMK_EXTRA_MODULES="$PROJECT_ROOT/zephyr" \
  -DZMK_CONFIG="$PROJECT_ROOT/config"

west build -s zmk/app -d build/right -b "corne_right" -- \
  -DSHIELD="nice_view" \
  -DZMK_EXTRA_MODULES="$PROJECT_ROOT/zephyr" \
  -DZMK_CONFIG="$PROJECT_ROOT/config"

mv build/left/zephyr/zmk.uf2 build/nice_left
mv build/right/zephyr/zmk.uf2 build/nice_right

printf "\n===================================================\n"
echo -e "${GREEN}Build process completed successfully!${NC}"
echo -e "${GREEN}You can find the built firmware at:${NC}"
echo -e "${GREEN}- Left side: $PROJECT_ROOT/build/nice_left${NC}"
echo -e "${GREEN}- Right side: $PROJECT_ROOT/build/nice_right${NC}"
