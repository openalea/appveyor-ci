:: Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ::
::                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ::
::                                                                       ::
:: This file is part of the StatisKit project. More information can be   ::
:: found at                                                              ::
::                                                                       ::
::     http://autowig.rtfd.io                                            ::
::                                                                       ::
:: The Apache Software Foundation (ASF) licenses this file to you under  ::
:: the Apache License, Version 2.0 (the "License"); you may not use this ::
:: file except in compliance with the License. You should have received  ::
:: a copy of the Apache License, Version 2.0 along with this file; see   ::
:: the file LICENSE. If not, you may obtain a copy of the License at     ::
::                                                                       ::
::     http://www.apache.org/licenses/LICENSE-2.0                        ::
::                                                                       ::
:: Unless required by applicable law or agreed to in writing, software   ::
:: distributed under the License is distributed on an "AS IS" BASIS,     ::
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ::
:: mplied. See the License for the specific language governing           ::
:: permissions and limitations under the License.                        ::

set ANACONDA_FORCE=true

if "%ANACONDA_OWNER%" == "openalea" if not "%ANACONDA_LABEL%" == "release" if not "%ANACONDA_LABEL%" == "unstable" (
    echo "Variable ANACONDA_LABEL set to '%ANACONDA_LABEL%' instead of 'release' or 'unstable'"
    exit 1
)
if "%ANACONDA_OWNER%" == "openalea" if not "%ANACONDA_LABEL%" == "unstable" if not "%ANACONDA_LABEL%" == "release" (
    echo "Variable ANACONDA_LABEL set to '%ANACONDA_LABEL%' instead of 'release' or 'unstable'"
    exit 1
)

if "%ANACONDA_LABEL%" == "release" (
    if "%APPVEYOR_REPO_BRANCH%" == "master" (
        if "%OLD_BUILD_STRING%" == "" (
            set OLD_BUILD_STRING=false
        )
        set ANACONDA_LABEL_ARG=win-%ARCH%_release
    ) else (
        if "%OLD_BUILD_STRING%" == "" (
            set OLD_BUILD_STRING=true
        )
        set ANACONDA_LABEL_ARG=unstable
    )
) else (
    if "%OLD_BUILD_STRING%" == "" (
        set OLD_BUILD_STRING=false
    )
    set ANACONDA_LABEL_ARG=%ANACONDA_LABEL%
)

if not "%ANACONDA_OWNER%" == "openalea" (
    conda.exe config --add channels openalea
    if errorlevel 1 exit 1
    if not "%ANACONDA_LABEL%" == "release" (
        conda.exe config --add channels openalea/label/unstable
        if errorlevel 1 exit 1
    )
)

conda.exe config --add channels %ANACONDA_OWNER%
if errorlevel 1 exit 1
if not "%ANACONDA_LABEL%" == "main" (
    conda.exe config --add channels %ANACONDA_OWNER%/label/%ANACONDA_LABEL_ARG%
    if errorlevel 1 exit 1
)
