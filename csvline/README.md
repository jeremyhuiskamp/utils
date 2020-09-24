# `csvline`

Commandline utility for escaping csv output.  This is meant for
shell scripting, where the easiest way to safely pass fields to a command
is as arguments.

## Usage

```shell
$ csvline -h
CSV line escaper
formats a single line of csv output

USAGE:
    csvline [OPTIONS] [columns]...

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
    -d, --delimiter <CHAR>     [default: ,]

ARGS:
    <columns>...

$ csvline -- 'foo"bar' 'foo,bar' 'foobar'
"foo""bar","foo,bar",foobar
$ csvline -d ';' -- 'foo"bar' 'foo,bar' 'foobar'
"foo""bar";foo,bar;foobar
```

It is recommended to always use `--` before data
arguments to avoid data that starts with a dash being
accidentally mistaken for a flag.