:: Need to remove the symlink before we start creating the package.
:: ERROR conda.core.link:_execute(938): An error occurred while installing package 'file:///C:/b/abs_aeg6ts_0jm/upload::nutpie-0.13.2-py312hb929689_0'.
:: Rolling back transaction: ...working... done
:: [Errno 2] No such file or directory: 'C:\\b\\abs_aeg6ts_0jm\\pkg_dirs\\nutpie-0.13.2-py312hb929689_0\\Library\\bin\\libclang.dll'
::if "%target_platform%" == "win-64" (
::    if exist "%LIBCLANG_PATH%\libclang.dll" (
::        del "%LIBCLANG_PATH%\libclang.dll"
::    ) else (
::        echo File "%LIBCLANG_PATH%\libclang.dll" not found.
::    )
::)