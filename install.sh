#!/data/data/com.termux/files/usr/bin/bash
# termux-forge - instalador/menú de configuración para Termux
# Repositorio: https://github.com/tuusuario/termux-forge

CONFIG_DIR="$HOME/.termux-forge"
TEMA_FILE="$CONFIG_DIR/tema.conf"
ESTILO_FILE="$CONFIG_DIR/estilo_banner.conf"
IDENTIDAD_FILE="$CONFIG_DIR/identidad.conf"
FIRMA_FILE="$CONFIG_DIR/firma.conf"
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

cargar_estilo() {
    ESTILO="grande"
    [ -f "$ESTILO_FILE" ] && ESTILO=$(cat "$ESTILO_FILE")
}

cargar_identidad() {
    if [ -f "$IDENTIDAD_FILE" ]; then
        IDENTIDAD=$(cat "$IDENTIDAD_FILE")
    else
        IDENTIDAD="Termux Forge"
    fi
}

cargar_firma() {
    if [ -f "$FIRMA_FILE" ]; then
        FIRMA=$(cat "$FIRMA_FILE")
    else
        FIRMA="Ukakō Academia - ciberseguridad"
    fi
}

# ---------- Dibujos de banner ----------
# Comparten estas variables ya cargadas: P1/P2/P3 (colores), FIRMA, BOLD, RESET.
# Se reutilizan tal cual dentro de mostrar_banner.sh (ver generar_mostrar_banner).
dibujar_banner_grande() {
    echo -e "${P1}"
    echo "  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
    echo "  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝"
    echo "     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ "
    echo "     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ "
    echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗"
    echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${P2}                     F O R G E ${RESET}"
    echo -e "${P3}        Configura tu entorno Termux en segundos${RESET}"
    echo -e "${BOLD}                  ✦ ${FIRMA} ✦${RESET}"
}

dibujar_banner_mediano() {
    echo -e "${P1}   ╔═══════════════════════════════╗${RESET}"
    echo -e "${P1}   ║ ${P2}▓▓  T E R M U X   F O R G E  ▓▓${P1} ║${RESET}"
    echo -e "${P1}   ╚═══════════════════════════════╝${RESET}"
    echo -e "${P3}       Tu entorno Termux, a tu medida${RESET}"
    echo -e "${BOLD}            ✦ ${FIRMA} ✦${RESET}"
}

dibujar_banner_chico() {
    echo -e "${P1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${P2}   ✦ TERMUX-FORGE ✦${RESET}"
    echo -e "${P3}   ${FIRMA}${RESET}"
    echo -e "${P1}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

dibujar_banner_espejo() {
    echo -e "${P1}    ┌─────────┐        ┃        ┌──────────────┐${RESET}"
    echo -e "${P2}    │   >_    │        ┃        │  F O R G E   │${RESET}"
    echo -e "${P1}    │ TERMUX  │        ┃        │ (tu reflejo) │${RESET}"
    echo -e "${P1}    └─────────┘        ┃        └──────────────┘${RESET}"
    echo -e "${P3}          todo lo que sos, reflejado en código${RESET}"
    echo -e "${BOLD}                 ✦ ${FIRMA} ✦${RESET}"
}

dibujar_banner_animado() {
    local cols=36
    local filas=5
    local chars='01$%#@*+-<>/'
    local i c linea idx
    for i in $(seq 1 $filas); do
        linea=""
        for c in $(seq 1 $cols); do
            idx=$(( RANDOM % ${#chars} ))
            linea+="${chars:$idx:1}"
        done
        echo -e "${P2}${linea}${RESET}"
        sleep 0.05
    done
    echo ""
    local titulo="T E R M U X   F O R G E"
    echo -ne "${P1}"
    for (( i=0; i<${#titulo}; i++ )); do
        printf "%s" "${titulo:$i:1}"
        sleep 0.02
    done
    echo -e "${RESET}"
    echo -e "${P3}     Configura tu entorno Termux en segundos${RESET}"
    echo -e "${BOLD}          ✦ ${FIRMA} ✦${RESET}"
}

dibujar_banner_segun_estilo() {
    local estilo="$1"
    case "$estilo" in
        mediano) dibujar_banner_mediano ;;
        chico) dibujar_banner_chico ;;
        espejo) dibujar_banner_espejo ;;
        animado) dibujar_banner_animado ;;
        grande|*) dibujar_banner_grande ;;
    esac
}

banner() {
    cargar_tema
    cargar_firma
    cargar_estilo
    clear
    dibujar_banner_segun_estilo "$ESTILO"
    echo ""
}

pausa() {
    echo ""
    read -p "$(echo -e "${BOLD}Presiona ENTER para continuar...${RESET}")"
}

# ---------- Selector interactivo con flechas + vista previa en vivo ----------
# $1: nombre de un array (ya declarado) con las etiquetas a mostrar
# $2: nombre de una función de preview que recibe el índice elegido como argumento
# Devuelve 0 y deja el índice elegido en SELECCION_IDX si se confirma con ENTER.
# Devuelve 1 si se cancela con Q.
seleccionar_con_flechas() {
    local -n _opciones="$1"
    local _preview_fn="$2"
    local _idx=0
    local _total=${#_opciones[@]}
    local _tecla _resto

    tput civis 2>/dev/null
    while true; do
        clear
        "$_preview_fn" "$_idx"
        echo ""
        echo -e "${BOLD}↑/↓ o j/k para moverte · ENTER confirma · Q cancela${RESET}"
        echo ""
        local i
        for i in "${!_opciones[@]}"; do
            if [ "$i" -eq "$_idx" ]; then
                echo -e "  ${GREEN}➤ ${_opciones[$i]}${RESET}"
            else
                echo -e "    ${_opciones[$i]}"
            fi
        done

        IFS= read -rsn1 _tecla
        if [ "$_tecla" = $'\x1b' ]; then
            IFS= read -rsn2 -t 0.05 _resto
            _tecla+="$_resto"
        fi

        case "$_tecla" in
            $'\x1b[A'|k|K) _idx=$(( (_idx - 1 + _total) % _total )) ;;
            $'\x1b[B'|j|J) _idx=$(( (_idx + 1) % _total )) ;;
            "") tput cnorm 2>/dev/null; SELECCION_IDX=$_idx; return 0 ;;
            q|Q) tput cnorm 2>/dev/null; SELECCION_IDX=255; return 1 ;;
        esac
    done
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
    local firma=$(cat "$FIRMA_FILE" 2>/dev/null || echo "Ukakō Academia - ciberseguridad")
    local estilo=$(cat "$ESTILO_FILE" 2>/dev/null || echo "grande")

    case "$tema" in
        matrix) c1='1;32'; c2='0;32'; c3='1;37' ;;
        cyberpunk) c1='1;34'; c2='1;36'; c3='1;35' ;;
        fuego) c1='1;31'; c2='1;33'; c3='0;31' ;;
        synthwave) c1='1;35'; c2='1;36'; c3='1;34' ;;
        magenta|*) c1='1;35'; c2='1;36'; c3='1;33' ;;
    esac

    {
        echo '#!/data/data/com.termux/files/usr/bin/bash'
        echo '# Banner de bienvenida generado por termux-forge - no editar a mano'
        echo "RESET='\033[0m'"
        echo "BOLD='\033[1m'"
        echo "P1='\033[${c1}m'"
        echo "P2='\033[${c2}m'"
        echo "P3='\033[${c3}m'"
        printf 'FIRMA=%q\n' "$firma"
        declare -f dibujar_banner_grande
        declare -f dibujar_banner_mediano
        declare -f dibujar_banner_chico
        declare -f dibujar_banner_espejo
        declare -f dibujar_banner_animado
        declare -f dibujar_banner_segun_estilo
        printf 'dibujar_banner_segun_estilo %q\n' "$estilo"
    } > "$CONFIG_DIR/mostrar_banner.sh"

    chmod +x "$CONFIG_DIR/mostrar_banner.sh"
    insertar_sesion "banner" "bash \"\$HOME/.termux-forge/mostrar_banner.sh\""
}

configurar_firma() {
    banner
    echo -e "${BOLD}Elegí la firma que aparece en la bienvenida:${RESET}"
    echo -e "${YELLOW}Actual: ${FIRMA}${RESET}"
    echo ""
    read -p "$(echo -e "${BOLD}> ${RESET}")" texto
    [ -z "$texto" ] && texto="Ukakō Academia - ciberseguridad"
    echo "$texto" > "$FIRMA_FILE"
    generar_mostrar_banner
    echo -e "${GREEN}✔ Firma actualizada: ${texto}${RESET}"
    pausa
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
    cargar_tema
    cargar_firma
    cargar_estilo

    local temas_keys=(magenta matrix cyberpunk fuego synthwave)
    local temas_labels=(
        "Magenta Neón (default)"
        "Matrix (verde clásico hacker)"
        "Cyberpunk (azul / violeta)"
        "Fuego (rojo / naranja)"
        "Synthwave (violeta / rosa)"
    )

    preview_tema() {
        local i="$1"
        case "${temas_keys[$i]}" in
            matrix) P1='\033[1;32m'; P2='\033[0;32m'; P3='\033[1;37m' ;;
            cyberpunk) P1='\033[1;34m'; P2='\033[1;36m'; P3='\033[1;35m' ;;
            fuego) P1='\033[1;31m'; P2='\033[1;33m'; P3='\033[0;31m' ;;
            synthwave) P1='\033[1;35m'; P2='\033[1;36m'; P3='\033[1;34m' ;;
            magenta|*) P1='\033[1;35m'; P2='\033[1;36m'; P3='\033[1;33m' ;;
        esac
        echo -e "${BOLD}Vista previa — ${temas_labels[$i]}${RESET}"
        echo ""
        dibujar_banner_segun_estilo "$ESTILO"
    }

    if seleccionar_con_flechas temas_labels preview_tema; then
        tema="${temas_keys[$SELECCION_IDX]}"
        echo "$tema" > "$TEMA_FILE"
        generar_mostrar_banner
        cargar_tema
        banner
        echo -e "${GREEN}✔ Tema '${tema}' aplicado. Se verá al abrir una nueva sesión de Termux.${RESET}"
    else
        clear
        echo -e "${YELLOW}Cancelado, se mantiene el tema anterior.${RESET}"
    fi
    pausa
}

personalizar_estilo_banner() {
    cargar_tema
    cargar_firma
    cargar_estilo

    local estilos_keys=(grande mediano chico espejo animado)
    local estilos_labels=(
        "Grande (bloques ASCII, el clásico)"
        "Mediano (más compacto)"
        "Chico (una línea, minimalista)"
        "Espejo (Termux se mira y refleja FORGE)"
        "Animado (lluvia digital + título apareciendo)"
    )

    preview_estilo() {
        local i="$1"
        echo -e "${BOLD}Vista previa — ${estilos_labels[$i]}${RESET}"
        echo ""
        dibujar_banner_segun_estilo "${estilos_keys[$i]}"
    }

    if seleccionar_con_flechas estilos_labels preview_estilo; then
        estilo="${estilos_keys[$SELECCION_IDX]}"
        echo "$estilo" > "$ESTILO_FILE"
        generar_mostrar_banner
        cargar_estilo
        banner
        echo -e "${GREEN}✔ Estilo de banner '${estilo}' aplicado. Se verá al abrir una nueva sesión de Termux.${RESET}"
    else
        clear
        echo -e "${YELLOW}Cancelado, se mantiene el estilo anterior.${RESET}"
    fi
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
    generar_mostrar_banner
    echo -e "${GREEN}✔ Banner de bienvenida activado para nuevas sesiones.${RESET}"
    echo ""
    echo -e "${GREEN}✔ Instalación completa. Reinicia Termux o corré: source ~/.bashrc${RESET}"
    pausa
}

salir() {
    echo -e "${BOLD}Gracias por usar termux-forge. ¡Hasta la próxima!${RESET}"
    exit 0
}

# Asegura que exista un banner de bienvenida desde el primer uso,
# aunque el usuario nunca entre a los menús de personalización
# (esto es lo que corregía el bug de "instalar todo").
[ ! -f "$CONFIG_DIR/mostrar_banner.sh" ] && generar_mostrar_banner

# ---------- Menú principal ----------
menu() {
    while true; do
        banner
        echo -e "${BOLD}Elegí una opción:${RESET}"
        echo -e "  ${YELLOW}1)${RESET} Instalar paquetes esenciales"
        echo -e "  ${YELLOW}2)${RESET} Configurar alias"
        echo -e "  ${YELLOW}3)${RESET} Personalizar prompt"
        echo -e "  ${YELLOW}4)${RESET} Personalizar identidad (nombre)"
        echo -e "  ${YELLOW}5)${RESET} Personalizar firma (bienvenida)"
        echo -e "  ${YELLOW}6)${RESET} Personalizar banner (color)"
        echo -e "  ${YELLOW}7)${RESET} Tamaño / estilo del banner"
        echo -e "  ${YELLOW}8)${RESET} Instalar todo (recomendado)"
        echo -e "  ${YELLOW}9)${RESET} Desinstalar paquetes instalados"
        echo -e "  ${YELLOW}10)${RESET} Salir"
        echo ""
        read -p "$(echo -e "${BOLD}> ${RESET}")" opcion

        case $opcion in
            1) instalar_paquetes ;;
            2) configurar_alias ;;
            3) configurar_prompt ;;
            4) configurar_identidad ;;
            5) configurar_firma ;;
            6) personalizar_banner ;;
            7) personalizar_estilo_banner ;;
            8) instalar_todo ;;
            9) desinstalar_paquetes ;;
            10) salir ;;
            *) echo -e "${RED}Opción inválida.${RESET}"; sleep 1 ;;
        esac
    done
}

menu
