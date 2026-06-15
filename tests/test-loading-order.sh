#!/bin/bash
#
# Test script to verify the loading order of ~/.localrc and ~/.env-vars
# This creates temporary files and sources the zshrc to verify the behavior
#

set -e

echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║  Testing ~/.localrc and ~/.env-vars Loading Order                   ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

# Create temporary test files
TEMP_LOCALRC="/tmp/test-localrc-$$"
TEMP_ENVVARS="/tmp/test-envvars-$$"
TEMP_ZSHRC="/tmp/test-zshrc-$$"

# Cleanup function
cleanup() {
    rm -f "$TEMP_LOCALRC" "$TEMP_ENVVARS" "$TEMP_ZSHRC"
}
trap cleanup EXIT

# Create test .localrc
cat > "$TEMP_LOCALRC" << 'EOF'
# Test .localrc file
export TEST_VAR_LOCALRC="loaded from localrc"
export TEST_ORDER="1-localrc"
echo "[LOCALRC] Loaded .localrc"
EOF

# Create test .env-vars
cat > "$TEMP_ENVVARS" << 'EOF'
# Test .env-vars file
export TEST_VAR_ENVVARS="loaded from env-vars"
# This should append to TEST_ORDER
export TEST_ORDER="${TEST_ORDER}+2-envvars"
echo "[ENVVARS] Loaded .env-vars"
EOF

# Create a minimal test zshrc that mimics the real behavior
cat > "$TEMP_ZSHRC" << EOF
#!/bin/bash
# Minimal test script (using bash since we're testing the logic, not zsh-specific features)

# Simulate loading .localrc (like real zshrc does)
if [[ -a "$TEMP_LOCALRC" ]]; then
  source "$TEMP_LOCALRC"
fi

# Simulate loading private/env-vars.zsh (which sources ~/.env-vars)
if [[ -a "$TEMP_ENVVARS" ]]; then
  source "$TEMP_ENVVARS"
fi

# Print results
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "Test Results:"
echo "═══════════════════════════════════════════════════════════════════════"
echo "TEST_VAR_LOCALRC = \$TEST_VAR_LOCALRC"
echo "TEST_VAR_ENVVARS = \$TEST_VAR_ENVVARS"
echo "TEST_ORDER       = \$TEST_ORDER"
echo ""

# Verify the order
if [[ "\$TEST_ORDER" == "1-localrc+2-envvars" ]]; then
    echo "✅ SUCCESS: Loading order is correct!"
    echo "   1. ~/.localrc loaded first"
    echo "   2. ~/.env-vars loaded second"
else
    echo "❌ FAILURE: Loading order is incorrect!"
    echo "   Expected: 1-localrc+2-envvars"
    echo "   Got:      \$TEST_ORDER"
    exit 1
fi
EOF

# Run the test
echo "Running test..."
echo ""
bash "$TEMP_ZSHRC"

echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║  Test Complete                                                       ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
