# ----------------------------------------------------------------------------------------------------------------------
# best | Copyright (C) 2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/best
# Issues:     https://github.com/eth-p/best/issues
# ----------------------------------------------------------------------------------------------------------------------

# A shortcut for checking if a test exits with a specific result.
#
# Arguments:
#
#     $1  [string] -- The expect test result.
#     $2  [string] -- The test suite name.
#     $3  [string] -- The test name.
#
__test_result_equals() {
	while porcelain_parse_result; do
		if [[ "$P_TEST" = "$2:$3" ]]; then
			[[ "$P_TEST_RESULT" = "$1" ]] || return 1
			return 0
		fi
	done < <(porcelain "$2" "$3")
	fail "Could not find test '%s' in suite '%s'." "$3" "$2"
}

# A shortcut for checking if a test exits with a specific result and messages.
#
# Arguments:
#
#     $1  [string] -- The expect test result.
#     $2  [string] -- The test suite name.
#     $3  [string] -- The test name.
#     ... [string] -- The failure reason(s).
#
__test_result_equals_with_message() {
	local expected="$1"
	local test_suite="$2"
	local test="$3"
	shift
	shift
	shift
	
	local message_count="$#"
	while porcelain_parse_result; do
		if [[ "$P_TEST" = "${test_suite}:${test}" ]]; then
			[[ "$P_TEST_RESULT" = "$expected" ]] || return 1
			
			# Make sure the number of messages match.
			local found_count="${#P_TEST_MESSAGES[@]}"
			if [[ "$message_count" -ne "$found_count" ]]; then
				deferred_fail "vvvvvvvv  Expected %s messages, but found %s instead." "$message_count" "$found_count"
				return 1
			fi
			
			# Make sure all the messages match.
			local failed=false
			local reason
			for reason in "${P_TEST_MESSAGES[@]}"; do
				if [[ "$1" != "*" && "$reason" != "$1" ]]; then
					deferred_fail "vvvvvvvv  Expected reason '%s', but found '%s'" "$1" "$reason"
					failed=true
				fi
				
				shift
			done
			
			if "$failed"; then
				return 1
			else
				return 0
			fi
		fi
	done < <(porcelain "$test_suite" "$test")
	fail "Could not find test '%s' in suite '%s'." "$test" "$test_suite"
}


# A shortcut for checking if a single test passed.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#
test_passed() {
	__test_result_equals "pass" "$@" || return $?
}

# A shortcut for checking if a single test passed with a specific reason.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#     ... [string] -- The result reason(s).
#
test_passed_with_reason() {
	__test_result_equals_with_message "pass" "$@" || return $?
}

# A shortcut for checking if a single test was skipped.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#
test_skipped() {
	__test_result_equals "skip" "$@" || return $?
}


# A shortcut for checking if a single test was skipped with a specific reason.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#     ... [string] -- The result reason(s).
#
test_skipped_with_reason() {
	__test_result_equals_with_message "skip" "$@" || return $?
}

# A shortcut for checking if a single test failed.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#
test_failed() {
	__test_result_equals "fail" "$@" || return $?
}

# A shortcut for checking if a single test failed with a specific reason.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     $2  [string] -- The test name.
#     ... [string] -- The result reason(s).
#
test_failed_with_reason() {
	__test_result_equals_with_message "fail" "$@" || return $?
}
