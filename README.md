**qdloggerl**
=============

Quick and dirty logger for erlang

### What is qdloggerl? ###
*qdloggerl* is a logging library for **Erlang**. It is intended as a simple and lightweight way of logging events, contained within a single header file, and designed to change the log level only at **compile time**.
However, don't look at it as a ultra-optimized logger or the fastest in the market, since it was not its original purpose.
If you can improve its performance, feel free to send a pull request, fork it or modify it for your own purposes. Any suggestion about the format will also be welcome.

### Usage ###
qdlogger provides ten main macros, two for each log type: `LOG_<type>(Tag, Msg)` and `LOG_<type>(Tag, Format, Data)` (replace `<type>` with the initial character of the desired log type):  
`LOG_D`: debug  
`LOG_I`: info  
`LOG_W`: warning  
`LOG_E`: error  
`LOG_F`: fatal erro

###### Example of use ######
Let's see an example. Imagine you have the following two lines of code inside a function called `bar`, contained in a module called `foo` (file `foo.erl`).  
Line 30: `{A, B} = {"Hello world", 42},`  
Line 31: `?LOG_D("TEST", "Just assigned {\"%s\", %w} to {A, B}.~nThis is a new line.", [A, B]).`  
If log level is set to _DEBUG_ (since it is the lowest level, if log level is set to a higher one, it won't write anything to _sdtout_), the output you will get is:  
`[D][2012/07/26-23:04:47][foo:bar:31] TEST :: Just assigned {"Hello world", 42} to {A, B}.`  
`[D][2012/07/26-23:04:47][foo:bar:31] TEST :: This is a new line.`  

###### More macros ######
The other `LOG` macros work the same way. The two-argument macro just prints the contents of Msg, in fact, calling the three-argument macro is just syntactic sugar for the two-argument one with `Tag` as first argument and `io_lib:format(Format, Data)` as second.

You can also use the `LOG_(Level, Tag, Msg)` and `LOG_(Level, Tag, Format, Data)` macros, the first extra argument `Level` specifying the desired level (either by numeric representation or by using `LOG_LEVEL_<level>` constant definitions). There are also two more macros, `LOG(Tag, Msg)` and `LOG(Tag, Format, Data)`, which default to LOG_I, but for code clarity, their use is discouraged.  

#### Installation / configuration ####
To use qdlogger you just have to put the header file `qdloggerl.hrl` into your source directory and include it just like any other library: `-include("qdloggerl.hrl").`. Its log levels are self-descriptive:

`%% Log levels`  
`-define(LOG_LEVEL_DEBUG, 4).    %% D: All log information is printed.`  
`-define(LOG_LEVEL_INFO, 3).     %% I: Errors, warnings, information.`  
`-define(LOG_LEVEL_WARN, 2).     %% W: Errors and warnings are printed.`  
`-define(LOG_LEVEL_ERROR, 1).    %% E: Only errors are printed.`  
`-define(LOG_LEVEL_FATAL, 0).    %% F: Only fatal error are printed.`  

To configure how much information is printed, you can either modify the `LOG_LEVEL` constant definition in the header, or pass the compiler the desired level (`erlc <yourfile> -DLOG_LEVEL=2` will set the logger level to _WARN_). If you don't modify the header neither tell the compiler which level you want, it defaults to 3, that is, _INFO_ level.

If you want to disable **all logs**, just pass `-DNOLOG` to the compiler, and it will disable the output (all macros will expand to just the atom `ok`).  

### License ###
This software is licensed under the GNU General Public License version 3. See `COPYING`.  

### Extra ###
You can contact me if you want me to write a readme that is actually larger than the source code. With this one, and without counting the license, I totally succeded.