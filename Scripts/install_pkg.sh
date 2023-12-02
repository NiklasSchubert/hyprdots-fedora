#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| Prasanth Rangan                        |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if ! pkg_installed git
    then
    echo "installing dependency git..."
    sudo dnf install -y git
fi

echo "installing copr..."
./install_copr.sh

install_list="${1:-custom-hypr.lst}"

while read pkg; do
    if [ -z $pkg ]; then
        continue
    fi

    if [ ! -z "${deps}" ]; then
        deps="${deps%"${deps##*[![:space:]]}"}"
        while read -r cdep; do
            pass=$(cut -d '#' -f 1 "${listPkg}" | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            if [ -z "${pass}" ]; then
                if pkg_installed "${cdep}"; then
                    pass=1
                else
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

    elif pkg_available ${pkg}
        then
        echo "queueing ${pkg} from dnf..."
        pkg_dnf=`echo $pkg_dnf ${pkg}`

    else
        echo "error: unknown package ${pkg}..."
    fi

if [ `echo $pkg_dnf | wc -w` -gt 0 ]
    then
    echo "installing $pkg_dnf from dnf..."
    sudo dnf install -y $pkg_dnf
fi

# python-pyamdgpuinfo
if amd_detect
    then
    pip install pyamdgpuinfo
fi

# oh-my-zsh-git
ZSH=/usr/share/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# zsh-theme-powerlevel10k-git
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/zsh-theme-powerlevel10k/

# pokemon-colorscropts
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git
cd pokemon-colorscripts
sudo ./install.sh
cd ..
