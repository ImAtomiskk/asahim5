#!/bin/bash
# EZBuilder By ImCubical
# Does Everything in 1 File

MAKEFLAGS="-j$(nproc)"
if [[ -e $(pwd)/m1n1 ]]; then
    _dir=$(pwd)/m1n1
elif [[ -e $(pwd)/asahim5 ]]; then
    _dir=$(pwd)/asahim5/m1n1
fi

fourxBootLogo="$_dir/data/BootLogo_48.png"
onexBootLogo="$_dir/data/BootLogo_128.png"
twoxBootLogo="$_dir/data/BootLogo_256.png"


main_menu() {
if [[ -e /usr/bin/make ]] && [[ -e /usr/bin/git ]] && [[ -e /usr/bin/gcc ]] && [[ -e $_dir ]]; then
    clear
    echo "------------------------------"
    echo "Welcome to EZBuilder"
    echo "------------------------------"
    echo "[1] Build m1n1 Now"
    echo "[2] Clean m1n1 Build Folder"
    echo "[3] Change Boot Logo"
    echo "[4] Check Dependencies"
    echo "[5] Change MAKEFLAGS (Adv.)"
    echo "[6] Exit"
    echo "------------------------------"
    read -p "Enter a Choice: " num
    if [[ $num -eq 1 ]]; then
        clear
        chmod -R +x m1n1/ 2>/dev/null || chmod -R +x asahim5/m1n1/
        cd $_dir || cd m1n1 || cd asahim5/m1n1
        make $MAKEFLAGS
        echo "Complete!"
        read -r -n 1 -s -p "Press any key to continue..."
        main_menu
    elif [[ $num -eq 2 ]]; then
        clear
        sudo rm -rf build
        echo "Complete!"
        read -r -n 1 -s -p "Press any key to continue..."
        main_menu
    elif [[ $num -eq 3 ]]; then
        clear
        read -p "Enter 48x48 Bootlogo Path (.PNG): " fourxBootLogo
        read -p "Enter 128x128 Bootlogo Path (.PNG): " onexBootLogo
        read -p "Enter 256x256 Bootlogo Path (.PNG): " twoxBootLogo
        cp "$fourxBootLogo" data
        cp "$onexBootLogo" data
        cp "$twoxBootLogo" data
        chmod +x m1n1/data/*.sh 2>/dev/null || chmod +x asahim5/m1n1/data/*.sh 2>/dev/null
        echo "BootLogo Set!"
        main_menu
    elif [[ $num -eq 4 ]]; then
        clear
        if [[ -e /usr/bin/gcc ]]; then
          gccexist=True
        else
          gccexist=False
        fi
        if [[ -e /usr/bin/g++ ]]; then
          gppexist=True
        else
          gppexist=False
        fi
        if [[ -e /usr/bin/make ]]; then
          makeexist=True
        else
          makeexist=False
        fi
        echo "
        gcc Exist? $gccexist
        g++ Exist? $gppexist
        Make Exist? $makeexist
        "
        read -r -n 1 -s -p "Press any key to continue..."
        echo ""
        main_menu
    elif [[ $num -eq 5 ]]; then
      clear
      read -p "Set MAKEFLAGS: " MAKEFLAGS
      main_menu
    elif [[ $num -eq 6 ]]; then
      exit 0

    else
      echo "Invalid Option"
      main_menu
    fi



elif [[ -e /usr/bin/make ]] && [[ -e /usr/bin/git ]] && [[ -e /usr/bin/gcc ]] && [[ ! -e m1n1 ]]; then
    clear
        echo "------------------------------"
        echo "Welcome to EZBuilder"
        echo "------------------------------"
        echo "[1] Clone m1n1 Repository"
        echo "[2] Check Dependencies"
        echo "[3] Exit"
        echo "------------------------------"
        read -p "Enter a Choice: " num
        if [[ $num -eq 1 ]]; then
            if [[ -e "/usr/bin/git" ]]; then
              git clone "https://github.com/ImAtomiskk/asahim5.git"
            else
              sudo apt update
              sudo apt install git -y
              git clone "https://github.com/ImAtomiskk/asahim5.git"
            fi
            main_menu
        elif [[ $num -eq 2 ]]; then
            clear
            if [[ -e /usr/bin/gcc ]]; then
              gccexist=True
            else
              gccexist=False
            fi
            if [[ -e /usr/bin/g++ ]]; then
              gppexist=True
            else
              gppexist=False
            fi
            if [[ -e /usr/bin/make ]]; then
              makeexist=True
            else
              makeexist=False
            fi
            echo "
            gcc Exist? $gccexist
            g++ Exist? $gppexist
            Make Exist? $makeexist
            "
            read -r -n 1 -s -p "Press any key to continue..."
            echo ""
            main_menu
        elif [[ $num -eq 3 ]]; then
          exit 0

        else
          echo "Invalid Option"
          main_menu
        fi
elif [[ -e $_dir ]] && [[ ! -e /usr/bin/make ]] || [[ ! -e /usr/bin/git ]] || [[ ! -e /usr/bin/g++ ]]; then
    clear
            echo "------------------------------"
            echo "Welcome to EZBuilder"
            echo "------------------------------"
            echo "[X] Clone asahim5 Repository"
            echo "[2] Install Dependencies"
            echo "[3] Exit"
            echo "------------------------------"
            read -p "Enter a Choice: " num
            if [[ $num -eq 2 ]]; then
                sudo apt install build-essential git -y
                main_menu
            elif [[ $num -eq 3 ]]; then
              exit 0

            else
              echo "Invalid Option"
              main_menu
            fi
else
       clear
               echo "------------------------------"
               echo "Welcome to EZBuilder"
               echo "------------------------------"
               echo "[X] Clone asahim5 Repository"
               echo "[2] Install Dependencies"
               echo "[3] Exit"
               echo "------------------------------"
               read -p "Enter a Choice: " num
               if [[ $num -eq 2 ]]; then
                   sudo apt install build-essential git -y
                   main_menu
               elif [[ $num -eq 3 ]]; then
                 exit 0

               else
                 echo "Invalid Option"
                 main_menu
               fi
fi
}
main_menu