#
# Time-stamp: <2016-05-26 10:30:25 andreas>

trianglify-1.pdf: trianglify.mp
	mpost trianglify.mp
	epstopdf trianglify-1.mps
