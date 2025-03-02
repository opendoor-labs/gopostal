load("//:repositories.bzl", "libpostal_data_files")
def _non_module_dependencies_impl(_ctx):
    libpostal_data_files()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)
