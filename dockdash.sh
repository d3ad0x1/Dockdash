#!/bin/bash

# 🎨 Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # reset

# 🔄 Auto-refresh interval (seconds)
REFRESH=5
MAX_IMAGE_LEN=30  # maximum image name length

while true; do
    clear
    echo -e "${CYAN}=== Docker Container Manager ===${NC}"
    echo "(refreshes every $REFRESH seconds)"
    echo

    # List of containers
    mapfile -t containers < <(docker ps -a --format "{{.Names}}|{{.Status}}|{{.Image}}|{{.Ports}}")

    if [ ${#containers[@]} -eq 0 ]; then
        echo -e "${RED}No containers found.${NC}"
        exit 0
    fi

    # Table header
    printf "%3s | %-20s | %-10s | %-30s | %-20s\n" "No" "Name" "Status" "Image" "Ports"
    echo "------------------------------------------------------------------------------------------------"

    # Display containers
    for i in "${!containers[@]}"; do
        name=$(echo "${containers[$i]}"      | cut -d'|' -f1 | xargs)
        status_raw=$(echo "${containers[$i]}"| cut -d'|' -f2 | xargs)
        image=$(echo "${containers[$i]}"     | cut -d'|' -f3 | xargs)
        ports=$(echo "${containers[$i]}"     | cut -d'|' -f4 | xargs)

        # Status: only active or stopped
        if [[ "$status_raw" == Up* ]]; then
            status="${GREEN}active${NC}"
        else
            status="${RED}stopped${NC}"
        fi

        # Trim long image names
        if [ ${#image} -gt $MAX_IMAGE_LEN ]; then
            image="${image:0:$((MAX_IMAGE_LEN-3))}..."
        fi

        # Ports: show mapped ones or N/A
        if [[ -n "$ports" ]]; then
            ports_filtered=$(echo "$ports" | grep -oP '(\d+)->\d+' | cut -d'>' -f1 | paste -sd',' -)
            [[ -z "$ports_filtered" ]] && ports_filtered="N/A"
        else
            ports_filtered="N/A"
        fi

        # Output with ANSI color interpretation
        printf "%3d | ${YELLOW}%-20s${NC} | %b | %-30s | %-20s\n" \
            $((i+1)) "$name" "$status" "$image" "$ports_filtered"
    done

    echo
    echo -e "Enter the container number to manage"
    echo -e "or ${YELLOW}q${NC} to quit, ${YELLOW}r${NC} to refresh:"
    read -t $REFRESH choice

    if [[ $? -gt 128 ]]; then
        continue
    fi

    if [[ "$choice" == "q" ]]; then
        echo "Exiting..."
        exit 0
    fi

    if [[ "$choice" == "r" ]]; then
        continue
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#containers[@]} )); then
        container_name=$(echo "${containers[$((choice-1))]}" | cut -d'|' -f1 | xargs)

        while true; do
            clear
            echo -e "${CYAN}=== Managing container: ${YELLOW}$container_name${NC} ==="
            echo -e "1) ${GREEN}Restart 🔄${NC}"
            echo -e "2) ${GREEN}Start ▶️${NC}"
            echo -e "3) ${RED}Stop ⏹${NC}"
            echo -e "4) ${YELLOW}Show logs (last 30 lines) 📜${NC}"
            echo -e "5) ${CYAN}Open bash inside container 🐚${NC}"
            echo -e "b) Back to list"
            echo -e "q) Quit"
            echo
            read -p "Choose an action: " action

            case "$action" in
                1)
                    docker restart "$container_name"
                    echo -e "${GREEN}Container restarted.${NC}"
                    read -p "Press Enter..."
                    ;;
                2)
                    docker start "$container_name"
                    echo -e "${GREEN}Container started.${NC}"
                    read -p "Press Enter..."
                    ;;
                3)
                    docker stop "$container_name"
                    echo -e "${RED}Container stopped.${NC}"
                    read -p "Press Enter..."
                    ;;
                4)
                    echo -e "${YELLOW}--- Logs for ($container_name) ---${NC}"
                    docker logs --tail 30 "$container_name"
                    echo -e "${YELLOW}---------------------------------${NC}"
                    read -p "Press Enter..."
                    ;;
                5)
                    echo -e "${CYAN}Opening bash inside container... (type 'exit' to leave)${NC}"
                    docker exec -it "$container_name" bash
                    ;;
                b)
                    break
                    ;;
                q)
                    echo "Exiting..."
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Invalid choice!${NC}"
                    sleep 1
                    ;;
            esac
        done
    else
        echo -e "${RED}Invalid input!${NC}"
        sleep 1
    fi
done
