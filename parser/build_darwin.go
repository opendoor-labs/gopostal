package postal

// #cgo amd64 LDFLAGS: ${SRCDIR}/../vendor/libpostal_darwin.a -lm
// #cgo arm64 LDFLAGS: ${SRCDIR}/../vendor/libpostal_darwin_aarch64.a -lm
// #cgo CFLAGS: -I${SRCDIR}/..
import "C"
