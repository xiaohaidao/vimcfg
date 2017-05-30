

[top]

ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
这个指令用于向当前工程添加存放源文件的子目录，并可以指定中间二进制和目标二进制存放的位置。EXCLUDE_FROM_ALL 参数的含义是将这个目录从编译过程中排除，比如，工程的 example，可能就需要工程构建完成后，再进入 example 目录单独进行构建(当然，你也可以通过定义依赖来解决此类问题)。

可以通过 SET 指令重新定义 EXECUTABLE_OUTPUT_PATH 和 LIBRARY_OUTPUT_PATH 变量来指定最终的目标二进制的位置
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
在哪里 ADD_EXECUTABLE 或 ADD_LIBRARY,如果需要改变目标存放路径，就在哪里加入上述的定义。


cmake -DCMAKE_INSTALL_PREFIX=/usr .


CMAKE_INSTALL_PREFIX
CMAKE_INSTALL_PREFIX 的默认定义是/usr/local


目标文件的安装：
```
INSTALL(TARGETS targets...
 [[ARCHIVE|LIBRARY|RUNTIME]
 [DESTINATION <dir>]
 [PERMISSIONS permissions...]
 [CONFIGURATIONS
 [Debug|Release|...]]
 [COMPONENT <component>]
 [OPTIONAL]
 ] [...])
```
TARGETS 后面跟的就是通过ADD_EXECUTABLE和ADD_LIBRARY定义的目标文件。
目标类型也就相对应的有三种，ARCHIVE 特指静态库，LIBRARY 特指动态库，RUNTIME特指可执行目标二进制。

DESTINATION 定义了安装的路径，如果路径以/开头，那么指的是绝对路径，这时候CMAKE_INSTALL_PREFIX 其实就无效了。如果你希望使用 CMAKE_INSTALL_PREFIX 来定义安装路径，就要写成相对路径，即不要以/开头，那么安装后的路径就是${CMAKE_INSTALL_PREFIX}/<DESTINATION 定义的路径>
普通文件的安装：
```
INSTALL(FILES files... DESTINATION <dir>
 [PERMISSIONS permissions...]
 [CONFIGURATIONS [Debug|Release|...]]
 [COMPONENT <component>]
 [RENAME <name>] [OPTIONAL])
```
文件名是此指令所在路径下的相对路径。

默认权限为：OWNER_WRITE, OWNER_READ, GROUP_READ,和 WORLD_READ，即 644 权限。

非目标文件的可执行程序安装(比如脚本之类)：

```
INSTALL(PROGRAMS files... DESTINATION <dir>
 [PERMISSIONS permissions...]
 [CONFIGURATIONS [Debug|Release|...]]
 [COMPONENT <component>]

 [RENAME <name>] [OPTIONAL])
```

默认权限为：OWNER_EXECUTE, GROUP_EXECUTE, 和 WORLD_EXECUTE，即 755 权限
目录的安装：
```
INSTALL(DIRECTORY dirs... DESTINATION <dir>
 [FILE_PERMISSIONS permissions...]
 [DIRECTORY_PERMISSIONS permissions...]
 [USE_SOURCE_PERMISSIONS]
 [CONFIGURATIONS [Debug|Release|...]]
 [COMPONENT <component>]
 [[PATTERN <pattern> | REGEX <regex>]
 [EXCLUDE] [PERMISSIONS permissions...]] [...])
```
DIRECTORY 后面连接的是所在 Source 目录的相对路径，如果目录名不以/结尾，那么这个目录将被安装为目标路径下的 abc，如果目录名以/结尾，代表将这个目录中的内容安装到目标路径，但不包括这个目录本身。
PATTERN 用于使用正则表达式进行过滤，PERMISSIONS 用于指定 PATTERN 过滤后的文件
权限。


### 静态库与动态库构建

```
ADD_LIBRARY(libname [SHARED|STATIC|MODULE]
 [EXCLUDE_FROM_ALL]
 source1 source2 ... sourceN)
```
SHARED，动态库
STATIC，静态库
MODULE，在使用 dyld 的系统有效，如果不支持 dyld，则被当作 SHARED 对待。
EXCLUDE_FROM_ALL 参数的意思是这个库不会被默认构建，除非有其他的组件依赖或者手工构建。
库名称不能同名，要同名可用SET_TARGET_PROPERTIES指令来解决

```
SET_TARGET_PROPERTIES(target1 target2 ...
 PROPERTIES prop1 value1
 prop2 value2 ...)
```
这条指令可以用来设置输出的名称，对于动态库，还可以用来指定动态库版本和 API 版本。
与他对应的指令是：GET_TARGET_PROPERTY(VAR target property)



通过 SET_TARGET_PROPERTIES 同时构建同名的动态库和静态库，
控制动态库版本


### 外部共享库和头文件
```
INCLUDE_DIRECTORIES([AFTER|BEFORE] [SYSTEM] dir1 dir2 ...)
```
这条指令可以用来向工程添加多个特定的头文件搜索路径，路径之间用空格分割，如果路径中包含了空格，可以使用双引号将它括起来，默认的行为是追加到当前的头文件搜索路径的后面
```
LINK_DIRECTORIES(directory1 directory2 ...)
```
这个指令非常简单，添加非标准的共享库搜索路径，
```
TARGET_LINK_LIBRARIES(target library1
 <debug | optimized> library2
 ...)
```
这个指令可以用来为 target 添加需要链接的共享库

特殊的环境变量 CMAKE_INCLUDE_PATH 和 CMAKE_LIBRARY_PATH这两个是环境变量而不是 cmake 变量。
```
FIND_PATH(myHeader NAMES hello.h PATHS /usr/include/usr/include/hello)
```
用来在指定路径中搜索文件名


## cmake语法

### 常用变量和常用环境变量

${}进行变量的引用，在 IF 等语句中，是直接使用变量名而不通过${}取值

有隐式定义和显式定义两种，PROJECT 指令，他会隐式的定义<projectname>_BINARY_DIR 和<projectname>_SOURCE_DIR 两个变量。SET 指令显示定义SET(HELLO_SRC main.SOURCE_PATHc)
```
- cmake常用变量
  - CMAKE_BINARY_DIR，PROJECT_BINARY_DIR，<projectname>_BINARY_DIR这三个变量指代的都是工程顶层目录，如果是 out-of-source 编译，指的是工程编译发生的目录。
  - CMAKE_SOURCE_DIR，PROJECT_SOURCE_DIR，<projectname>_SOURCE_DIR这三个变量不论采用何种编译方式，都是工程顶层目录。
  - CMAKE_CURRENT_SOURCE_DIR指的是当前处理的 CMakeLists.txt 所在的路径
  - CMAKE_CURRRENT_BINARY_DIR如果是 in-source 编译，它跟 CMAKE_CURRENT_SOURCE_DIR 一致，如果是 out-ofsource编译，他指的是 target 编译目录。 ADD_SUBDIRECTORY(src bin)可以更改这个变量的值。使用 SET(EXECUTABLE_OUTPUT_PATH <新路径>)并不会对这个变量造成影响，它仅仅修改了最终目标文件存放的路径。
  - CMAKE_CURRENT_LIST_FILE输出调用这个变量的 CMakeLists.txt 的完整路径
  - CMAKE_CURRENT_LIST_LINE输出这个变量所在的行
  - CMAKE_MODULE_PATH定义自己的 cmake 模块所在的路径。为了让 cmake 在处理CMakeLists.txt 时找到这些模块,SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
这时候你就可以通过 INCLUDE 指令来调用自己的模块了。
  - EXECUTABLE_OUTPUT_PATH 和 LIBRARY_OUTPUT_PATH
分别用来重新定义最终结果的存放目录
  - PROJECT_NAME返回通过 PROJECT 指令定义的项目名称。

- cmake环境变量的调用
  - 使用$ENV{NAME}指令就可以调用系统的环境变量了。
例：MESSAGE(STATUS “HOME dir: $ENV{HOME}”)
。设置环境变量的方式是：SET(ENV{变量名} 值)
  - CMAKE_INCLUDE_CURRENT_DIR自动添加 CMAKE_CURRENT_BINARY_DIR 和 CMAKE_CURRENT_SOURCE_DIR 到当前处理的 CMakeLists.txt。相当于在每个 CMakeLists.txt 加入：INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  - CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE将工程提供的头文件目录始终至于系统头文件目录的前面
  - CMAKE_INCLUDE_PATH 和 CMAKE_LIBRARY_PATH（环境变量）头文件路径和库文件路径

- 系统信息
  - CMAKE_MAJOR_VERSION，CMAKE 主版本号，比如 2.4.6 中的 2
  - CMAKE_MINOR_VERSION，CMAKE 次版本号，比如 2.4.6 中的 4
  - CMAKE_PATCH_VERSION，CMAKE 补丁等级，比如 2.4.6 中的 6
  - CMAKE_SYSTEM，系统名称，比如 Linux-2.6.22
  - CMAKE_SYSTEM_NAME，不包含版本的系统名，比如 Linux
  - CMAKE_SYSTEM_VERSION，系统版本，比如 2.6.22
  - CMAKE_SYSTEM_PROCESSOR，处理器名称，比如 i686.
  - UNIX，在所有的类 UNIX 平台为 TRUE，包括 OS X 和 cygwin
  - WIN32，在所有的 win32 平台为 TRUE，包括 cygwin
```

- 主要开关选项
  - CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS，用来控制 IF ELSE 语句的书写方式
  - BUILD_SHARED_LIBS
用来控制默认的库编译方式，如果不进行设置，使用 ADD_LIBRARY 并没有指定库类型的情况下，默认编译生成的库都是静态库。
  - CMAKE_C_FLAGS
设置 C 编译选项，也可以通过指令 ADD_DEFINITIONS()添加。
  - CMAKE_CXX_FLAGS设置 C++编译选项，也可以通过指令 ADD_DEFINITIONS()添加。

如果需要了解更多的 cmake 变量，更好的方式是阅读一些成功项目的 cmake 工程文件，比如 KDE4 的代码。

### cmake常用指令

```
- 基本指令
  - ADD_DEFINITIONS向 C/C++编译器添加-D 定义
  - ADD_DEPENDENCIES定义 target 依赖的其他 target，确保在编译本 target 之前，其他的 target 已经被构建。
ADD_DEPENDENCIES(target-name depend-target1 depend-target2 ...)
  - ADD_EXECUTABLE、ADD_LIBRARY、ADD_SUBDIRECTORY
  - ADD_TEST 与 ENABLE_TESTING。ENABLE_TESTING 指令用来控制 Makefile 是否构建 test 目标，涉及工程所有目录。语法很简单，没有任何参数，ENABLE_TESTING()，一般情况这个指令放在工程的主CMakeLists.txt 中.
  ADD_TEST(testname Exename arg1 arg2 ...)testname 是自定义的 test 名称，Exename 可以是构建的目标文件也可以是外部脚本等等。后面连接传递给可执行文件的参数。如果没有在同一个 CMakeLists.txt 中打开ENABLE_TESTING()指令，任何 ADD_TEST 都是无效的。

  - AUX_SOURCE_DIRECTORY(dir VARIABLE) 作用是发现一个目录下所有的源代码文件并将列表存储在一个变量中，这个指令临时被用来 自动构建源文件列表。因为目前cmake还不能自动发现新添加的源文件。
  - CMAKE_MINIMUM_REQUIRED(VERSION versionNumber [FATAL_ERROR]) 如果cmake版本小与versionNumber，则出现严重错误，整个过程中止。
  - EXEC_PROGRAM在CMakeLists.txt处理过程中执行命令，并不会在生成的Makefile中执行。
```
```
EXEC_PROGRAM(Executable [directory in which to run]
 [ARGS <arguments to executable>]
 [OUTPUT_VARIABLE <var>]
 [RETURN_VALUE <var>])
```
用于在指定的目录运行某个程序，通过ARGS添加参数，如果要获取输出和返回值，可通过 OUTPUT_VARIABLE和RETURN_VALUE分别定义两个变量.
```
FILE(WRITE filename "message to write"... )
FILE(APPEND filename "message to write"... )
FILE(READ filename variable)
FILE(GLOB  variable [RELATIVE path] [globbing expressions]...)
FILE(GLOB_RECURSE variable [RELATIVE path] [globbing expressions]...)
FILE(REMOVE [directory]...)
FILE(REMOVE_RECURSE [directory]...)
FILE(MAKE_DIRECTORY [directory]...)
FILE(RELATIVE_PATH variable directory file)
FILE(TO_CMAKE_PATH path result)
FILE(TO_NATIVE_PATH path result)
```
- INCLUDE指令，用来载入CMakeLists.txt文件，也用于载入预定义的cmake模块. INCLUDE(file1 [OPTIONAL]) OPTIONAL参数的作用是文件不存在也不会产生错误。
- INSTALL指令
    -  FIND_FILE、FIND_LIBRAR、FIND_PAT、FIND_PROGRAM(<VAR> name1 path1 path2 ...) VAR变量表示找到的路径。FIND_PACKAGE(<name> [major.minor] [QUIET] [NO_MODULE] [[REQUIRED|COMPONENTS] [componets...]])用来调用预定义在CMAKE_MODULE_PATH下的Find<name>.cmake模块，

- 控制指令
```
IF(expression)
  # THEN section.
  COMMAND1(ARGS ...)
  COMMAND2(ARGS ...)
  ...
 ELSE(expression)
  # ELSE section.
  COMMAND1(ARGS ...)
  COMMAND2(ARGS ...)
  ...
 ENDIF(expression)
```
  -  另外一个指令是ELSEIF，总体把握一个原则，凡是出现IF的地方一定要有对应的 ENDIF.出现ELSEIF的地方，ENDIF是可选的。
可以SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS ON) 这时候就可以写成: IF(WIN32) ELSE() ENDIF()

- WHILE
```
WHILE(condition)
    COMMAND1(ARGS ...)
    COMMAND2(ARGS ...)
    ...
ENDWHILE(condition)
```

- FOREACH

```
FOREACH(loop_var arg1 arg2 ...)
  COMMAND1(ARGS ...)
  COMMAND2(ARGS ...)
  ...
ENDFOREACH(loop_var)

FOREACH(loop_var RANGE total)
  COMMAND(ARGS ...)
ENDFOREACH(loop_var)
```
从0到total以１为步进

```
FOREACH(loop_var RANGE start stop [step])
ENDFOREACH(loop_var)
```
从start开始到stop结束，以step为步进，

### 模块和自定义模块

对于系统预定义的Find<name>.cmake模块
```
FIND_PACKAGE(CURL)
IF(CURL_FOUND)
   INCLUDE_DIRECTORIES(${CURL_INCLUDE_DIR})
   TARGET_LINK_LIBRARIES(curltest ${CURL_LIBRARY})
ELSE(CURL_FOUND)
   MESSAGE(FATAL_ERROR ”CURL library not found”)
ENDIF(CURL_FOUND)
```
每一个模块都会定义以下几个变量
```
 <name>_FOUND
 <name>_INCLUDE_DIR or <name>_INCLUDES
 <name>_LIBRARY or <name>_LIBRARIES
```

```
FIND_PACKAGE(<name> [major.minor] [QUIET] [NO_MODULE] [[REQUIRED|COMPONENTS] [componets...]])
```
QUIET参数，对应与我们编写的FindHELLO 中的 HELLO_FIND_QUIETLY，如果不指定 这个参数，就会执行：
MESSAGE(STATUS "Found Hello: ${HELLO_LIBRARY}")。
REQUIRED参数，其含义是指这个共享库是否是工程必须的，如果使用了这个参数，说明这 个链接库是必备库，如果找不到这个链接库，则工程不能编译。
