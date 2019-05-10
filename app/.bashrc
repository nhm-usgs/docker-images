# .bashrc

# User specific aliases and functions

alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# gprof2dot installs in a weird location
export PATH="/opt/rh/rh-python35/root/usr/bin:$PATH"

# the least-worst TERM setting we've found thus far for Windows PowerShell
export TERM=vt100
