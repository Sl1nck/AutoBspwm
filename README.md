# Entorno BSPWM para Kali Linux

Entorno ligero y moderno para Kali Linux, pensado para ethical hacking, bug bounty y auditorías. Parte de una instalación **limpia, sin escritorio gráfico**, e instala solo lo necesario: no incluye herramientas de seguridad (ver la sección de herramientas).

## Qué incluye

- **BSPWM + sxhkd**: gestor de ventanas en mosaico controlado por teclado. Las ventanas se reparten el espacio por igual de forma automática.
- **Polybar** en "islas": logo, red, VPN, escritorios, target, CPU y RAM, volumen, hora y menú de apagado.
- **Rofi**: lanzador de aplicaciones y menú de energía, con tema propio.
- **Kitty**: terminal translúcida con paleta Catppuccin Mocha y JetBrainsMono Nerd Font.
- **Starship**: prompt con el logo de Kali, la carpeta, la rama de git y el target.
- **Picom**: transparencias y esquinas redondeadas en todas las ventanas.
- **Bloqueo de pantalla** con tu wallpaper difuminado, manual y automático.
- **Fastfetch** con el logo de Kali, **PipeWire** para el audio y **feh** para los fondos.

### El target

Define el objetivo actual de tus pruebas con un clic en la barra (clic izquierdo para escribirlo, clic derecho para borrarlo). Aparece en la barra y en el prompt, y queda en la shell como `$TARGET`:

```
nmap -sV "$TARGET"
```

## Requisitos

- Kali Linux, ya sea una instalación limpia (ISO *Installer* sin entorno de escritorio ni herramientas) o una instalación o imagen de máquina virtual que ya traiga un entorno de escritorio, como Xfce.
- Conexión a internet y un usuario con `sudo`.
- Arquitectura x86_64.
- El repositorio debe clonarse en `~/dotfiles`: algunos scripts usan esa ruta.

## Instalación

```
sudo apt update && sudo apt install -y git
git clone https://github.com/Sl1nck/AutoBspwm.git ~/dotfiles
cd ~/dotfiles
./install.sh all
```

`all` instala los paquetes, la fuente Nerd Font y Starship, y enlaza las configuraciones con GNU Stow. También se pueden ejecutar los pasos por separado: `packages`, `font`, `starship` y `link`.

Si ya tenías un `~/.zshrc`, se guarda como `~/.zshrc.bak` antes de enlazar el del repo.

### Iniciar el entorno

Depende de cómo tengas instalado Kali:

- **Sin entorno de escritorio** (instalación limpia): cierra la sesión, vuelve a entrar en la consola e inicia el entorno con `startx`.
- **Con entorno de escritorio** (por ejemplo Xfce, o una imagen de máquina virtual de Kali): no hace falta `startx`. Cierra la sesión y, en la pantalla de inicio de sesión, elige la sesión **bspwm** en el selector de sesión (suele estar en la parte superior de la pantalla) antes de escribir tu contraseña.

El instalador añade PipeWire para el audio. Si tu sistema ya usaba PulseAudio, apt te avisará del reemplazo antes de hacerlo.

### Máquina virtual VMware

```
./install.sh vmware
```

Instala las herramientas de VMware: copiar y pegar con tu equipo y ajuste automático de la resolución al cambiar el tamaño de la ventana (con barra y fondo adaptándose solos).

Si tu equipo anfitrión es Windows, algunas combinaciones con la tecla Windows las captura el propio sistema (la Game Bar con `Win + Alt + R`, y `Win + L`, que bloquea Windows). Por eso los atajos de este entorno usan `Alt` y `Ctrl + Alt`.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `super + Return` | Abrir terminal |
| `super + d` | Lanzador de aplicaciones |
| `super + w` | Cerrar ventana |
| `super + 1` a `5` | Ir al escritorio |
| `alt + shift + 1` a `5` | Mandar la ventana a otro escritorio |
| `alt + flechas` | Mover el foco entre ventanas |
| `alt + shift + flechas` | Intercambiar la ventana con su vecina |
| `alt + Tab` | Pasar a la siguiente ventana |
| `ctrl + alt + flechas` | Redimensionar la ventana |
| `ctrl + alt + l` | Bloquear la pantalla |
| `ctrl + alt + w` | Cambiar de wallpaper |
| `super + shift + r` | Recargar BSPWM |
| `super + shift + q` | Salir de BSPWM |
| `super + Escape` | Recargar los atajos (sxhkd) |

Los atajos se editan en `sxhkd/.config/sxhkd/sxhkdrc`. Los demás atajos de ese archivo vienen del ejemplo de BSPWM.

## La barra

- **Izquierda**: logo de Kali (abre el lanzador), IP y estado de la VPN.
- **Centro**: escritorios. El activo es un Pac-Man amarillo, los que tienen ventanas son fantasmas claros y los vacíos, fantasmas grises.
- **Derecha**: target, CPU y RAM, volumen (con la rueda del ratón), hora y botón de apagado (apagar, reiniciar o cerrar sesión).

## Bloqueo de pantalla

`ctrl + alt + l` bloquea al instante y, además, se bloquea solo tras 10 minutos sin actividad. Muestra tu wallpaper difuminado con un reloj. Para desbloquear, escribe la contraseña de tu usuario.

Si te quedas bloqueado, entra a otra consola con `Ctrl + Alt + F2`, inicia sesión y ejecuta `pkill i3lock`.

## Wallpapers

Los fondos están en la carpeta `wallpapers/`. Agrega tus imágenes (PNG o JPG) y cámbialas con `ctrl + alt + w`. El elegido se recuerda entre reinicios y es el que usa el bloqueo.

## Información del sistema

```
fastfetch
```

## Herramientas de seguridad (opcional)

Este entorno **no instala herramientas de ethical hacking**: cada persona instala las que va a usar. Por ejemplo:

```
sudo apt install nmap
sudo apt install kali-tools-web
```

Kali agrupa sus herramientas en metapaquetes por categoría (`kali-tools-web`, `kali-tools-information-gathering`, `kali-tools-passwords`, etc.). La lista completa está en https://www.kali.org/tools/kali-meta/

Las aplicaciones Java con interfaz gráfica, como Burp Suite, funcionan en BSPWM porque el arranque del entorno define `_JAVA_AWT_WM_NONREPARENTING`.

## Estructura

Cada carpeta es un paquete de [GNU Stow](https://www.gnu.org/software/stow/) que se enlaza a tu `$HOME`.

```
bspwm/ sxhkd/ polybar/ rofi/ kitty/ picom/ starship/ fastfetch/ zsh/ x11/
wallpapers/   fondos de pantalla
packages/     listas de paquetes (base.txt, vmware.txt)
install.sh    instalador
```

## Personalización

- **Colores**: la paleta se define al inicio de `polybar/.config/polybar/config.ini`, y también en `rofi/.config/rofi/theme.rasi`, `kitty/.config/kitty/kitty.conf` y `starship/.config/starship.toml`.
- **Transparencia y esquinas**: `picom/.config/picom/picom.conf` y `background_opacity` en `kitty.conf`.
- **Picom en máquinas virtuales**: la configuración usa `use-damage = false` y `vsync = false` para evitar ventanas que no se redibujan. Si aun así ves ventanas que desaparecen, cambia `backend` a `"xrender"` (pierdes el desenfoque).

## Aviso

Las herramientas de seguridad se deben usar **solo en sistemas propios o con autorización expresa**.
