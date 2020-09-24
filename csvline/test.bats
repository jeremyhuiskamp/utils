#!/usr/bin/env bats

@test "encode empty line" {
  run cargo run -q --
  [ "$status" -eq 0 ]
  # should this be a blank line, or nothing?
  # and how do we test that with bats?
  [ "$output" = "" ]
}

@test "encode simple single column" {
  run cargo run -q -- foobar
  [ "$status" -eq 0 ]
  [ "$output" = "foobar" ]
}

@test "encode 2 simple columns" {
  run cargo run -q -- foo bar
  [ "$status" -eq 0 ]
  [ "$output" = "foo,bar" ]
}

@test "encode 1 column with quote" {
  run cargo run -q -- 'foo"bar'
  [ "$status" -eq 0 ]
  [ "$output" = '"foo""bar"' ]
}

@test "encode 1 column with comma" {
  run cargo run -q -- 'foo,bar'
  [ "$status" -eq 0 ]
  [ "$output" = '"foo,bar"' ]
}

@test "encode 2 columns with quotes and comma" {
  run cargo run -q -- 'foo"bar' 'foo,bar'
  [ "$status" -eq 0 ]
  [ "$output" = '"foo""bar","foo,bar"' ]
}

@test "simple semi-colon" {
  run cargo run -q -- -d \; foo bar
  [ "$status" -eq 0 ]
  [ "$output" = 'foo;bar' ]
}

@test "flags as data" {
  run cargo run -q -- -- -d \; foo bar
  [ "$status" -eq 0 ]
  [ "$output" = '-d,;,foo,bar' ]
}

@test "empty columns" {
  run cargo run -q -- -- '' '' ''
  [ "$status" -eq 0 ]
  [ "$output" = ',,' ]
}

@test "empty column" {
  run cargo run -q -- -- ''
  [ "$status" -eq 0 ]
  [ "$output" = '""' ]
}
