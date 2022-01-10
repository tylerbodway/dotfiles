status_echo() { tput setaf 6; echo -e $1; tput sgr 0 }
danger_echo() { tput setaf 1; echo -e $1; tput sgr 0 }
warning_echo() { tput setaf 3; echo -e $1; tput sgr 0 }
success_echo() { tput setaf 2; echo -e $1; tput sgr 0 }