set "PYO3_PYTHON=%PYTHON%"
set "LIBCLANG_PATH=%LIBRARY_BIN%"

:: clangdev cotains only libclang-13.dll, but rust needs libclang.dll in the arrow v52.1.0 component.
:: # Unable to find libclang: "couldn't find any valid shared libraries matching: ['clang.dll', 'libclang.dll'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"
if "%target_platform%" == "win-64" (
    if not exist "%LIBCLANG_PATH%\libclang.dll" (
        mklink "%LIBCLANG_PATH%\libclang.dll" "%LIBCLANG_PATH%\libclang-13.dll"
    )
)

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo LIBCLANG_PATH: %LIBCLANG_PATH%
echo ----------------------------------------------------------------------
dir "%LIBCLANG_PATH%"
echo ----------------------------------------------------------------------
dir "%PREFIX%\Library\*libclang*" /s /b
echo ----------------------------------------------------------------------

maturin build -v --jobs 1 --bindings pyo3 --release --manylinux off --interpreter=%PYTHON%
if errorlevel 1 exit 1

FOR /F "delims=" %%i IN ('dir /s /b target\wheels\*.whl') DO set nutpie_wheel=%%i
%PYTHON% -m pip install --ignore-installed --no-deps --no-build-isolation %nutpie_wheel% -vv
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: Need to remove the symlink before we start creating the package.
:: ERROR conda.core.link:_execute(938): An error occurred while installing package 'file:///C:/b/abs_aeg6ts_0jm/upload::nutpie-0.13.2-py312hb929689_0'.
:: Rolling back transaction: ...working... done
:: [Errno 2] No such file or directory: 'C:\\b\\abs_aeg6ts_0jm\\pkg_dirs\\nutpie-0.13.2-py312hb929689_0\\Library\\bin\\libclang.dll'
if "%target_platform%" == "win-64" (
    if exist "%LIBCLANG_PATH%\libclang.dll" (
        del "%LIBCLANG_PATH%\libclang.dll"
    ) else (
        echo File "%LIBCLANG_PATH%\libclang.dll" not found.
    )
)