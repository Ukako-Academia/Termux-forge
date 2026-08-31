#!/data/data/com.termux/files/usr/bin/bash
# termux-forge - instalador/menú de configuración para Termux
# Repositorio: https://github.com/tuusuario/termux-forge

# ---------- Colores ----------
RESET='\033[0m'
BOLD='\033[1m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'

# ---------- Banner ----------
banner() {
    clear
    echo -e "${MAGENTA}"
    echo "  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
    echo "  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝"
    echo "     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ "
    echo "     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ "
    echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗"
    echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${CYAN}                     F O R G E ${RESET}"
    echo -e "${YELLOW}        Configura tu entorno Termux en segundos${RESET}"
    echo ""
}

pausa() {
    echo ""
    read -p "$(echo -e "${BOLD}Presiona ENTER para continuar...${RESET}")"
}

# ---------- Módulos ----------
instalar_paquetes() {
    banner
    echo -e "${GREEN}▶ Instalando paquetes esenciales...${RESET}"
    pkg update -y && pkg upgrade -y
    pkg install -y git python nodejs vim curl wget openssh
    echo -e "${GREEN}✔ Paquetes instalados correctamente.${RESET}"
    pausa
}

configurar_alias() {
    banner
    echo -e "${GREEN}▶ Configurando alias útiles...${RESET}"
    ARCHIVO="$HOME/.bashrc"
    {
        echo ""
        echo "# --- alias agregados por termux-forge ---"
        echo "alias ll='ls -la'"
        echo "alias update='pkg update -y && pkg upgrade -y'"
        echo "alias gs='git status'"
        echo "alias gp='git push'"
    } >> "$ARCHIVO"
    source "$ARCHIVO" 2>/dev/null
    echo -e "${GREEN}✔ Alias agregados a .bashrc${RESET}"
    pausa
}

configurar_prompt() {
    banner
    echo -e "${GREEN}▶ Personalizando prompt...${RESET}"
    ARCHIVO="$HOME/.bashrc"
    echo 'export PS1="\[\033[1;36m\]\u@termux-forge\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]\$ "' >> "$ARCHIVO"
    echo -e "${GREEN}✔ Prompt personalizado agregado.${RESET}"
    pausa
}

instalar_todo() {
    instalar_paquetes
    configurar_alias
    configurar_prompt
    banner
    echo -e "${GREEN}✔ Instalación completa. Reinicia Termux o corré: source ~/.bashrc${RESET}"
    pausa
}

salir() {
    echo -e "${CYAN}Gracias por usar termux-forge. ¡Hasta la próxima!${RESET}"
    exit 0
}

# ---------- Menú principal ----------
menu() {
    while true; do
        banner
        echo -e "${BOLD}Elegí una opción:${RESET}"
        echo -e "  ${YELLOW}1)${RESET} Instalar paquetes esenciales"
        echo -e "  ${YELLOW}2)${RESET} Configurar alias"
        echo -e "  ${YELLOW}3)${RESET} Personalizar prompt"
        echo -e "  ${YELLOW}4)${RESET} Instalar todo (recomendado)"
        echo -e "  ${YELLOW}5)${RESET} Salir"
        echo ""
        read -p "$(echo -e "${BOLD}> ${RESET}")" opcion

        case $opcion in
            1) instalar_paquetes ;;
            2) configurar_alias ;;
            3) configurar_prompt ;;
            4) instalar_todo ;;
            5) salir ;;
            *) echo -e "${RED}Opción inválida.${RESET}"; sleep 1 ;;
        esac
    done
}

menu
