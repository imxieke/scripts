if [ `uname -m` == 'x86_64' ]; then
    ARCH='x86_64'
else
    ARCH='i386'
fi

function getmirror()
{
	PYTHON=`command -v python 2>/dev/null`
	if [ $? -ne 0 ]; then
		echo "http://dl.appnode.com/"
	fi

	echo "
import sys
import time
import socket
from threading import Thread

gms = [
	['http://appnode-qd.oss-cn-qingdao-internal.aliyuncs.com/', 'http://appnode-qd.oss-cn-qingdao.aliyuncs.com/'],
	['http://appnode-bj.oss-cn-beijing-internal.aliyuncs.com/', 'http://appnode-bj.oss-cn-beijing.aliyuncs.com/'],
	['http://appnode-hz.oss-cn-hangzhou-internal.aliyuncs.com/', 'http://appnode-hz.oss-cn-hangzhou.aliyuncs.com/'],
	['http://appnode-hk.oss-cn-hongkong-internal.aliyuncs.com/', 'http://appnode-hk.oss-cn-hongkong.aliyuncs.com/'],
	['http://appnode-sz.oss-cn-shenzhen-internal.aliyuncs.com/', 'http://appnode-sz.oss-cn-shenzhen.aliyuncs.com/'],
	['http://dl-us1.appnode.com/'],
]

def gct(m):
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.settimeout(1)
	h = m[m.find('://')+3:][:-1]
	p = (m[:m.find(':')]=='https') and 443 or 80
	tb = time.time()
	try:
		i = socket.gethostbyname(h)
		s.connect((i, p))
	except:
		return -1
	finally:
		t = time.time() - tb
		s.close()
	return t

def ggt(g):
	ts = []
	rt = []
	for m in g:
		ts.append(T(target=gct, args=(m,)))
	for t in ts:
		t.start()
	o = 0
	for i, t in enumerate(ts):
		r = t.join()
		if r == -1:
			del g[i+o]
			o -= 1
		else:
			rt.append(r)
	return rt

def gfm():
	ts = []
	rt = []
	for g in gms:
		ts.append(T(target=ggt, args=(g,)))
	for t in ts:
		t.start()
	o = 0
	for i, t in enumerate(ts):
		r = t.join()
		if len(r) == 0:
			del gms[i+o]
			o -= 1
		else:
			rt.append(sum(r)/len(r))
	return gms[rt.index(min(rt))][0]


class T(Thread):
	def __init__(self, group=None, target=None, name=None, args=(), kwargs={}, Verbose=None):
		Thread.__init__(self, group, target, name, args, kwargs, Verbose)
		self._return = None

	def run(self):
		if self._Thread__target is not None:
			self._return = self._Thread__target(*self._Thread__args, **self._Thread__kwargs)

	def join(self):
		Thread.join(self)
		return self._return

sys.stdout.write(gfm())
" | $PYTHON
}

INSTFILE=ccenter-install-$ARCH
DLPATH=/tmp/appnode-$INSTFILE

if [[ $MIRROR == "" ]]; then
    MIRROR=`getmirror`
fi
curl "$MIRROR"install/$INSTFILE > $DLPATH && chmod +x $DLPATH && MIRROR=$MIRROR $DLPATH $@

rm -f $DLPATH
