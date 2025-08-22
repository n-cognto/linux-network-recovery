#!/bin/bash

test_interface_validation() {
    source ../scripts/restore-nm.sh

    # Test invalid interface
    if validate_interface "invalid0"; then
        echo "FAIL: Invalid interface was accepted"
        return 1
    fi

    # Test valid interface (assuming eth0 exists)
    if ! validate_interface "eth0"; then
        echo "FAIL: Valid interface was rejected"
        return 1
    fi

    echo "PASS: Interface validation tests"
    return 0
}

test_wifi_functions() {
    source ../scripts/restore-nm.sh

    # Test wifi scanning
    if ! scan_wifi_networks "wlan0"; then
        echo "FAIL: WiFi scanning failed"
        return 1
    fi

    echo "PASS: WiFi function tests"
    return 0
}

run_all_tests() {
    local failed=0

    test_interface_validation || ((failed++))
    test_wifi_functions || ((failed++))

    return $failed
}
