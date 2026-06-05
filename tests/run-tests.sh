#!/usr/bin/env bash
# Behavioral test suite for COLTSR, driven through DOSBox.
#
# Requires: COLTSR.COM, tests/CHKCOLOR.COM, tests/HOOK1C.COM (see Makefile)
# Override the emulator with DOSBOX=<binary>, extra args with DOSBOX_ARGS.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
WORK_DIR="$SCRIPT_DIR/work"
DOSBOX="${DOSBOX:-dosbox}"
DOSBOX_ARGS="${DOSBOX_ARGS:-}"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cp "$REPO_DIR/COLTSR.COM" "$SCRIPT_DIR/CHKCOLOR.COM" "$SCRIPT_DIR/HOOK1C.COM" "$WORK_DIR/"

# DOS-side test script; each step leaves its output in a Tn.TXT file
cat > "$WORK_DIR/TESTS.BAT" <<'EOF'
@echo off
coltsr.com > T1.TXT
chkcolor.com > T2.TXT
coltsr.com > T3.TXT
chkcolor.com > T4.TXT
coltsr.com > T5.TXT
hook1c.com > T6.TXT
coltsr.com > T7.TXT
echo DONE > FINISHED.TXT
EOF

# native DOSBox path of the work dir (Windows path for Windows builds)
MOUNT_DIR="$WORK_DIR"
if command -v cygpath >/dev/null 2>&1; then
  MOUNT_DIR="$(cygpath -w "$WORK_DIR")"
fi

cat > "$WORK_DIR/test.conf" <<EOF
[sdl]
[render]
[cpu]
cycles=10000
[autoexec]
mount c "$MOUNT_DIR"
c:
call TESTS.BAT
exit
EOF

TIMEOUT_CMD=""
command -v timeout >/dev/null 2>&1 && TIMEOUT_CMD="timeout 120"

echo "Running DOSBox test session ($DOSBOX)..."
SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-dummy}" SDL_AUDIODRIVER=dummy \
  $TIMEOUT_CMD "$DOSBOX" $DOSBOX_ARGS -conf "$WORK_DIR/test.conf" >/dev/null 2>&1

if [ ! -f "$WORK_DIR/FINISHED.TXT" ]; then
  echo "FATAL: DOSBox session did not complete (FINISHED.TXT missing)" >&2
  exit 1
fi

FAILED=0
assert_contains() { # <file> <needle> <description>
  local file="$WORK_DIR/$1" needle="$2" desc="$3"
  if grep -q "$needle" "$file" 2>/dev/null; then
    echo "PASS: $desc"
  else
    echo "FAIL: $desc"
    echo "      expected '$needle' in $1, got: $(tr -d '\r' < "$file" 2>/dev/null || echo '<missing>')"
    FAILED=1
  fi
}

# Given a clean system, When COLTSR runs, Then it installs
assert_contains T1.TXT "Handler installed" "install on clean system reports success"
# Given the TSR is resident, When text appears on screen, Then it is colourized per table
assert_contains T2.TXT "COLORIZED" "resident TSR colourizes digits/operators/strings, leaves letters alone"
# Given the TSR is resident, When COLTSR runs again, Then it unhooks and frees memory
assert_contains T3.TXT "Freed Memory" "second invocation removes the TSR"
# Given the TSR was removed, When text appears on screen, Then nothing is colourized (negative control)
assert_contains T4.TXT "UNCHANGED" "after removal the screen is left untouched"
# Given the TSR was removed, When COLTSR runs, Then it installs again
assert_contains T5.TXT "Handler installed" "reinstall after removal succeeds"
assert_contains T6.TXT "1C hooked" "fixture TSR hooks INT 1Ch in front"
# Given another TSR hooked INT 1Ch afterwards, When COLTSR tries to remove itself, Then it refuses
assert_contains T7.TXT "Unable 2 Remove" "removal is refused while vectors are foreign-owned"

if [ "$FAILED" -ne 0 ]; then
  echo "Test suite FAILED"
  exit 1
fi
echo "Test suite PASSED"
