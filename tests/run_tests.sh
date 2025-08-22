#!/bin/bash

# Main test runner
source ./test_network_utils.sh
source ./test_restore_nm.sh

echo "Running all tests..."
run_all_tests

exit ${FAILED_TESTS:-0}
