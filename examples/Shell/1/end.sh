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
��.KVend.sh �Vmo�F�~�b�VEj�[�T!�
�H(�H"����׋w�M�U{jT�EE��(

mɗUHm��g��v��{�{�t������gf����P��!�+~y;~v'���:8��il��?=i��l������e����V��^\�:|�ܾc���V�Bʨ�b(�L# d���Y�I���ɳO�b*��4tVxFQ5�($�L�!� �Q��+X��M��ɻv� "B�H��r�^'��&�x�nc��>�������?�j4~�Q�ʼǙ�)=ܦ��J"Jh���"����Ŭ�|�e�����ꩇX=�K>
�Pg�$�V�*@�Ms��R��2%�8��S�pX�[YO��TH��O��kV��p-�B�0�EB�0��B�	�a�v4��U'�A|�@�']�b�[���ꭹ��s�\\l=�!^h�Y�K=T�0$�=�^���������栄9�o�d��1����0���+c{�R���l1�V�B��(D8��)r��ϊs�i/'[�2畎^=���%]\��>j�9;���6on�?o6_�7�7�}��<X���e�
q`@XI]�s���3�"X��#,m�GG��������LT�ׇ���������n���[f�ZA�n�z�<yzjr�����IX8�N�����D�x�	�߂ E�l���i015ͫ3��|>=�.��S'5\��T*P�"'��G]R7����+�擬:������,_�k�|�l�jx�O2�o��)ä�"�#i�#�^E6�Ѓl56����Nv���ɀ|�z�_�Ճ����58���j��Gvf����,p���Y`ܺ�s�fu[����Y�}Z�"轀?�Z��G%��0@�M|*:HZ1|A2AQ��J��oi'_�d�ڡ��o�����Z���I��  