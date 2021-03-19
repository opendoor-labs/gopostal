BUILD_TMPL = """\
filegroup(
    name = "data_files",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
"""

def _libpostal_data_files_impl(repository_ctx):
    repository_ctx.download_and_extract(
        url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/language_classifier.tar.gz",
        sha256 = "16a6ecb6d37e7e25d8fe514255666852ab9dbd4d9cc762f64cf1e15b4369a277",
    )
    repository_ctx.download_and_extract(
        url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/libpostal_data.tar.gz",
        sha256 = "d2ec50587bf3a7e46e18e5dcde32419134266f90774e3956f2c2f90d818ff9a1",
    )
    repository_ctx.download_and_extract(
        url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/parser.tar.gz",
        sha256 = "7194e9b0095f71aecb861269f675e50703e73e352a0b9d41c60f8d8ef5a03624",
    )
    repository_ctx.file("BUILD.bazel", BUILD_TMPL)

_libpostal_data_files = repository_rule(
    implementation = _libpostal_data_files_impl,
    attrs = {},
)

def libpostal_data_files():
    _libpostal_data_files(
        name = "libpostal_data_files",
    )
