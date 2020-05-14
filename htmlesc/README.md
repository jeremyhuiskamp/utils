# `htmlesc`

Commandline utility for escaping and unescaping html metacharacters.
Simple wrapper around https://github.com/veddan/rust-htmlescape

## Usage

```shell
$ htmlesc << EOF
this &amp; that
money &lt; love
EOF
this & that
money < love
$ htmlesc -e << EOF
this & that
money < love
EOF
this &amp; that
money &lt; love
```
