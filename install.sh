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

# ---------- Cambio de Logo (banners temáticos) ----------
# Cada uno es independiente del tema de color elegido (usan sus propios
# colores "reales": rojo para el corazón, azul para los arándanos, etc.)
# pero siempre cierran con la marca de Ukakō Academia.
dibujar_banner_logo_dado() {
    local Bl2=$'\033[1;37m' Bl=$'\033[0;37m' Rj=$'\033[1;31m' RESET=$'\033[0m'
    echo -e "      ${Bl2}+-----------------+${RESET}"
    echo -e "     ${Bl2}/                 /|${RESET}"
    echo -e "    ${Bl}+-----------------+ ${Bl}|${RESET}"
    echo -e "    ${Bl}|                 | ${Bl}|${RESET}"
    echo -e "    ${Bl}|    ${Rj}●${Bl}       ${Rj}●${Bl}    | ${Bl}|${RESET}"
    echo -e "    ${Bl}|                 | ${Bl}|${RESET}"
    echo -e "    ${Bl}|    ${Rj}●${Bl}       ${Rj}●${Bl}    | ${Bl}|${RESET}"
    echo -e "    ${Bl}|                 | ${Bl}|${RESET}"
    echo -e "    ${Bl}|    ${Rj}●${Bl}       ${Rj}●${Bl}    | ${Bl}|${RESET}"
    echo -e "    ${Bl}|                 | ${Bl}|${RESET}"
    echo -e "    ${Bl}+-----------------+ ${Bl}/${RESET}"
    echo -e ""
    echo -e "${BOLD}      ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_logo_cubo_armado() {
    local Bl2=$'\033[1;37m' Bl=$'\033[0;37m' Gr=$'\033[1;30m' Am=$'\033[1;33m' RESET=$'\033[0m'
    echo -e "      ${Bl2}+---------------+${RESET}"
    echo -e "     ${Bl2}/               /|${RESET}"
    echo -e "    ${Bl}+---------------+ ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ┌───┬───┬───┐ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Am}███${Gr}│${Am}███${Gr}│${Am}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ├───┼───┼───┤ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Am}███${Gr}│${Am}███${Gr}│${Am}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ├───┼───┼───┤ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Am}███${Gr}│${Am}███${Gr}│${Am}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} └───┴───┴───┘ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}+---------------+ ${Bl}/${RESET}"
    echo -e ""
    echo -e "${BOLD}      Cubo Rubik: armado${RESET}"
    echo -e "${BOLD}   ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_logo_cubo_desarmado() {
    local Bl2=$'\033[1;37m' Bl=$'\033[0;37m' Gr=$'\033[1;30m' Rj=$'\033[1;31m' Am=$'\033[1;33m' Az=$'\033[1;34m' Vd=$'\033[1;32m' Bl3=$'\033[1;37m' Nj=$'\033[38;5;208m' RESET=$'\033[0m'
    echo -e "      ${Bl2}+---------------+${RESET}"
    echo -e "     ${Bl2}/               /|${RESET}"
    echo -e "    ${Bl}+---------------+ ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ┌───┬───┬───┐ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Rj}███${Gr}│${Am}███${Gr}│${Az}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ├───┼───┼───┤ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Vd}███${Gr}│${Bl3}███${Gr}│${Nj}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} ├───┼───┼───┤ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} │${Am}███${Gr}│${Az}███${Gr}│${Rj}███${Gr}│ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}|${Gr} └───┴───┴───┘ ${Bl}| ${Bl}|${RESET}"
    echo -e "    ${Bl}+---------------+ ${Bl}/${RESET}"
    echo -e ""
    echo -e "${BOLD}      Cubo Rubik: desarmado${RESET}"
    echo -e "${BOLD}   ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_logo_cruz() {
    local Am=$'\033[1;33m' Bl=$'\033[1;37m' Am2=$'\033[0;33m' RESET=$'\033[0m'
    echo -e "              ${Am}|${RESET}"
    echo -e "          ${Am}\\   ${Am}|   ${Am}/${RESET}"
    echo -e "            ${Am}\\ ${Am}| ${Am}/${RESET}"
    echo -e "         ${Am}-- ${Am}--@-- ${Am}--${RESET}"
    echo -e "            ${Am}/ ${Am}| ${Am}\\${RESET}"
    echo -e "          ${Am}/   ${Am}|   ${Am}\\${RESET}"
    echo -e "              ${Am}|${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e "         ${Am2}▓▓▓▓▓▓▓▓▓▓▓${RESET}"
    echo -e "         ${Bl}███████████${RESET}"
    echo -e "         ${Bl}███████████${RESET}"
    echo -e "         ${Am2}▓▓▓▓▓▓▓▓▓▓▓${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e "             ${Am2}▓${Bl}█${Am2}▓${RESET}"
    echo -e ""
    echo -e "${BOLD}         ✦ Ukakō Academia ✦${RESET}"
    echo -e "${BOLD}           Para el Señor${RESET}"
}

dibujar_banner_logo_corazon() {
    local Rb=$'\033[0;31m' Rf=$'\033[1;31m' Bh=$'\033[1;37m' RESET=$'\033[0m'
    echo -e "    ${Rb}▓${Bh}░░░${Rb}▓▓▓ ${Rb}▓▓▓▓▓${Rf}█${Rb}▓${RESET}"
    echo -e "  ${Rb}▓▓${Bh}░░░░${Rb}▓▓▓▓▓▓▓▓▓▓▓▓▓${RESET}"
    echo -e "  ${Rb}▓▓▓▓▓▓▓${Rf}█████${Rb}▓▓▓▓▓▓▓${RESET}"
    echo -e "   ${Rb}▓▓▓▓${Rf}█████████${Rb}▓▓▓▓${RESET}"
    echo -e "    ${Rb}▓▓▓${Rf}█████████${Rb}▓▓▓${RESET}"
    echo -e "      ${Rb}▓▓▓▓${Rf}███${Rb}▓▓▓▓${RESET}"
    echo -e "          ${Rb}▓▓▓${RESET}"
    echo -e ""
    echo -e "${BOLD}   ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_logo_flor() {
    local Bl=$'\033[1;37m' Rs=$'\033[1;35m' Vd=$'\033[1;32m' RESET=$'\033[0m'
    echo -e "          ${Bl}✿${RESET}"
    echo -e "       ${Bl}✿     ${Bl}✿${RESET}"
    echo -e "          ${Rs}❀${RESET}"
    echo -e "        ${Bl}✿ ${Vd}│ ${Bl}✿${RESET}"
    echo -e "         ${Vd}⎯│⎯${RESET}"
    echo -e "        ${Vd}╲_│_╱${RESET}"
    echo -e "          ${Vd}│${RESET}"
    echo -e "          ${Vd}│${RESET}"
    echo -e "          ${Vd}│${RESET}"
    echo -e "          ${Vd}│${RESET}"
    echo -e ""
    echo -e "${BOLD}   ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_logo_claude() {
    local Nj=$'\033[38;5;209m' Nj2=$'\033[1;38;5;208m' RESET=$'\033[0m'
    echo -e "            ${Nj}|${RESET}"
    echo -e "        ${Nj}\\   ${Nj}|   ${Nj}/${RESET}"
    echo -e "          ${Nj}\\ ${Nj}| ${Nj}/${RESET}"
    echo -e "       ${Nj}-- ${Nj}--${Nj2}✻${Nj}-- ${Nj}--${RESET}"
    echo -e "          ${Nj}/ ${Nj}| ${Nj}\\${RESET}"
    echo -e "        ${Nj}/   ${Nj}|   ${Nj}\\${RESET}"
    echo -e "            ${Nj}|${RESET}"
    echo -e ""
    echo -e "${BOLD}   ✦ En homenaje a Claude (Anthropic) ✦${RESET}"
    echo -e "${BOLD}     Ukakō Academia - ciberseguridad${RESET}"
}

dibujar_banner_logo_arandanos() {
    local Vd=$'\033[1;32m' Br=$'\033[1;36m' Az=$'\033[1;34m' RESET=$'\033[0m'
    echo -e "          ${Vd}/│\\${RESET}"
    echo -e "         ${Vd}‾   ${Vd}‾${RESET}"
    echo -e "          ${Br}˚${Az}●${Br}˚${RESET}"
    echo -e "     ${Br}˚${Az}● ${Br}˚${Az}●   ${Az}●${Br}˚ ${Az}●${Br}˚${RESET}"
    echo -e "    ${Br}˚${Az}● ${Br}˚${Az}●     ${Az}●${Br}˚ ${Az}●${Br}˚${RESET}"
    echo -e "      ${Br}˚${Az}● ${Br}˚${Az}● ${Az}●${Br}˚ ${Az}●${Br}˚${RESET}"
    echo -e ""
    echo -e "${BOLD}   ✦ Ukakō Academia - ciberseguridad ✦${RESET}"
}

dibujar_banner_segun_estilo() {
    local estilo="$1"
    case "$estilo" in
        mediano) dibujar_banner_mediano ;;
        chico) dibujar_banner_chico ;;
        espejo) dibujar_banner_espejo ;;
        animado) dibujar_banner_animado ;;
        dado) dibujar_banner_logo_dado ;;
        cubo_armado) dibujar_banner_logo_cubo_armado ;;
        cubo_desarmado) dibujar_banner_logo_cubo_desarmado ;;
        cruz) dibujar_banner_logo_cruz ;;
        corazon) dibujar_banner_logo_corazon ;;
        flor) dibujar_banner_logo_flor ;;
        claude) dibujar_banner_logo_claude ;;
        arandanos) dibujar_banner_logo_arandanos ;;
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

# ---------- Catálogo de herramientas de ciberseguridad (datos) ----------
# Fuente: catálogo interno de Ukakō Academia (herramientas por lenguaje de
# programación, 3 niveles de dificultad, 9 herramientas por lenguaje).
# Son todas herramientas de código abierto ya existentes; esta sección solo
# las cataloga y ayuda a instalarlas, no incluye técnicas de explotación.
#
# Formato de cada fila (separado por TAB, no por espacios):
#   Nombre <TAB> Descripción <TAB> Uso básico <TAB> Tipo de instalación <TAB> Argumento
# Tipo puede ser: pkg | pip | npm | gem | cargo | go | manual
#   - pkg/pip/npm/gem/cargo/go -> Argumento es el nombre del paquete a instalar.
#   - manual -> Argumento es una nota explicando por qué no hay instalación de
#     un solo comando (apps gráficas pesadas, plataformas de servidor, scripts
#     sueltos que se descargan del repositorio, etc).
# Para sumar una herramienta nueva: agregá una fila al array del lenguaje y
# nivel que corresponda, respetando este formato.

declare -A NOMBRE_IDIOMA_CATALOGO=(
    [c]="C"
    [cpp]="C++"
    [python]="Python"
    [sql]="SQL"
    [js]="JavaScript / Node.js"
    [ruby]="Ruby"
    [php]="PHP"
    [go]="Go"
    [rust]="Rust"
    [perl]="Perl"
    [lua]="Lua"
    [java]="Java"
    [r]="R"
    [bash]="Bash"
)
ORDEN_IDIOMAS_CATALOGO=(c cpp python sql js ruby php go rust perl lua java r bash)

TOOLS_c_basico=(
$'Netcat\tHerramienta de red minimalista para abrir conexiones TCP/UDP, transferir datos y probar puertos.\tPara conectarte: nc <host> <puerto>. Para escuchar conexiones entrantes: nc -lvp <puerto>. Sirve tanto para comprobar si un puerto está abierto como para mandar datos crudos entre dos equipos.\tpkg\tnetcat-openbsd'
$'tcpdump\tCaptura y analiza tráfico de red directamente desde la terminal.\ttcpdump -i <interfaz> muestra el tráfico en vivo; agregando -w <archivo.pcap> lo guarda para revisarlo después, por ejemplo en Wireshark.\tpkg\ttcpdump'
$'Hydra\tAtaques de fuerza bruta contra credenciales en múltiples protocolos (SSH, FTP, HTTP, etc.).\thydra -l <usuario> -P <diccionario> <protocolo>://<host> prueba una lista de contraseñas contra un servicio. Pensada exclusivamente para sistemas propios o de laboratorio, nunca contra servicios de terceros sin autorización.\tpkg\thydra'
)
TOOLS_c_medio=(
$'OpenSSL (CLI)\tManejo de certificados, cifrado y pruebas de conexiones TLS/SSL.\topenssl s_client -connect <host>:443 inspecciona el certificado de un sitio; openssl enc -aes-256-cbc -in <archivo> -out <archivo.enc> cifra un archivo desde la terminal.\tpkg\topenssl-tool'
$'Ettercap\tAtaques Man-in-the-Middle, ARP spoofing y sniffing de credenciales en una red.\tSe usa en modo texto con ettercap -T -i <interfaz>, siempre dentro de una red propia de laboratorio: en una red ajena, interceptar tráfico de otros equipos sin autorización es ilegal.\tmanual\tNo tiene paquete estable para Termux/Android; se compila desde el código fuente o se prueba mejor en una VM Linux tradicional.'
$'Suricata\tMotor de detección/prevención de intrusiones (IDS/IPS) con inspección profunda de paquetes.\tCorre como servicio, analizando una interfaz o un archivo de captura contra un set de reglas: suricata -i <interfaz> -c <suricata.yaml>.\tmanual\tPensado para correr como servicio de servidor/firewall; no tiene paquete oficial de Termux, conviene probarlo en una VM o servidor Linux.'
)
TOOLS_c_avanzado=(
$'Aircrack-ng\tSuite para auditar seguridad de redes Wi-Fi (captura de handshakes, cracking WEP/WPA).\tSe combina con airmon-ng (modo monitor) y airodump-ng (captura) antes de correr aircrack-ng sobre el archivo capturado con un diccionario. En Android sin root, el modo monitor casi siempre está bloqueado por el driver Wi-Fi del fabricante, así que la captura real suele no funcionar en un celular normal.\tpkg\taircrack-ng'
$'Snort\tSistema de detección de intrusiones basado en reglas, uno de los más usados de la industria.\tsnort -i <interfaz> -c <snort.conf> analiza tráfico en vivo contra un set de reglas; suele empezarse practicando con reglas ya escritas antes de crear las propias.\tmanual\tNo tiene paquete oficial de Termux; se usa tradicionalmente en un servidor o VM Linux dedicado.'
$'John the Ripper\tCracking de contraseñas mediante diccionario y fuerza bruta sobre hashes.\tjohn --wordlist=<diccionario> <archivo_hashes> prueba contraseñas de una lista contra hashes ya obtenidos, por ejemplo de tu propio sistema, para auditar qué tan fuertes son.\tpkg\tjohn'
)

TOOLS_cpp_basico=(
$'Nmap\tEl escáner de puertos y descubrimiento de hosts más usado en redes.\tnmap -sV <objetivo> escanea puertos abiertos e intenta identificar qué servicio corre en cada uno; es el punto de partida clásico de cualquier reconocimiento de red.\tpkg\tnmap'
$'Wireshark\tAnálisis profundo de tráfico de red con interfaz gráfica, decodifica cientos de protocolos.\tEn Termux se usa su versión de terminal, tshark: tshark -i <interfaz>. La interfaz gráfica completa necesita un entorno X11 (Termux:X11) o conviene usarla directamente en una PC.\tpkg\ttshark'
$'ClamAV\tAntivirus/antimalware de código abierto para escanear archivos y correo.\tfreshclam actualiza las firmas de virus, y clamscan -r <carpeta> escanea un directorio completo en busca de archivos maliciosos ya conocidos.\tpkg\tclamav'
)
TOOLS_cpp_medio=(
$'YARA\tMotor de reglas para identificar y clasificar malware, muy usado en análisis forense.\tyara <regla.yar> <archivo_o_carpeta> aplica una regla de detección; las reglas describen patrones característicos de una familia de malware.\tpkg\tyara'
$'Capstone\tMotor de desensamblado usado como base de muchas herramientas de ingeniería inversa.\tSe usa sobre todo como librería dentro de scripts (Python, C) para desensamblar binarios de forma programática, más que como comando suelto.\tpip\tcapstone'
$'Zeek\tMonitor de seguridad de red para análisis profundo de tráfico y detección de amenazas.\tzeek -i <interfaz> o zeek -r <archivo.pcap> genera logs detallados (conexiones, DNS, HTTP) para analizar patrones de tráfico.\tmanual\tNo tiene paquete oficial de Termux; por sus requisitos de recursos se usa habitualmente en un servidor Linux dedicado.'
)
TOOLS_cpp_avanzado=(
$'Radare2\tFramework de ingeniería inversa: desensamblado, debugging y análisis binario.\tr2 <archivo> abre un binario para analizarlo; dentro de su consola, aaa (analizar todo) y pdf (desensamblar función) son el punto de partida típico.\tpkg\tradare2'
$'Cutter\tInterfaz gráfica para Radare2, facilita el análisis de binarios sin usar solo la terminal.\tEs la versión con ventanas de Radare2; necesita un entorno gráfico (Termux:X11) para correr en el celular, así que en Termux puro conviene quedarse con r2 en modo texto.\tmanual\tNecesita entorno gráfico (X11); en Termux se aprovecha mejor su base, Radare2, en modo texto.'
$'LIEF\tLibrería para analizar y modificar binarios ELF, PE y Mach-O en profundidad.\tSe usa sobre todo importándola en scripts de Python (import lief) para leer o editar la estructura interna de un ejecutable.\tpip\tlief'
)

TOOLS_python_basico=(
$'theHarvester\tRecolecta correos, subdominios y datos públicos de una organización (OSINT).\ttheHarvester -d <dominio> -b google reúne información pública sobre un dominio desde varias fuentes; pensada para reconocimiento pasivo y autorizado.\tpip\ttheHarvester'
$'Sherlock\tBusca un nombre de usuario en decenas de redes sociales a la vez.\tpython3 sherlock.py <usuario> revisa si ese nombre existe en múltiples plataformas; útil en investigaciones OSINT sobre cuentas propias o con consentimiento.\tmanual\tSe instala clonando su repositorio (git clone) y con pip install -r requirements.txt; no está publicado como paquete suelto en pip.'
$'Recon-ng\tFramework modular de reconocimiento OSINT con módulos intercambiables.\trecon-ng abre una consola similar a Metasploit donde se cargan módulos (modules load) para automatizar tareas de reconocimiento sobre un dominio u organización.\tpip\trecon-ng'
)
TOOLS_python_medio=(
$'Scapy\tCreación y manipulación de paquetes de red a bajo nivel, ideal para entender protocolos.\tSe usa como librería de Python (from scapy.all import *) para construir, enviar y analizar paquetes a mano; una de las mejores formas de aprender cómo funcionan los protocolos por dentro.\tpip\tscapy'
$'sqlmap\tDetecta y explota automáticamente vulnerabilidades de inyección SQL.\tsqlmap -u <URL_con_parametro> --batch prueba automáticamente si un parámetro es inyectable. Pensado exclusivamente para aplicaciones propias o de laboratorio, como DVWA.\tpip\tsqlmap'
$'mitmproxy\tProxy interceptor para analizar y modificar tráfico HTTP/HTTPS en tiempo real.\tmitmproxy levanta un proxy interactivo en la terminal; configurando el dispositivo para usarlo como proxy, se puede inspeccionar el tráfico app por app, en un dispositivo propio.\tpip\tmitmproxy'
)
TOOLS_python_avanzado=(
$'Impacket\tClases Python para protocolos de Windows, clave en post-explotación de Active Directory.\tIncluye scripts listos como secretsdump.py o psexec.py, que se ejecutan con python3 <script.py> <credenciales>@<host>, siempre dentro de un laboratorio propio de Active Directory.\tpip\timpacket'
$'Volatility3\tFramework de análisis forense de memoria RAM.\tvol -f <volcado.mem> <plugin> analiza un volcado de memoria ya capturado para extraer procesos, conexiones o artefactos; es una herramienta puramente forense, no de captura.\tpip\tvolatility3'
$'Empire\tFramework de post-explotación con agentes en Python y PowerShell.\tSe administra desde una consola tipo Metasploit para gestionar agentes en máquinas de laboratorio ya comprometidas de forma autorizada, como en un CTF.\tmanual\tSe instala clonando su repositorio y corriendo su script de setup; es un framework pesado pensado para laboratorios dedicados, no para uso casual en el celular.'
)

TOOLS_sql_basico=(
$'sqlite3 (CLI)\tMotor de bases de datos embebido, para abrir y consultar archivos .db extraídos de apps (WhatsApp, navegadores, Android).\tsqlite3 <archivo.db> abre la base; adentro, .tables lista las tablas y SELECT * FROM <tabla>; corre una consulta normal.\tpkg\tsqlite'
$'Cliente mysql\tConexión y consulta de bases de datos MySQL/MariaDB remotas desde la terminal.\tmysql -u <usuario> -p -h <host> se conecta a un servidor MySQL/MariaDB para correr consultas SQL normales.\tpkg\tmariadb'
$'Cliente psql\tConexión y consulta de bases de datos PostgreSQL desde la terminal.\tpsql -U <usuario> -h <host> -d <basededatos> abre una sesión interactiva para correr consultas SQL contra Postgres.\tpkg\tpostgresql'
)
TOOLS_sql_medio=(
$'osquery\tPermite consultar el propio sistema operativo (procesos, archivos, red) con sintaxis SQL; usado en threat hunting.\tosqueryi abre una consola donde se escribe, por ejemplo, SELECT * FROM processes; para listar procesos como si fueran filas de una tabla.\tmanual\tPensado para monitorear equipos de escritorio/servidor; no tiene paquete oficial para Termux/Android.'
$'mycli / pgcli\tClientes de base de datos con autocompletado y resaltado de sintaxis, mejoran la auditoría desde terminal.\tSe usan igual que mysql/psql (mycli -u <usuario> -h <host>, pgcli -U <usuario> -h <host>) pero con autocompletado de tablas y columnas mientras se escribe.\tpip\tmycli pgcli'
$'DB Browser for SQLite\tHerramienta gráfica para explorar y editar bases de datos SQLite.\tEs una app de escritorio con ventanas para abrir un archivo .db y navegarlo visualmente; en el celular, sqlite3 (CLI) cumple un rol equivalente sin interfaz gráfica.\tmanual\tAplicación gráfica de escritorio; no aplica a Termux, se usa en PC.'
)
TOOLS_sql_avanzado=(
$'sqlmap\tExplotación automatizada de inyección SQL (ver el detalle completo en la sección de Python).\tMismo uso que en la sección Python: sqlmap -u <URL> --batch, sobre aplicaciones propias o de laboratorio.\tpip\tsqlmap'
$'Metasploit (módulos db_*)\tAuditoría y explotación de bases MySQL/MSSQL/PostgreSQL expuestas en una red.\tDentro de msfconsole, comandos como db_nmap o módulos como auxiliary/scanner/mysql/ sirven para identificar bases de datos mal configuradas en tu propia red de laboratorio.\tmanual\tMetasploit Framework no tiene instalación de un solo comando en Termux; requiere un script de instalación especial para Android o correrlo en una VM/servidor Linux.'
$'jSQL Injection\tHerramienta con interfaz gráfica (Java) para explotación automatizada de inyección SQL.\tEs una app de escritorio en Java: se abre el .jar, se ingresa la URL objetivo, y detecta parámetros inyectables por interfaz gráfica.\tmanual\tAplicación gráfica en Java pensada para PC; en Termux, sqlmap cumple una función equivalente por línea de comandos.'
)

TOOLS_js_basico=(
$'CyberChef\tLa navaja suiza para decodificar, cifrar y transformar datos (Base64, hashes, XOR, etc.).\tEs una app web: se arrastran recetas (operaciones) para transformar un dato paso a paso, por ejemplo decodificar Base64 y después calcular su hash.\tmanual\tEs una aplicación web estática; se usa clonando el repositorio y abriendo el HTML en el navegador, o desde la versión online oficial.'
$'Retire.js\tDetecta librerías JavaScript vulnerables usadas en un sitio web.\tretire --path <./proyecto> revisa las librerías JS de un proyecto y avisa si alguna versión tiene vulnerabilidades conocidas.\tnpm\tretire'
$'npm audit\tAnaliza las dependencias de un proyecto Node.js en busca de vulnerabilidades conocidas.\tSe corre npm audit dentro de la carpeta de un proyecto con package.json.\tmanual\tViene incluido con npm, que se instala junto con Node.js; no requiere instalación aparte.'
)
TOOLS_js_medio=(
$'Puppeteer\tAutomatización de navegador, útil para scraping y pruebas de aplicaciones web.\tSe usa como librería dentro de un proyecto Node para controlar un Chromium headless y automatizar clics, formularios o capturas de pantalla. En Termux puede pesar bastante porque intenta descargar un Chromium completo la primera vez.\tnpm\tpuppeteer'
$'Snyk CLI\tEscaneo de vulnerabilidades en dependencias de proyectos.\tsnyk test dentro de un proyecto revisa sus dependencias contra la base de vulnerabilidades de Snyk; conviene crear una cuenta gratuita para usarlo cómodamente.\tnpm\tsnyk'
$'Wappalyzer CLI\tIdentifica tecnologías, frameworks, CMS y servidores usados por un sitio web.\tEl CLI original quedó discontinuado en varios paquetes de npm; hoy conviene usar la extensión de navegador oficial o buscar el fork de la comunidad mejor mantenido en npm.\tmanual\tLa disponibilidad del paquete de línea de comandos cambia con el tiempo; verificá en npm cuál fork está activo antes de instalar uno.'
)
TOOLS_js_avanzado=(
$'Frida\tInstrumentación dinámica con scripts en JavaScript, para interceptar y modificar funciones en apps y binarios.\tSe instala el cliente con pip y se conecta a un frida-server corriendo en el dispositivo objetivo (por ejemplo, tu propio teléfono en modo desarrollador) para engancharse a funciones de una app en tiempo real.\tpip\tfrida-tools'
$'OWASP Juice Shop\tAplicación web deliberadamente vulnerable en Node.js, para practicar pentesting web.\tSe clona el repositorio, npm install instala las dependencias y npm start la levanta en local (puerto 3000 por defecto) para practicar ataques web en un entorno pensado exactamente para eso.\tmanual\tSe instala clonando el repositorio de GitHub; no es un paquete global de npm.'
$'NodeJsScan\tAnálisis estático de código Node.js en busca de vulnerabilidades.\tAnaliza una carpeta de código fuente y marca patrones inseguros conocidos, por ejemplo el uso peligroso de eval.\tmanual\tEs un proyecto en Python con interfaz web (aunque analiza código Node.js); se instala clonando su repositorio, no es un paquete suelto de npm ni pip.'
)

TOOLS_ruby_basico=(
$'WhatWeb\tIdentifica tecnologías, CMS y versiones que usa un sitio web.\twhatweb <sitio> escanea la web y devuelve qué tecnologías detectó: servidor, CMS, frameworks, analytics.\tpkg\twhatweb'
$'WPScan\tEscáner de vulnerabilidades específico para sitios WordPress.\twpscan --url <sitio> revisa plugins, temas y versión de WordPress en busca de vulnerabilidades conocidas; pensado para sitios propios o de laboratorio.\tgem\twpscan'
$'Arachni\tEscáner de seguridad para aplicaciones web con motor de reglas configurable.\tarachni <sitio> rastrea una aplicación web probando varias clases de vulnerabilidades a la vez. El proyecto lleva años sin mantenimiento activo, así que conseguir un binario actualizado para ARM/Termux es poco confiable.\tmanual\tSin mantenimiento activo desde hace años; como alternativa vigente para este tipo de escaneo conviene mirar OWASP ZAP.'
)
TOOLS_ruby_medio=(
$'Metasploit\tEl framework de explotación más usado, con miles de exploits y módulos auxiliares listos para usar.\tmsfconsole abre su consola interactiva; adentro, use <exploit>, set <opciones> y run ejecutan un módulo contra un objetivo de laboratorio propio.\tmanual\tNo tiene instalación de un solo comando en Termux; requiere un script de instalación específico para Android o correrlo en una VM/servidor Linux.'
$'CeWL\tGenera listas de palabras personalizadas a partir del contenido de un sitio, útil en ataques de diccionario.\tcewl <sitio> -w <lista.txt> arma un diccionario de palabras a partir del texto de esa web, para usar después con herramientas como Hydra o John.\tgem\tcewl'
$'Brakeman\tAnálisis estático de seguridad para aplicaciones Ruby on Rails.\tbrakeman -p <./proyecto_rails> analiza el código de una app Rails y lista posibles vulnerabilidades sin necesidad de ejecutarla.\tgem\tbrakeman'
)
TOOLS_ruby_avanzado=(
$'msfvenom\tGenera payloads personalizados para pruebas de explotación (parte de Metasploit).\tmsfvenom -p <payload> LHOST=<ip> LPORT=<puerto> -f <formato> -o <archivo> genera un ejecutable de prueba. Solo debe correrse contra máquinas propias de laboratorio, nunca dispositivos ajenos.\tmanual\tForma parte de Metasploit Framework, con las mismas limitaciones de instalación en Termux mencionadas arriba.'
$'Evil-WinRM\tCliente para conectarse remotamente a Windows vía WinRM, muy usado en post-explotación.\tevil-winrm -i <ip> -u <usuario> -p <contraseña> abre una sesión remota en una máquina Windows donde WinRM está habilitado y ya se cuenta con credenciales válidas, por ejemplo en un laboratorio de Active Directory.\tgem\tevil-winrm'
$'BeEF\tFramework de explotación del lado del navegador mediante ganchos (hooks) de JavaScript.\tLevanta un panel web y un script hook.js que, al cargarse en un navegador de laboratorio, permite estudiar qué información y control expone un navegador enganchado.\tmanual\tSe instala clonando su repositorio y con bundle install; es un framework con su propio servidor web, pensado para laboratorios dedicados.'
)

TOOLS_php_basico=(
$'DVWA\tDamn Vulnerable Web Application: app deliberadamente vulnerable para practicar SQLi, XSS y más en un entorno controlado.\tSe clona el repositorio, se sirve con PHP (php -S 0.0.0.0:8080) apuntando a una base de datos, y se navega desde el propio dispositivo para practicar ataques web sin riesgo.\tmanual\tRequiere PHP y una base de datos (MySQL/MariaDB) corriendo juntos; en Termux se arma con pkg install php mariadb, siguiendo la guía de instalación del proyecto.'
$'bWAPP\tOtra app vulnerable en PHP, cubre más de 100 fallos de seguridad distintos.\tMisma lógica que DVWA: se sirve con PHP contra una base de datos propia, y cada módulo de la app permite practicar un tipo de vulnerabilidad distinto a la vez.\tmanual\tIgual que DVWA, requiere PHP + base de datos; se instala clonando su repositorio.'
$'Mutillidae II\tApp de entrenamiento de OWASP en PHP, con desafíos guiados de dificultad creciente.\tTambién se sirve con PHP + base de datos; a diferencia de DVWA, trae pistas y niveles de dificultad progresivos pensados para ir aprendiendo de a poco.\tmanual\tRequiere PHP + base de datos, igual que DVWA; se instala clonando su repositorio.'
)
TOOLS_php_medio=(
$'RIPS\tAnaliza código PHP de forma estática en busca de vulnerabilidades (SQLi, XSS, RCE).\tSe apunta a una carpeta con código PHP y el análisis revisa el código sin ejecutarlo, marcando líneas donde el flujo de datos podría llevar a una vulnerabilidad.\tmanual\tEl proyecto original está discontinuado hace años; se menciona como referencia histórica, para análisis estático de PHP actual conviene buscar alternativas mantenidas.'
$'phpMyAdmin\tPanel de administración de bases de datos; en laboratorios se usa como objetivo para practicar ataques a paneles expuestos.\tSe clona y se sirve con PHP apuntando a una base de datos de prueba, para practicar tanto su uso legítimo como la identificación de paneles mal configurados.\tmanual\tSe instala clonando su repositorio y sirviéndolo con PHP + base de datos, igual que DVWA.'
$'PHP_CodeSniffer (reglas de seguridad)\tAuditoría de calidad y seguridad de código PHP.\tphpcs --standard=Security <./proyecto> revisa el código contra un set de reglas de estilo/seguridad y marca las líneas que no las cumplen.\tmanual\tSe instala con Composer (pkg install php composer, luego composer global require squizlabs/php_codesniffer); no es un paquete directo de pkg.'
)
TOOLS_php_avanzado=(
$'PHPGGC\tColección de cadenas de gadgets para explotar deserialización insegura en PHP.\tphpggc <framework> <gadget-chain> genera una cadena serializada de referencia para estudiar cómo una deserialización insegura puede encadenar código; material de estudio sobre aplicaciones de laboratorio.\tmanual\tSe instala clonando su repositorio de GitHub; no tiene paquete en pkg/composer.'
$'Weevely\tGenera y gestiona webshells en PHP; se estudia en cursos forenses para reconocer su tráfico.\tweevely generate <contraseña> <archivo.php> crea una webshell de prueba, y weevely <URL> <contraseña> se conecta a ella; útil sobre todo para que un analista forense aprenda a reconocer este tipo de tráfico.\tpip\tweevely'
$'DVWA modo Impossible\tEl mismo DVWA con protecciones reales activadas: hay que evadirlas para explotarlo.\tEs un nivel de dificultad dentro de la configuración de DVWA (se cambia desde su panel), pensado para practicar cuando los ataques básicos ya no alcanzan.\tmanual\tEs una configuración dentro de la instalación de DVWA, no un paquete aparte.'
)

TOOLS_go_basico=(
$'subfinder\tEnumeración pasiva de subdominios de un dominio objetivo.\tsubfinder -d <dominio> lista subdominios conocidos usando fuentes públicas, sin tocar directamente al servidor objetivo.\tgo\tgithub.com/projectdiscovery/subfinder/v2/cmd/subfinder'
$'httpx\tSondea URLs y hosts vivos, detecta tecnologías y códigos de estado HTTP.\tcat <lista.txt> | httpx revisa qué hosts de una lista están activos y qué tecnología/código de estado devuelve cada uno.\tgo\tgithub.com/projectdiscovery/httpx/cmd/httpx'
$'naabu\tEscáner de puertos rápido, pensado para reconocimiento inicial.\tnaabu -host <dominio> hace un barrido rápido de puertos abiertos, como primer paso antes de un escaneo más detallado con Nmap.\tgo\tgithub.com/projectdiscovery/naabu/v2/cmd/naabu'
)
TOOLS_go_medio=(
$'gobuster\tFuerza bruta de directorios, archivos, DNS y vhosts.\tgobuster dir -u <sitio> -w <diccionario> prueba una lista de rutas para descubrir directorios o archivos no enlazados públicamente.\tpkg\tgobuster'
$'ffuf\tFuzzing web rápido y flexible (parámetros, rutas, subdominios).\tffuf -u <sitio>/FUZZ -w <diccionario> reemplaza FUZZ por cada palabra del diccionario; sirve para descubrir rutas, parámetros o subdominios.\tpkg\tffuf'
$'katana\tCrawler web de nueva generación para reconocimiento de aplicaciones.\tkatana -u <sitio> recorre los enlaces de una web como lo haría un usuario, mapeando su estructura para análisis posterior.\tgo\tgithub.com/projectdiscovery/katana/cmd/katana'
)
TOOLS_go_avanzado=(
$'Nuclei\tEscaneo de vulnerabilidades basado en miles de plantillas de la comunidad.\tnuclei -u <sitio> -t <plantillas/> prueba un sitio contra un set de plantillas que describen vulnerabilidades conocidas, cada una mantenida por la comunidad.\tgo\tgithub.com/projectdiscovery/nuclei/v3/cmd/nuclei'
$'amass\tEnumeración avanzada de activos y subdominios combinando OSINT y fuerza bruta.\tamass enum -d <dominio> combina fuentes públicas y técnicas activas para mapear toda la superficie de subdominios de una organización.\tgo\tgithub.com/owasp-amass/amass/v4/cmd/amass'
$'Velociraptor\tPlataforma de threat hunting y forense digital a escala empresarial.\tSe despliega como servidor + agentes para monitorear muchos equipos a la vez; no es una herramienta de un solo comando, sino una plataforma completa con su propia consola web.\tmanual\tSe distribuye como binario precompilado desde su página de releases en GitHub, pensado para desplegarse en un servidor, no dentro de Termux.'
)

TOOLS_rust_basico=(
$'RustScan\tEscáner de puertos ultrarrápido, pensado para alimentar resultados a Nmap.\trustscan -a <dominio> encuentra rápido los puertos abiertos y puede pasarle esa lista automáticamente a Nmap para un análisis más detallado.\tcargo\trustscan'
$'Sniffglue\tSniffer de tráfico de red simple y memory-safe.\tsniffglue <interfaz> muestra en vivo un resumen del tráfico que pasa por esa interfaz. En Android sin root, el acceso a captura de tráfico real suele estar restringido.\tcargo\tsniffglue'
$'cargo-audit\tAudita las dependencias de un proyecto Rust en busca de vulnerabilidades conocidas.\tDentro de un proyecto Rust, cargo audit revisa el archivo Cargo.lock contra una base de datos de vulnerabilidades conocidas.\tcargo\tcargo-audit'
)
TOOLS_rust_medio=(
$'Feroxbuster\tFuerza bruta recursiva de rutas y directorios web.\tferoxbuster -u <sitio> -w <diccionario> busca directorios y, a diferencia de gobuster, sigue explorando automáticamente los que va encontrando.\tcargo\tferoxbuster'
$'Bandwhich\tMonitorea el uso de ancho de banda por proceso y conexión en tiempo real.\tbandwhich muestra en vivo qué proceso está usando cuánto ancho de banda y contra qué conexión; normalmente necesita permisos elevados para leer esa información de red.\tcargo\tbandwhich'
$'Trippy\tHerramienta de diagnóstico de red, una versión mejorada de traceroute.\ttrip <dominio> muestra el camino que siguen los paquetes hasta un destino, con una interfaz interactiva en tiempo real en vez de una lista estática como el traceroute clásico.\tcargo\ttrippy'
)
TOOLS_rust_avanzado=(
$'YARA-X\tReescritura en Rust del motor de reglas YARA para detección de malware.\tSe usa de forma parecida a YARA clásico (yr <regla.yar> <archivo>), con un motor reescrito en Rust pensado para ser más rápido y seguro en memoria.\tcargo\tyara-x-cli'
$'cargo-fuzz\tFuzzing de código Rust para encontrar bugs de memoria y vulnerabilidades.\tcargo fuzz run <objetivo> prueba miles de entradas generadas automáticamente contra una función, buscando entradas que la rompan; requiere la rama nightly de Rust.\tcargo\tcargo-fuzz'
$'Ares\tDecodificador automático de cifrados y codificaciones, muy usado en retos CTF.\tares <texto_cifrado> prueba automáticamente varias codificaciones y cifrados clásicos (Base64, César, hexadecimal, etc.) hasta encontrar cuál devuelve texto legible.\tcargo\tares'
)

TOOLS_perl_basico=(
$'Nikto\tEscáner de vulnerabilidades y configuraciones inseguras en servidores web.\tnikto -h <sitio> revisa un servidor web en busca de archivos peligrosos, configuraciones desactualizadas y problemas conocidos.\tpkg\tnikto'
$'Swatch\tMonitorea logs en tiempo real y dispara alertas al detectar patrones sospechosos.\tswatch --config <archivo.conf> --tail-file <ruta/log> vigila un archivo de log y ejecuta una acción, por ejemplo avisar, cuando aparece un patrón definido.\tmanual\tSe instala vía CPAN (cpan install Swatch) tras pkg install perl; pensado para vigilar logs de servidor, con uso limitado dentro del sandbox de Termux.'
$'Logwatch\tGenera reportes resumidos de logs del sistema para detectar actividad anómala.\tlogwatch --detail high genera un resumen legible de los logs del sistema de las últimas horas; pensado para servidores Linux tradicionales con acceso a /var/log del sistema.\tmanual\tDepende de logs del sistema (/var/log) a los que Termux, al no ser root sobre el Android real, no tiene el mismo acceso que un Linux tradicional.'
)
TOOLS_perl_medio=(
$'Net::Nessus::XMLRPC\tBindings en Perl para automatizar y scriptear escaneos de Nessus.\tSe usa dentro de un script Perl para conectarse a un servidor Nessus ya existente y lanzar o consultar escaneos por código en vez de por la interfaz web.\tmanual\tEs un módulo de CPAN (cpan install Net::Nessus::XMLRPC) que además requiere tener un servidor Nessus corriendo aparte; no sirve como herramienta aislada.'
$'SEC (Simple Event Correlator)\tMotor de correlación de eventos de log en tiempo real.\tsec -conf=<reglas.sec> -input=<ruta/log> correlaciona líneas de log según reglas propias, por ejemplo para detectar una secuencia sospechosa de eventos.\tmanual\tSe instala vía CPAN o el paquete de la distribución Linux de origen; no es un paquete Termux estándar, conviene probarlo en una VM/servidor Linux.'
$'Whisker / libwhisker\tEscáner histórico de vulnerabilidades CGI, base original de Nikto.\tEs la librería Perl sobre la que originalmente se construyó Nikto; hoy se estudia sobre todo como referencia histórica más que como herramienta activa.\tmanual\tProyecto histórico sin mantenimiento activo; se menciona con fines de referencia, Nikto es su sucesor mantenido.'
)
TOOLS_perl_avanzado=(
$'SQLNinja\tExplotación de inyección SQL específicamente contra Microsoft SQL Server.\tsqlninja -f <archivo.conf> automatiza la explotación de una inyección SQL ya identificada en un motor MSSQL, dentro de un laboratorio propio con ese motor de base de datos.\tmanual\tProyecto antiguo sin mantenimiento activo; se instala clonando su repositorio, hoy sqlmap cubre un rol equivalente de forma más mantenida.'
$'PacketFence\tSistema de control de acceso a redes (NAC) de código abierto.\tEs una plataforma completa de servidor que se instala en una red para controlar qué dispositivos pueden conectarse; se estudia más como concepto de seguridad de redes que como algo que se ejecuta en el celular.\tmanual\tPlataforma de servidor completa (NAC); no aplica a una instalación dentro de Termux, se menciona con fines de referencia conceptual.'
$'Scripts de correlación de logs\tAutomatizaciones en Perl para pipelines de detección tipo SIEM casero.\tSon scripts a medida, por ejemplo con expresiones regulares sobre archivos de log, que cada quien arma según qué patrones quiera vigilar; no es una herramienta única sino una práctica.\tmanual\tNo es un paquete específico: es una técnica de scripting en Perl aplicada a archivos de log propios.'
)

TOOLS_lua_basico=(
$'Nmap Scripting Engine (NSE)\tScripts que extienden Nmap para banner grabbing y descubrimiento básico.\tnmap --script=banner <objetivo> corre un script puntual; nmap --script=default <objetivo> corre el set de scripts básicos incluidos por defecto.\tpkg\tnmap'
$'Dissectors Lua de Wireshark\tPlugins para decodificar protocolos de red personalizados o propietarios.\tSe colocan como archivos .lua en la carpeta de plugins de Wireshark/tshark, para que la herramienta entienda un protocolo que no trae soporte nativo.\tpkg\ttshark'
$'Scripting EVAL en Redis\tEjecutar comandos Lua embebidos para practicar auditoría de instancias mal configuradas.\tDentro de redis-cli, el comando EVAL corre un script Lua corto directo en el servidor; sirve para entender por qué una instancia Redis expuesta sin autenticación es un riesgo serio.\tpkg\tredis'
)
TOOLS_lua_medio=(
$'Scripts NSE personalizados\tDetección de vulnerabilidades específicas ampliando Nmap.\tSe escribe un archivo .nse propio y se corre con nmap --script=<./mi_script.nse> <objetivo>; es la forma de enseñarle a Nmap a buscar algo que no viene por defecto.\tpkg\tnmap'
$'HAProxy (scripting Lua)\tReglas de tráfico personalizadas para pruebas de balanceadores de carga.\tSe agregan bloques de Lua dentro de la configuración de HAProxy para tomar decisiones de enrutamiento más complejas que las reglas estándar.\tpkg\thaproxy'
$'OpenResty (Nginx + Lua)\tConstrucción de WAFs personalizados o estudio de cómo evadirlos.\tSe escriben scripts Lua dentro de la configuración de Nginx/OpenResty para inspeccionar o bloquear peticiones antes de que lleguen a la aplicación.\tmanual\tNo está empaquetado directo para Termux; se compila desde código fuente o se prueba en una VM/servidor Linux.'
)
TOOLS_lua_avanzado=(
$'NSE categoría exploit\tScripts de Nmap que explotan CVEs específicos de forma automatizada.\tnmap --script=exploit <objetivo> corre toda esa categoría de scripts. Por su naturaleza, solo tiene sentido usarlos contra sistemas propios o de laboratorio ya identificados a propósito como vulnerables.\tpkg\tnmap'
$'Dissectors Lua avanzados\tIngeniería inversa de protocolos propietarios completos en Wireshark.\tImplica escribir un dissector .lua completo que interprete campo por campo un protocolo propietario capturado; suele estudiarse junto con Radare2/Ghidra para entender primero el binario que genera ese tráfico.\tpkg\ttshark'
$'Sandbox escapes en Redis\tEstudio de CVEs de escape del sandbox Lua embebido en Redis.\tEs contenido de estudio teórico sobre CVEs ya documentados y parchados: se analiza el reporte técnico de cada caso, no hay un comando único para usarlo.\tmanual\tEs un tema de estudio (CVEs históricos), no una herramienta instalable; conviene leer los avisos oficiales de seguridad de Redis para el detalle técnico de cada caso ya parchado.'
)

TOOLS_java_basico=(
$'Apktool\tDesensambla y recompila APKs de Android, base de la ingeniería inversa móvil.\tapktool d <app.apk> descompila un APK en carpetas legibles (recursos + smali); apktool b <carpeta> lo vuelve a empaquetar después de modificarlo.\tpkg\tapktool'
$'jadx\tDecompilador que convierte APKs en código Java legible.\tjadx <app.apk> -d <salida/> genera código Java aproximado a partir del APK, más fácil de leer que el smali crudo de Apktool.\tpkg\tjadx'
$'Burp Suite (Community)\tProxy interceptor para pruebas de aplicaciones web, el más usado de la industria.\tSe configura el navegador o la app para pasar por el proxy de Burp, y desde ahí se pueden ver, pausar y modificar las peticiones antes de que lleguen al servidor.\tmanual\tAplicación Java con interfaz gráfica pesada; necesita un JDK y entorno gráfico (X11). Se usa habitualmente en PC en vez de en Termux.'
)
TOOLS_java_medio=(
$'OWASP ZAP\tEscáner de vulnerabilidades web automatizado, alternativa open source a Burp.\tTiene un modo de línea de comandos (zap.sh -cmd -quickurl <sitio>) además de su interfaz gráfica habitual, para escaneos automatizados sin abrir ventanas.\tmanual\tAplicación Java; su modo gráfico necesita entorno X11, aunque el modo de línea de comandos es más viable dentro de Termux con un JDK instalado.'
$'jd-gui\tDecompilador gráfico de bytecode Java (.class/.jar).\tSe abre el .jar o .class directamente en su ventana y muestra el código Java reconstruido; es una alternativa con interfaz gráfica a jadx.\tmanual\tAplicación Java con interfaz gráfica pensada para PC; en Termux, jadx cumple un rol equivalente sin necesitar ventanas.'
$'FindSecBugs\tPlugin de análisis estático que detecta vulnerabilidades de seguridad en código Java.\tSe integra como plugin dentro de un proyecto Maven/Gradle o de SpotBugs, y al compilar marca patrones de código inseguros conocidos.\tmanual\tSe agrega como dependencia dentro de un proyecto Java con Maven/Gradle; no es un binario suelto que se instale directo en Termux.'
)
TOOLS_java_avanzado=(
$'Ghidra\tFramework de ingeniería inversa desarrollado por la NSA, con decompilador integrado.\tSe abre un binario, Ghidra lo analiza automáticamente y muestra tanto el desensamblado como una reconstrucción aproximada del código fuente en su decompilador.\tmanual\tAplicación Java de escritorio con interfaz gráfica pesada, pensada para PC; no es práctica de instalar ni usar dentro de Termux en un celular.'
$'Burp Suite (uso avanzado)\tExtensiones, macros e Intruder personalizado para ataques complejos.\tSobre la base del proxy, se agregan extensiones desde su tienda (BApp Store) y se configuran macros para automatizar secuencias de peticiones, por ejemplo mantener una sesión autenticada durante un escaneo.\tmanual\tMismas limitaciones que Burp Suite Community: pensado para PC, no para Termux.'
$'jadx (deofuscación avanzada)\tAnálisis de apps Android maliciosas u ofuscadas.\tSobre APKs con nombres de clases y variables ofuscados, se combinan las opciones de jadx con renombrado manual progresivo, anotando hipótesis sobre qué hace cada función a medida que se va entendiendo.\tpkg\tjadx'
)

TOOLS_r_basico=(
$'R + ggplot2\tVisualización de datos de logs y tráfico de red para detectar patrones anómalos.\tDentro de R, install.packages(ggplot2) lo instala; luego ggplot() + geom_line() arma un gráfico a partir de una tabla de datos, por ejemplo conexiones por hora.\tpkg\tr-base'
$'iptools\tPaquete para manipular y analizar rangos de direcciones IP en investigaciones.\tinstall.packages(iptools) desde R; funciones como ip_classify() ayudan a clasificar y trabajar con listas de direcciones IP dentro de un análisis.\tmanual\tSe instala desde dentro de R con install.packages(); primero hace falta pkg install r-base.'
$'rtweet\tRecolección de datos públicos de redes sociales para investigaciones OSINT.\tinstall.packages(rtweet) desde R; funciones como search_tweets() traen publicaciones públicas según palabras clave, dentro de los límites que impone la API de la plataforma.\tmanual\tSe instala desde dentro de R con install.packages(); además requiere credenciales de API de la plataforma para funcionar.'
)
TOOLS_r_medio=(
$'anomalize\tDetección de anomalías en series temporales, aplicable a tráfico de red o logs.\tinstall.packages(anomalize) desde R; funciones como time_decompose() y anomalize() marcan automáticamente los puntos de una serie temporal, por ejemplo tráfico por minuto, que se salen del patrón normal.\tmanual\tSe instala desde dentro de R con install.packages().'
$'networkD3\tVisualización de grafos de red, útil para mapear relaciones en investigaciones de amenazas.\tinstall.packages(networkD3) desde R; funciones como simpleNetwork() generan un grafo interactivo, por ejemplo qué IPs se conectaron entre sí, que se puede explorar en el navegador.\tmanual\tSe instala desde dentro de R con install.packages().'
$'caret / tidymodels\tConstrucción de modelos de machine learning para clasificar tráfico o phishing.\tinstall.packages(tidymodels) desde R; con un conjunto de datos ya etiquetado, por ejemplo correos marcados como phishing o no, se entrena un modelo para clasificar casos nuevos.\tmanual\tSe instala desde dentro de R con install.packages(); algunos paquetes dependientes pueden tardar en compilar en Termux por las limitaciones de un celular.'
)
TOOLS_r_avanzado=(
$'IDS con machine learning\tModelos (randomForest, xgboost) entrenados sobre datasets de tráfico real para detectar intrusiones.\tSe entrena un modelo, por ejemplo con randomForest(), sobre un dataset histórico de tráfico ya etiquetado como normal o malicioso, y después se lo usa para clasificar tráfico nuevo.\tmanual\tLos paquetes se instalan desde dentro de R con install.packages(); xgboost en particular puede requerir herramientas de compilación adicionales.'
$'Forense estadístico a escala\tAnálisis de grandes volúmenes de logs combinando R con Spark (sparklyr).\tinstall.packages(sparklyr) conecta R con un clúster Spark para procesar volúmenes de logs que no entrarían en la memoria de un solo equipo.\tmanual\tRequiere además un clúster o instalación de Spark aparte; no es práctico de correr dentro de Termux en un celular, pensado para infraestructura de servidor.'
$'Modelado predictivo de amenazas\tSeries temporales avanzadas (forecast, prophet) para anticipar campañas de phishing o malware.\tinstall.packages(prophet) o install.packages(forecast) desde R; con datos históricos, por ejemplo incidentes por semana, se generan proyecciones de cómo podría seguir la tendencia.\tmanual\tSe instala desde dentro de R con install.packages(); prophet en particular puede requerir herramientas de compilación adicionales.'
)

TOOLS_bash_basico=(
$'Lynis\tAuditoría de seguridad y hardening de sistemas Linux/Unix.\tlynis audit system revisa la configuración del sistema (usuarios, permisos, servicios) y da un puntaje junto con sugerencias de hardening. Dentro de Termux audita el propio sandbox de la app, no el Android real por debajo.\tpkg\tlynis'
$'Chkrootkit\tDetector de rootkits en sistemas Linux.\tchkrootkit revisa binarios y procesos del sistema buscando señales conocidas de rootkits. Dentro de Termux solo puede ver el propio sandbox de la app, no el sistema Android real por debajo.\tpkg\tchkrootkit'
$'Rkhunter\tOtro detector de rootkits y cambios sospechosos en el sistema.\trkhunter --check compara archivos del sistema contra una base de referencia; tiene la misma limitación que Chkrootkit dentro de Termux, solo audita su propio sandbox.\tpkg\trkhunter'
)
TOOLS_bash_medio=(
$'LinEnum\tScript de enumeración de Linux orientado a post-explotación.\tbash linenum.sh -t recorre un sistema Linux ya comprometido de laboratorio, listando configuraciones, permisos y servicios que podrían servir para escalar privilegios.\tmanual\tEs un único script que se descarga con git clone o curl desde su repositorio de GitHub; no es un paquete de pkg.'
$'Linux Exploit Suggester\tCompara la versión del kernel contra CVEs conocidos para sugerir exploits de escalada.\t./linux-exploit-suggester.sh compara la versión del kernel del sistema objetivo contra una base de CVEs conocidos y sugiere cuáles podrían aplicar, sin ejecutarlos automáticamente.\tmanual\tEs un único script que se descarga desde su repositorio de GitHub; no es un paquete de pkg.'
$'Unix-privesc-check\tVerifica configuraciones inseguras que permitan escalar privilegios.\t./upc.sh standard revisa permisos de archivos, tareas cron y otras configuraciones típicas que podrían permitir escalar privilegios en un sistema Unix.\tmanual\tEs un único script que se descarga desde su repositorio; no es un paquete de pkg.'
)
TOOLS_bash_avanzado=(
$'LinPEAS\tEl script de enumeración más completo para escalada de privilegios en Linux.\tbash linpeas.sh corre una revisión exhaustiva del sistema, resaltando en colores los hallazgos más prometedores para escalar privilegios en una máquina de laboratorio ya comprometida.\tmanual\tEs un único script que se descarga con curl/wget desde su repositorio (PEASS-ng) en GitHub; no es un paquete de pkg.'
$'Linux Smart Enumeration (LSE)\tEnumeración avanzada con niveles de verbosidad configurables.\t./lse.sh -l1 corre un nivel básico de detalle; subir a -l2 agrega cada vez más información, para ajustar cuánto ruido genera según lo que se necesite revisar.\tmanual\tEs un único script que se descarga desde su repositorio de GitHub; no es un paquete de pkg.'
$'Scripts con GTFOBins\tAutomatizaciones bash que cruzan hallazgos de enumeración con binarios SUID explotables.\tNo es una herramienta que se instale: gtfobins.github.io es un sitio de consulta donde, dado un binario con permisos SUID encontrado en la enumeración, se busca si tiene una forma documentada de usarse para escalar privilegios.\tmanual\tEs un sitio web de referencia (gtfobins.github.io), no un paquete instalable; se consulta desde el navegador.'
)

# ---------- Módulos ----------
instalar_paquetes() {
    local modo="$1"
    local DPKG_OPTS=(-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew")
    [ "$modo" != "todo" ] && banner
    echo -e "${GREEN}▶ Instalando paquetes esenciales...${RESET}"

    if ! pkg update -y "${DPKG_OPTS[@]}"; then
        echo -e "${YELLOW}⚠ No se pudo actualizar la lista de repositorios, sigo igual...${RESET}"
    fi
    if ! pkg upgrade -y "${DPKG_OPTS[@]}"; then
        echo -e "${YELLOW}⚠ La actualización de paquetes tuvo problemas, sigo con la instalación...${RESET}"
    fi

    local PAQUETES="git python nodejs vim curl wget openssh nano tree unzip"
    local fallidos=()
    local p
    for p in $PAQUETES; do
        if pkg install -y "${DPKG_OPTS[@]}" "$p"; then
            grep -qx "$p" "$PAQUETES_FILE" || echo "$p" >> "$PAQUETES_FILE"
        else
            fallidos+=("$p")
        fi
    done

    if [ "${#fallidos[@]}" -eq 0 ]; then
        echo -e "${GREEN}✔ Paquetes instalados correctamente.${RESET}"
    else
        echo -e "${RED}⚠ No se pudieron instalar: ${fallidos[*]}${RESET}"
        echo -e "${YELLOW}Revisá tu conexión a internet e intentá de nuevo con la opción 1 del menú.${RESET}"
    fi
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
    local confirmar
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
    local CONTENIDO="alias ll='ls -la --color=auto'\n"
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
    # Solo se permiten letras, números, guion y guion bajo: evita que un
    # identidad.conf con $(comando) o similares termine ejecutándose cada
    # vez que se abre una sesión nueva (el PS1 se re-evalúa al cargar .bashrc).
    local slug=$(echo "$IDENTIDAD" | tr -d ' ' | tr -cd 'A-Za-z0-9_-' | cut -c1-16)
    [ -z "$slug" ] && slug="termux-forge"
    local CONTENIDO="export PS1=\"\\[\\033[1;36m\\]\\u@${slug}\\[\\033[0m\\]:\\[\\033[1;33m\\]\\w\\[\\033[0m\\]\\\$ \""
    insertar_sesion "prompt" "$CONTENIDO"
    echo -e "${GREEN}✔ Prompt configurado con identidad: ${slug}${RESET}"
    [ "$modo" != "todo" ] && pausa
}

generar_mostrar_banner() {
    local tema=$(cat "$TEMA_FILE" 2>/dev/null || echo "magenta")
    local firma=$(cat "$FIRMA_FILE" 2>/dev/null || echo "Ukakō Academia - ciberseguridad")
    local estilo=$(cat "$ESTILO_FILE" 2>/dev/null || echo "grande")
    local c1 c2 c3

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
        declare -f dibujar_banner_logo_dado
        declare -f dibujar_banner_logo_cubo_armado
        declare -f dibujar_banner_logo_cubo_desarmado
        declare -f dibujar_banner_logo_cruz
        declare -f dibujar_banner_logo_corazon
        declare -f dibujar_banner_logo_flor
        declare -f dibujar_banner_logo_claude
        declare -f dibujar_banner_logo_arandanos
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
    local texto
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
    local nombre
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
        local tema="${temas_keys[$SELECCION_IDX]}"
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
        local estilo="${estilos_keys[$SELECCION_IDX]}"
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

personalizar_logo_banner() {
    cargar_tema
    cargar_firma
    cargar_estilo

    local logos_keys=(dado cubo_armado cubo_desarmado cruz corazon flor claude arandanos)
    local logos_labels=(
        "🎲 Dado"
        "🟨 Cubo Rubik: armado"
        "🟥 Cubo Rubik: desarmado"
        "✝️  Cruz Cristiana (con sol)"
        "❤️  Corazón rojo"
        "🌸 Flor (jazmín / lirio)"
        "✻  Claude (Anthropic)"
        "🫐 Arándanos"
    )

    preview_logo() {
        local i="$1"
        echo -e "${BOLD}Vista previa — ${logos_labels[$i]}${RESET}"
        echo ""
        dibujar_banner_segun_estilo "${logos_keys[$i]}"
    }

    if seleccionar_con_flechas logos_labels preview_logo; then
        local estilo="${logos_keys[$SELECCION_IDX]}"
        echo "$estilo" > "$ESTILO_FILE"
        generar_mostrar_banner
        cargar_estilo
        banner
        echo -e "${GREEN}✔ Logo '${estilo}' aplicado. Se verá al abrir Termux y al iniciar termux-forge.${RESET}"
    else
        clear
        echo -e "${YELLOW}Cancelado, se mantiene el logo/estilo anterior.${RESET}"
    fi
    pausa
}

menu_estilo_banner() {
    cargar_tema
    cargar_firma
    cargar_estilo

    local opciones=("Tamaño / estilo clásico" "Cambio de Logo")

    preview_menu_estilo() {
        local i="$1"
        echo -e "${BOLD}Banner: ¿qué querés cambiar?${RESET}"
        echo ""
        case "$i" in
            0) echo -e "${P3}Grande, mediano, chico, espejo o animado.${RESET}" ;;
            1) echo -e "${P3}Reemplaza el banner por un logo temático: dado, cubo Rubik, cruz, corazón, flor, Claude o arándanos.${RESET}" ;;
        esac
        echo ""
        dibujar_banner_segun_estilo "$ESTILO"
    }

    if seleccionar_con_flechas opciones preview_menu_estilo; then
        case "$SELECCION_IDX" in
            0) personalizar_estilo_banner ;;
            1) personalizar_logo_banner ;;
        esac
    fi
}

# ---------- Catálogo de herramientas de ciberseguridad (lógica) ----------
# Muestra en pantalla una fila del catálogo ya parseada: título, para qué
# sirve, cómo usarla, y el comando de instalación reconstruido a partir de
# tipo+argumento.
mostrar_detalle_herramienta() {
    local fila="$1"
    local nombre desc uso tipo arg
    IFS=$'\t' read -r nombre desc uso tipo arg <<< "$fila"

    echo -e "${BOLD}${P1}${nombre}${RESET}"
    echo ""
    echo -e "${P3}Para qué sirve:${RESET} ${desc}"
    echo ""
    echo -e "${P3}Cómo usarla:${RESET} ${uso}"
    echo ""
    case "$tipo" in
        manual) echo -e "${YELLOW}Instalación:${RESET} ${arg}" ;;
        pkg)    echo -e "${YELLOW}Instalación:${RESET} pkg install -y ${arg}" ;;
        pip)    echo -e "${YELLOW}Instalación:${RESET} pip install ${arg}" ;;
        npm)    echo -e "${YELLOW}Instalación:${RESET} npm install -g ${arg}" ;;
        gem)    echo -e "${YELLOW}Instalación:${RESET} gem install ${arg}" ;;
        cargo)  echo -e "${YELLOW}Instalación:${RESET} cargo install ${arg}" ;;
        go)     echo -e "${YELLOW}Instalación:${RESET} go install ${arg}@latest" ;;
    esac
}

# Instala de verdad una herramienta del catálogo según su tipo. Si el tipo
# es "manual", no hay un solo comando posible: solo muestra la nota.
instalar_herramienta_catalogo() {
    local nombre="$1" tipo="$2" arg="$3"
    echo ""
    case "$tipo" in
        pkg)
            echo -e "${GREEN}▶ Instalando ${nombre} (pkg)...${RESET}"
            if pkg install -y "$arg"; then
                grep -qx "$arg" "$PAQUETES_FILE" || echo "$arg" >> "$PAQUETES_FILE"
                echo -e "${GREEN}✔ ${nombre} instalado.${RESET}"
            else
                echo -e "${RED}⚠ No se encontró '${arg}' en los repos de Termux.${RESET}"
                echo -e "${YELLOW}Probá: pkg search ${arg}${RESET}"
            fi
            ;;
        pip)
            command -v pip >/dev/null 2>&1 || pkg install -y python
            echo -e "${GREEN}▶ Instalando ${nombre} (pip)...${RESET}"
            if pip install "$arg"; then
                echo -e "${GREEN}✔ ${nombre} instalado con pip.${RESET}"
            else
                echo -e "${RED}⚠ Falló la instalación con pip.${RESET}"
            fi
            ;;
        npm)
            command -v npm >/dev/null 2>&1 || pkg install -y nodejs
            echo -e "${GREEN}▶ Instalando ${nombre} (npm)...${RESET}"
            if npm install -g "$arg"; then
                echo -e "${GREEN}✔ ${nombre} instalado con npm.${RESET}"
            else
                echo -e "${RED}⚠ Falló la instalación con npm.${RESET}"
            fi
            ;;
        gem)
            command -v gem >/dev/null 2>&1 || pkg install -y ruby
            echo -e "${GREEN}▶ Instalando ${nombre} (gem)...${RESET}"
            if gem install "$arg"; then
                echo -e "${GREEN}✔ ${nombre} instalado con gem.${RESET}"
            else
                echo -e "${RED}⚠ Falló la instalación con gem.${RESET}"
            fi
            ;;
        cargo)
            command -v cargo >/dev/null 2>&1 || pkg install -y rust
            echo -e "${GREEN}▶ Instalando ${nombre} (cargo, puede tardar)...${RESET}"
            if cargo install "$arg"; then
                echo -e "${GREEN}✔ ${nombre} instalado con cargo.${RESET}"
            else
                echo -e "${RED}⚠ Falló la instalación con cargo.${RESET}"
            fi
            ;;
        go)
            command -v go >/dev/null 2>&1 || pkg install -y golang
            echo -e "${GREEN}▶ Instalando ${nombre} (go install)...${RESET}"
            if go install "${arg}@latest"; then
                echo -e "${GREEN}✔ ${nombre} instalado. Revisá que la carpeta bin de Go esté en tu PATH.${RESET}"
            else
                echo -e "${RED}⚠ Falló la instalación con go install.${RESET}"
            fi
            ;;
        manual)
            echo -e "${YELLOW}⚠ ${nombre} no se instala con un solo comando en Termux.${RESET}"
            echo -e "${arg}"
            ;;
    esac
}

# Nivel 3: lista de herramientas de un lenguaje+nivel ya elegidos.
catalogo_nivel() {
    local idioma_key="$1" idioma_label="$2" nivel_key="$3" nivel_label="$4"
    local -n filas="TOOLS_${idioma_key}_${nivel_key}"
    local labels=() i nombre resto

    for i in "${!filas[@]}"; do
        IFS=$'\t' read -r nombre resto <<< "${filas[$i]}"
        labels+=("$nombre")
    done

    preview_herramienta() {
        local i="$1"
        echo -e "${BOLD}${idioma_label} · ${nivel_label}${RESET}"
        echo ""
        mostrar_detalle_herramienta "${filas[$i]}"
    }

    while true; do
        if seleccionar_con_flechas labels preview_herramienta; then
            local elegido="${filas[$SELECCION_IDX]}"
            local nombre desc uso tipo arg
            IFS=$'\t' read -r nombre desc uso tipo arg <<< "$elegido"
            clear
            echo -e "${BOLD}${idioma_label} · ${nivel_label}${RESET}"
            echo ""
            mostrar_detalle_herramienta "$elegido"
            echo ""
            local resp
            read -p "$(echo -e "${BOLD}¿Instalar ${nombre} ahora? (s/n): ${RESET}")" resp
            if [[ "$resp" == "s" || "$resp" == "S" ]]; then
                instalar_herramienta_catalogo "$nombre" "$tipo" "$arg"
            fi
            pausa
        else
            break
        fi
    done
}

# Nivel 2: Básico / Medio / Avanzado, para el lenguaje ya elegido.
catalogo_idioma() {
    local idioma_key="$1" idioma_label="$2"
    local niveles_keys=(basico medio avanzado)
    local niveles_labels=("Nivel Básico" "Nivel Medio" "Nivel Avanzado")

    preview_nivel() {
        local i="$1"
        echo -e "${BOLD}${idioma_label}${RESET}"
        echo -e "${P3}Elegí el nivel de dificultad${RESET}"
        echo ""
        echo -e "${YELLOW}3 herramientas por nivel.${RESET}"
    }

    while true; do
        if seleccionar_con_flechas niveles_labels preview_nivel; then
            catalogo_nivel "$idioma_key" "$idioma_label" "${niveles_keys[$SELECCION_IDX]}" "${niveles_labels[$SELECCION_IDX]}"
        else
            break
        fi
    done
}

# Nivel 1: elegir lenguaje/categoría. Punto de entrada del catálogo.
catalogo_herramientas() {
    local idiomas_labels=() k
    for k in "${ORDEN_IDIOMAS_CATALOGO[@]}"; do
        idiomas_labels+=("${NOMBRE_IDIOMA_CATALOGO[$k]}")
    done

    preview_idioma() {
        local i="$1"
        echo -e "${BOLD}📦 Catálogo de herramientas de ciberseguridad${RESET}"
        echo -e "${P3}Elegí un lenguaje o categoría${RESET}"
        echo ""
        echo -e "${YELLOW}9 herramientas por lenguaje: 3 por nivel (Básico / Medio / Avanzado).${RESET}"
        echo -e "${YELLOW}Uso educativo: probalas en sistemas propios, de laboratorio, o con autorización explícita.${RESET}"
    }

    while true; do
        if seleccionar_con_flechas idiomas_labels preview_idioma; then
            catalogo_idioma "${ORDEN_IDIOMAS_CATALOGO[$SELECCION_IDX]}" "${idiomas_labels[$SELECCION_IDX]}"
        else
            break
        fi
    done
}

# Subdivisión de "Instalar paquetes": esenciales de siempre, o el catálogo.
menu_instalar_paquetes() {
    local opciones=("Paquetes esenciales (rápido)" "Catálogo de herramientas de ciberseguridad (por lenguaje)")

    preview_instalar() {
        local i="$1"
        echo -e "${BOLD}▶ Instalar paquetes${RESET}"
        echo ""
        case "$i" in
            0) echo -e "${P3}Instala de una: git, python, nodejs, vim, curl, wget, openssh, nano, tree, unzip.${RESET}" ;;
            1) echo -e "${P3}Explorá herramientas de ciberseguridad organizadas por lenguaje y nivel, con descripción, uso e instalación guiada.${RESET}" ;;
        esac
    }

    if seleccionar_con_flechas opciones preview_instalar; then
        case "$SELECCION_IDX" in
            0) instalar_paquetes ;;
            1) catalogo_herramientas ;;
        esac
    fi
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
        echo -e "  ${YELLOW}1)${RESET} Instalar paquetes"
        echo -e "  ${YELLOW}2)${RESET} Configurar alias"
        echo -e "  ${YELLOW}3)${RESET} Personalizar prompt"
        echo -e "  ${YELLOW}4)${RESET} Personalizar identidad (nombre)"
        echo -e "  ${YELLOW}5)${RESET} Personalizar firma (bienvenida)"
        echo -e "  ${YELLOW}6)${RESET} Personalizar banner (color)"
        echo -e "  ${YELLOW}7)${RESET} Banner: tamaño / Cambio de Logo"
        echo -e "  ${YELLOW}8)${RESET} Instalar todo (recomendado)"
        echo -e "  ${YELLOW}9)${RESET} Desinstalar paquetes instalados"
        echo -e "  ${YELLOW}10)${RESET} Salir"
        echo ""
        read -p "$(echo -e "${BOLD}> ${RESET}")" opcion

        case $opcion in
            1) menu_instalar_paquetes ;;
            2) configurar_alias ;;
            3) configurar_prompt ;;
            4) configurar_identidad ;;
            5) configurar_firma ;;
            6) personalizar_banner ;;
            7) menu_estilo_banner ;;
            8) instalar_todo ;;
            9) desinstalar_paquetes ;;
            10) salir ;;
            *) echo -e "${RED}Opción inválida.${RESET}"; sleep 1 ;;
        esac
    done
}

menu
