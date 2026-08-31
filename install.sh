#!/data/data/com.termux/files/usr/bin/bash
# termux-forge - instalador/menú de configuración para Termux
# Repositorio: https://github.com/tuusuario/termux-forge

CONFIG_DIR="$HOME/.termux-forge"
TEMA_FILE="$CONFIG_DIR/tema.conf"
IDENTIDAD_FILE="$CONFIG_DIR/identidad.conf"
PAQUETES_FILE="$CONFIG_DIR/paquetes_instalados.list"
BASHRC="$HOME/.bashrc"

mkdir -p "$CONFIG_DIR"
touch "$PAQUETES_FILE"

# ---------- Colores base (para el propio menú) ----------
RESET='\033[0m'
BOLD='\033[1m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'

# ---------- Temas de banner ----------
# Cada tema define 3 colores: primario (título), secundario (subtítulo), terciario (frase)
cargar_tema() {
    local tema="magenta"
    [ -f "$TEMA_FILE" ] && tema=$(cat "$TEMA_FILE")

    case "$tema" in
        matrix)
            P1='\033[1;32m'; P2='\033[0;32m'; P3='\033[1;37m' ;;
        cyberpunk)
            P1='\033[1;34m'; P2='\033[1;36m'; P3='\033[1;35m' ;;
        fuego)
            P1='\033[1;31m'; P2='\033[1;33m'; P3='\033[0;31m' ;;
        synthwave)
            P1='\033[1;35m'; P2='\033[1;36m'; P3='\033[1;34m' ;;
        magenta|*)
            P1='\033[1;35m'; P2='\033[1;36m'; P3='\033[1;33m' ;;
    esac
}

cargar_identidad() {
    if [ -f "$IDENTIDAD_FILE" ]; then
        IDENTIDAD=$(cat "$IDENTIDAD_FILE")
    else
        IDENTIDAD="Termux Forge"
    fi
}

banner() {
    cargar_tema
    cargar_identidad
    clear
    echo -e "${P1}"
    echo "  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
    echo "  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝"
    echo "     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ "
    echo "     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ "
    echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗"
    echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${P2}                     F O R G E ${RESET}"
    echo -e "${P3}        Configura tu entorno Termux en segundos${RESET}"
    echo -e "${BOLD}                  ✦ ${IDENTIDAD} ✦${RESET}"
    echo ""
}

pausa() {
    echo ""
    read -p "$(echo -e "${BOLD}Presiona ENTER para continuar...${RESET}")"
}

# ---------- Manejo de "sesiones" en .bashrc ----------
# Cada sesión queda delimitada por marcadores únicos, así se puede
# identificar y borrar sin afectar el resto del archivo.
existe_sesion() {
    local nombre="$1"
    grep -q "# ==== INICIO Sesión $nombre (termux-forge) ====" "$BASHRC" 2>/dev/null
}

insertar_sesion() {
    local nombre="$1"
    local contenido="$2"
    if existe_sesion "$nombre"; then
        eliminar_sesion "$nombre" "silencioso"
    fi
    {
        echo ""
        echo "# ==== INICIO Sesión $nombre (termux-forge) ===="
        echo -e "$contenido"
        echo "# ==== FIN Sesión $nombre (termux-forge) ===="
    } >> "$BASHRC"
}

eliminar_sesion() {
    local nombre="$1"
    local modo="$2"
    if existe_sesion "$nombre"; then
        sed -i "/# ==== INICIO Sesión $nombre (termux-forge) ====/,/# ==== FIN Sesión $nombre (termux-forge) ====/d" "$BASHRC"
        [ "$modo" != "silencioso" ] && echo -e "${GREEN}✔ Sesión '$nombre' eliminada.${RESET}"
    else
        [ "$modo" != "silencioso" ] && echo -e "${YELLOW}No se encontró la sesión '$nombre'.${RESET}"
    fi
}

# ---------- Módulos ----------
instalar_paquetes() {
    local modo="$1"
    [ "$modo" != "todo" ] && banner
    echo -e "${GREEN}▶ Instalando paquetes esenciales...${RESET}"
    pkg update -y && pkg upgrade -y
    PAQUETES="git python nodejs vim curl wget openssh nano tree unzip"
    pkg install -y $PAQUETES
    for p in $PAQUETES; do
        grep -qx "$p" "$PAQUETES_FILE" || echo "$p" >> "$PAQUETES_FILE"
    done
    echo -e "${GREEN}✔ Paquetes instalados correctamente.${RESET}"
    [ "$modo" != "todo" ] && pausa
}

desinstalar_paquetes() {
    banner
    if [ ! -s "$PAQUETES_FILE" ]; then
        echo -e "${YELLOW}No hay paquetes registrados por termux-forge para desinstalar.${RESET}"
        pausa
        return
    fi
    echo -e "${RED}Paquetes instalados por termux-forge:${RESET}"
    cat "$PAQUETES_FILE"
    echo ""
    read -p "$(echo -e "${BOLD}¿Desinstalar TODOS estos paquetes? (s/n): ${RESET}")" confirmar
    if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
        pkg uninstall -y $(cat "$PAQUETES_FILE")
        > "$PAQUETES_FILE"
        echo -e "${GREEN}✔ Paquetes desinstalados y registro limpiado.${RESET}"
    else
        echo -e "${YELLOW}Cancelado.${RESET}"
    fi
    pausa
}

configurar_alias() {
    local modo="$1"
    [ "$modo" != "todo" ] && banner
    echo -e "${GREEN}▶ Configurando alias útiles...${RESET}"
    CONTENIDO="alias ll='ls -la --color=auto'\n"
    CONTENIDO+="alias update='echo \"🔄 Actualizando sistema...\" && pkg update -y && pkg upgrade -y'\n"
    CONTENIDO+="alias gs='echo \"📡 Estado del repo:\" && git status'\n"
    CONTENIDO+="alias gp='echo \"🚀 Subiendo cambios...\" && git push'\n"
    CONTENIDO+="alias yo='echo \"🪪 Identidad actual: \$(cat \$HOME/.termux-forge/identidad.conf 2>/dev/null || echo Termux Forge)\"'\n"
    CONTENIDO+="alias inicio='clear && bash \$HOME/.termux-forge/mostrar_banner.sh 2>/dev/null'"
    insertar_sesion "alias" "$CONTENIDO"
    echo -e "${GREEN}✔ Alias configurados (fuente: source ~/.bashrc para aplicar ya mismo).${RESET}"
    [ "$modo" != "todo" ] && pausa
}

configurar_prompt() {
    local modo="$1"
    [ "$modo" != "todo" ] && banner
    echo -e "${GREEN}▶ Personalizando prompt...${RESET}"
    cargar_identidad
    local slug=$(echo "$IDENTIDAD" | tr -d ' ' | cut -c1-16)
    [ -z "$slug" ] && slug="termux-forge"
    CONTENIDO="export PS1=\"\\[\\033[1;36m\\]\\u@${slug}\\[\\033[0m\\]:\\[\\033[1;33m\\]\\w\\[\\033[0m\\]\\\$ \""
    insertar_sesion "prompt" "$CONTENIDO"
    echo -e "${GREEN}✔ Prompt configurado con identidad: ${slug}${RESET}"
    [ "$modo" != "todo" ] && pausa
}

generar_mostrar_banner() {
    local tema=$(cat "$TEMA_FILE" 2>/dev/null || echo "magenta")
    local identidad=$(cat "$IDENTIDAD_FILE" 2>/dev/null || echo "Termux Forge")

    case "$tema" in
        matrix) c1='1;32'; c2='0;32'; c3='1;37' ;;
        cyberpunk) c1='1;34'; c2='1;36'; c3='1;35' ;;
        fuego) c1='1;31'; c2='1;33'; c3='0;31' ;;
        synthwave) c1='1;35'; c2='1;36'; c3='1;34' ;;
        magenta|*) c1='1;35'; c2='1;36'; c3='1;33' ;;
    esac

    cat > "$CONFIG_DIR/mostrar_banner.sh" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# Banner de bienvenida generado por termux-forge
echo -e "\033[${c1}m"
echo "  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
echo "  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝"
echo "     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ "
echo "     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ "
echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗"
echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
echo -e "\033[${c2}m                     F O R G E \033[0m"
echo -e "\033[${c3}m        Configura tu entorno Termux en segundos\033[0m"
echo -e "\033[1m                  ✦ ${identidad} ✦\033[0m"
EOF
    chmod +x "$CONFIG_DIR/mostrar_banner.sh"

    insertar_sesion "banner" "bash \"\$HOME/.termux-forge/mostrar_banner.sh\""
}

configurar_identidad() {
    banner
    cargar_identidad
    echo -e "${BOLD}Elegí un nombre/identidad para tu Termux:${RESET}"
    echo -e "${YELLOW}(Aparece en el banner y queda disponible con el alias 'yo')${RESET}"
    echo -e "Actual: ${IDENTIDAD}"
    echo ""
    read -p "$(echo -e "${BOLD}> ${RESET}")" nombre
    [ -z "$nombre" ] && nombre="Termux Forge"
    echo "$nombre" > "$IDENTIDAD_FILE"

    generar_mostrar_banner
    if existe_sesion "prompt"; then
        configurar_prompt "todo"
    fi

    echo -e "${GREEN}✔ Identidad '${nombre}' aplicada al banner y al prompt.${RESET}"
    pausa
}

personalizar_banner() {
    banner
    echo -e "${BOLD}Elegí un tema de color para el banner:${RESET}"
    echo -e "  1) Magenta Neón   (default, estilo actual)"
    echo -e "  2) Matrix         (verde clásico hacker)"
    echo -e "  3) Cyberpunk      (azul / violeta)"
    echo -e "  4) Fuego          (rojo / naranja)"
    echo -e "  5) Synthwave      (violeta / rosa)"
    echo ""
    read -p "$(echo -e "${BOLD}> ${RESET}")" opcion_tema

    case $opcion_tema in
        1) tema="magenta" ;;
        2) tema="matrix" ;;
        3) tema="cyberpunk" ;;
        4) tema="fuego" ;;
        5) tema="synthwave" ;;
        *) echo -e "${RED}Opción inválida.${RESET}"; pausa; return ;;
    esac

    echo "$tema" > "$TEMA_FILE"
    generar_mostrar_banner
    echo -e "${GREEN}✔ Tema '${tema}' aplicado. Se verá al abrir una nueva sesión de Termux.${RESET}"
    pausa
}

instalar_todo() {
    banner
    echo -e "${BOLD}▶ Iniciando instalación completa...${RESET}"
    echo ""
    instalar_paquetes "todo"
    echo ""
    configurar_alias "todo"
    echo ""
    configurar_prompt "todo"
    echo ""
    echo -e "${GREEN}✔ Instalación completa. Reinicia Termux o corré: source ~/.bashrc${RESET}"
    pausa
}

salir() {
    echo -e "${BOLD}Gracias por usar termux-forge. ¡Hasta la próxima!${RESET}"
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
        echo -e "  ${YELLOW}4)${RESET} Personalizar identidad (nombre)"
        echo -e "  ${YELLOW}5)${RESET} Personalizar banner (color)"
        echo -e "  ${YELLOW}6)${RESET} Instalar todo (recomendado)"
        echo -e "  ${YELLOW}7)${RESET} Desinstalar paquetes instalados"
        echo -e "  ${YELLOW}8)${RESET} Salir"
        echo ""
        read -p "$(echo -e "${BOLD}> ${RESET}")" opcion

        case $opcion in
            1) instalar_paquetes ;;
            2) configurar_alias ;;
            3) configurar_prompt ;;
            4) configurar_identidad ;;
            5) personalizar_banner ;;
            6) instalar_todo ;;
            7) desinstalar_paquetes ;;
            8) salir ;;
            *) echo -e "${RED}Opción inválida.${RESET}"; sleep 1 ;;
        esac
    done
}

menu
