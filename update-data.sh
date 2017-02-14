#!/bin/sh

# The VegaDNS2 tinydns export endpoint
# Can be a space delimited list of VegaDNS2 servers
VEGADNS="${API_URL:-http://localhost:5000}/1.0/export/tinydns"

# Path to the tinydns directory
ROOT=${ROOT:-/etc/tinydns/root}

CUR="${ROOT}/data"
OLD="${ROOT}/data.old"
NEW="${ROOT}/data.new"


if [ -f "$CUR" ] ; then
    cp "$CUR" "$OLD"
fi

if [ -f "$NEW" ] ; then
    rm "$NEW"
fi

A=$((0))
for VD in $VEGADNS ; do
    A=$((A+1))
    if wget -q -O "${ROOT}/data.srv-$A" "$VD" ; then
        if [ -s "${ROOT}/data.srv-$A" ] ; then
            cat "${ROOT}/data.srv-$A" >> "$NEW"
        else
            echo "ERROR: ${ROOT}/data.srv-$A does not have a size greater than zero" 1>&2
            exit 1
        fi
    else
        echo "ERROR: wget did not return 0 when accessing $VD" 1>&2
        exit 1
    fi
    if [ -f "${ROOT}/data.srv-$A" ] ; then
        rm "${ROOT}/data.srv-$A"
    fi
done

# Don't run make if the files havn't changed
OLDSUM=$(sum "$OLD" | awk '{ print $1 " " $2}')
NEWSUM=$(sum "$NEW" | awk '{ print $1 " " $2}')

if [ "$OLDSUM" != "$NEWSUM" ]; then
    mv "$NEW" "$CUR"
    cd "${ROOT}" && tinydns-data
else
    rm "$NEW"
fi

diff -u "$OLD" "$CUR"

sleep ${CHECK_DELAY:-0}
exit 0
