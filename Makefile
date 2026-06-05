# Build COLTSR.COM with JWasm (MASM-compatible, open source)
# Override the assembler with: make ASM=uasm
ASM      ?= jwasm
ASMFLAGS ?= -bin -q

TARGET   := COLTSR.COM
FIXTURES := tests/CHKCOLOR.COM tests/HOOK1C.COM

all: $(TARGET)

$(TARGET): COLTSR.ASM
	$(ASM) $(ASMFLAGS) -Fo=$@ $<

tests/%.COM: tests/%.ASM
	$(ASM) $(ASMFLAGS) -Fo=$@ $<

test: $(TARGET) $(FIXTURES)
	bash tests/run-tests.sh

clean:
	rm -f $(TARGET) $(FIXTURES)
	rm -rf tests/work

.PHONY: all test clean
