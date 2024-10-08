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
���XOpenVPN.sh �Y[SI~f~Eo�R��!*�7��%K�R��e0Yr3E�l%B4@ A�;"& (!�1N��ɿ�=ӹ�&*�V�S��u�7�|���p����}#l�_x�3cBw
�Q��V�8��KpC�lj�[��S#p'z`b�G>lM`d�6�Ƞ�=�M��Oz�e?PV���Z�w���T���vY	��s���#�`�T�Qrym��+O�%��-�� �v���h���8e2\��F�#�(7���~�����H��e���=� Nж -�^M��9�W�����t��n���%����Γ>���6��V])M*/k�;������o4��Z����^$:i���&		45گs�h��
�y�YHv���soB��uaa{V�x �8� Ë@庫���">�?�Z������;::ț>�ǐ6�[�)��7`*�)E�G�@��A~9I�Cq18M���(1�HLOS�Ҹ��V�(d
>�L��.��Ƕ)����ȳ��o��V%�x�gbȜb�"Z�(���Ga"��a,�f���un`&z���^���S�e2�Ɩ�@x�����cp�_ΑƓ{�SI+��c�gS}��s���؆�n��)��ǻ1S.2,ð�!�^���|�&JU��"�˫��07��!�L[�����H{^�Bs_?��M�	��=���4�`ݰ濾dH=��q$!>.�LZ�܃��P�����=�<����`�
�_�j?m��,k6_��R���]g���dG�~�P�R�BH�p�@TI��L��~���Q��温���F�l��~�;�O��ާL��8�/���������#���D�D,adE�tR�X�F�����
w|�2��t�p�0|�� ���Wѭ�`��7�ۇ��x��"��C� g
�a7W���J^�g�PvŪl /j�Z���D�W�s��_�����v`�,
�Z]Cv>��Z������Iۉ��؇���Fՠ�-g@v|�S�(ѣ仝��@���⟅>l���y������z{���Ó��E��"q؛SE�%//��g��9�aTH,
�4���|��pQ��Z���^����s���<�õ�}��h�0*>�ǙW�I$0,!y�	�_���REa��eE��J��k7�˫$�b�{]��u>=��ه�{a�+�ʭ������=����AO+D��J�"�X���-ԑE_�TPJ�@W'�r��ǸL��E��1���%u�Q	6���:�a��in2��i�(���٧��3u�1CѬ�9�0v�˫��Ւ��Ts�T����~�������[~bus�+�?8�������H��`�-�޵9r�5��ټk�n�|�.�>�
�xR�o�Jw06�Z_�N�s8_��^TN�/:Z����2���pg�x��f�y�g6O �5:iB.�P�$u��H�Ӏ+W�"��Hn勖��W3�i=�a��{�:Wπ&B~�Q}'��U}Gz�q�j�x���$!���.:�?�WW�����C�@mV����p�]��Cyo�<���R��>J1�1K��y+���
�!�"�X;�m%ZG+������t�3O	7�5T�H-����V'�T�S��Ī�RA�g���*��m%Z�*������d-6�U�X�+d�|��{h��~��+]m��>� S�`R��Y(��j�ў�3��ۘ9���YW!g��>f����`��v�*�Sݖu_īu���?��Z=P�/��Y�+S����Y�CR�F�g|4m����a��"�ߒxs��H9=L��*d�������?RZ����ȯ@m�2W�  