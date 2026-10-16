# Entorno BSPWM para Kali Linux

Entorno ligero y moderno para Kali Linux, pensado para ethical hacking, bug bounty y auditorías. Parte de una instalación **limpia, sin escritorio gráfico**, e instala solo lo necesario.

## Qué incluye

- **BSPWM + sxhkd**: gestor de ventanas en mosaico controlado por teclado.
- **Polybar**: escritorios 1 al 5, título de ventana, target, IP de la VPN, red, CPU, RAM, volumen y menú de apagado.
- **Rofi**: lanzador de aplicaciones y menú de energía, con tema propio.
- **Kitty**: terminal con paleta Catppuccin Mocha y JetBrainsMono Nerd Font.
- **Starship**: prompt que muestra carpeta, rama de git y el target actual.
- **Picom** (transparencias) y **PipeWire** (audio).

### El target

Define el objetivo actual de tus pruebas con un clic en la barra (clic izquierdo para escribirlo, clic derecho para borrarlo). Aparece en la barra y en el prompt, y queda disponible en la shell como `$TARGET`:

```
nmap -sV "$TARGET"
```

## Requisitos

- Kali Linux instalado desde la ISO *Installer*, sin entorno de escritorio ni herramientas seleccionadas.
- Conexión a internet y un usuario con `sudo`.
- Arquitectura x86_64.

## Instalación

```
sudo apt update && sudo apt install -y git
git clone https://github.com/Sl1nck/AutoBspwm.git ~/dotfiles
cd ~/dotfiles
./install.sh all
```

Si usas una máquina virtual **VMware**, instala además la integración (copiar y pegar, resolución):

```
./install.sh vmware
```

Cierra sesión y vuelve a entrar, y luego inicia el entorno con:

```
startx
```

El instalador se puede ejecutar varias veces sin problema. También acepta pasos sueltos: `packages`, `font`, `starship`, `link`.

Si ya tenías un `~/.zshrc`, se guarda una copia como `~/.zshrc.bak` antes de enlazar el del repo.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `super + Return` | Abrir terminal |
| `super + d` | Lanzador de aplicaciones |
| `super + w` | Cerrar ventana |
| `super + 1` a `5` | Ir al escritorio |
| `super + shift + 1` a `5` | Mover la ventana al escritorio |
| `super + h/j/k/l` | Mover el foco entre ventanas |
| `super + shift + r` | Recargar BSPWM |
| `super + shift + q` | Salir de BSPWM |

Los demás atajos vienen del `sxhkdrc` de ejemplo de BSPWM y se editan en `sxhkd/.config/sxhkd/sxhkdrc`.

## Estructura

Cada carpeta es un paquete de [GNU Stow](https://www.gnu.org/software/stow/) que se enlaza a tu `$HOME`.

```
bspwm/ sxhkd/ polybar/ rofi/ kitty/ starship/ zsh/ x11/
packages/     listas de paquetes (base.txt, vmware.txt)
install.sh    instalador
```

## Personalización

Los colores se definen al inicio de `polybar/.config/polybar/config.ini`, en `rofi/.config/rofi/theme.rasi` y en `kitty/.config/kitty/kitty.conf`. Cambia ahí la paleta para adaptarlos a tu gusto.

## Aviso

Las herramientas de seguridad se deben usar **solo en sistemas propios o con autorización expresa**.
