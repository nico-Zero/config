language=`echo "golang lua python c cpp typescript javascript nodejs html java" | tr ' ' '\n'`
core_utils=`echo "xargs mv find sed awk" | tr ' ' '\n'`

selected=`printf "$language\n$core_utils" | fzf --reversed`
read -p "query: " query

if echo "$language" | grep -qs $selected; then
    tmux new bash -c "curl cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
else
    curl cht.sh/$selected~$query
fi
