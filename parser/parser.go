package postal

/*
#include "vendor/libpostal.h"
#include <stdlib.h>
*/
import "C"

import (
	"log"
	"os"
	"sync"
	"unicode/utf8"
	"unsafe"

	"github.com/bazelbuild/rules_go/go/tools/bazel"
)

var mu sync.Mutex

func getDataDir() string {
	if dir := os.Getenv("LIBPOSTAL_DATA_DIR"); dir != "" {
		return dir
	}
	path, err := bazel.Runfile("external/libpostal_data_files")
	if err != nil {
		log.Fatal("Could not find libpostal data dir")
	}
	return path
}

func init() {
	dataDir := C.CString(getDataDir())

	if !bool(C.libpostal_setup_datadir(dataDir)) || !bool(C.libpostal_setup_parser_datadir(dataDir)) {
		log.Fatal("Could not load libpostal")
	}
}

type ParserOptions struct {
	Language string
	Country  string
}

func getDefaultParserOptions() ParserOptions {
	return ParserOptions{
		Language: "",
		Country:  "",
	}
}

var parserDefaultOptions = getDefaultParserOptions()

type ParsedComponent struct {
	Label string `json:"label"`
	Value string `json:"value"`
}

func ParseAddressOptions(address string, options ParserOptions) []ParsedComponent {
	if !utf8.ValidString(address) {
		return nil
	}

	mu.Lock()
	defer mu.Unlock()

	cAddress := C.CString(address)
	defer C.free(unsafe.Pointer(cAddress))

	cOptions := C.libpostal_get_address_parser_default_options()
	if options.Language != "" {
		cLanguage := C.CString(options.Language)
		defer C.free(unsafe.Pointer(cLanguage))

		cOptions.language = cLanguage
	}

	if options.Country != "" {
		cCountry := C.CString(options.Country)
		defer C.free(unsafe.Pointer(cCountry))

		cOptions.country = cCountry
	}

	cAddressParserResponsePtr := C.libpostal_parse_address(cAddress, cOptions)

	if cAddressParserResponsePtr == nil {
		return nil
	}

	cAddressParserResponse := *cAddressParserResponsePtr

	cNumComponents := cAddressParserResponse.num_components
	cComponents := cAddressParserResponse.components
	cLabels := cAddressParserResponse.labels

	numComponents := uint64(cNumComponents)

	parsedComponents := make([]ParsedComponent, numComponents)

	// Accessing a C array
	cComponentsPtr := (*[1 << 30](*C.char))(unsafe.Pointer(cComponents))
	cLabelsPtr := (*[1 << 30](*C.char))(unsafe.Pointer(cLabels))

	var i uint64
	for i = 0; i < numComponents; i++ {
		parsedComponents[i] = ParsedComponent{
			Label: C.GoString(cLabelsPtr[i]),
			Value: C.GoString(cComponentsPtr[i]),
		}
	}

	C.libpostal_address_parser_response_destroy(cAddressParserResponsePtr)

	return parsedComponents
}

func ParseAddress(address string) []ParsedComponent {
	return ParseAddressOptions(address, parserDefaultOptions)
}
