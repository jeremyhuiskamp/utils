#!/usr/bin/env bats

go() {
  if [ "$args" = "" ]; then
    echo "$1" | cargo run -q
    return $?
  else
    echo "$1" | cargo run -q -- "$args"
    return $?
  fi
}

@test "decode simple string" {
  run go "hai there"
  [ "$status" -eq 0 ]
  [ "$output" = "hai there" ]
}

@test "decode simple entity" {
  run go "this &amp; that"
  [ "$status" -eq 0 ]
  [ "$output" = "this & that" ]
}

@test "encode simple string" {
  args="-e"
  run go "hai there"
  [ "$status" -eq 0 ]
  [ "$output" = "hai there" ]
}

@test "encode simple entity" {
  args="-e"
  run go "this & that"
  [ "$status" -eq 0 ]
  [ "$output" = "this &amp; that" ]
}

@test "decode two lines" {
  run go $'&lt;hai\nthere&gt;'
  [ "$status" -eq 0 ]
  echo "'{$output}'" >&2
  [ "$output" = $'<hai\nthere>' ]
}

@test "encode two lines" {
  args="-e"
  run go $'<hai\nthere>'
  [ "$status" -eq 0 ]
  [ "$output" = $'&lt;hai\nthere&gt;' ]
}

@test "invalid flag" {
  args="-f"
  run go "hai"
  [ "$status" -eq 1 ]
  [[ "$output" =~ ^usage: ]]
}

@test "decode invalid" {
  run go "unrequited &amp ersand"
  [ "$status" -eq 1 ]
  [[ "$output" =~ DecodeErr ]]
  # stderr:
  # Error: DecodeErr { position: 11, kind: PrematureEnd }
  # stdout:
  # unrequited
}
