#!/bin/bash
/usr/bin/perl -pe 's/\e\[[0-9;:]*[a-zA-Z]//g; s/\e\][^\a\e]*(?:\a|\e\\)//g; s/\r//g' | \
    /opt/homebrew/bin/nvim \
    -c "set norelativenumber nonumber nolist showtabline=0 foldcolumn=0 clipboard+=unnamedplus" \
    -c "normal G" \
    -
