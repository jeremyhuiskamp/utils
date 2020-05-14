# `htmlesc`

Commandline utility for escaping and unescaping html metacharacters.
Simple wrapper around https://github.com/veddan/rust-htmlescape

## Usage

```shell
$ htmlesc << EOF                                                                (master) 20-05-14 22:05:15
this &amp; that
money &lt; love
EOF
this & that
money < love
$ htmlesc -e << EOF                                                                (master) 20-05-14 22:06:21
this & that
money < love
EOF
this &amp; that
money &lt; love
```
