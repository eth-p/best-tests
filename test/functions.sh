setup() {
	source "${TEST_HELPERS}/porcelain.sh"
	source "${TEST_HELPERS}/test_results.sh"
}

test:fail() {
	description "Checks that the 'fail' function works."
	expect test_failed functions fn_fail
	expect test_failed_with_reason functions fn_fail_with_reason "|REASON|"
}

test:deferred_fail() {
	description "Checks that the 'deferred_fail' function works."
	expect test_failed_with_reason functions fn_deferred_fail \
		"|REASON|" "Second"
}

test:skip() {
	description "Checks that the 'skip' function works."
	expect test_skipped functions fn_skip
	expect test_skipped_with_reason functions fn_skip_with_reason "|REASON|"
}

test:assert() {
	description "Checks that the 'assert' function works."
	expect test_passed functions fn_assert_good
	expect test_failed functions fn_assert_bad
}

test:assert_equal() {
	description "Checks that the 'assert_equal' function works."
	assert test_passed functions fn_assert_equal_good
	assert test_failed functions fn_assert_equal_bad
	assert test_failed_with_reason functions fn_assert_equal_bad2 \
		"Expected 1 = 2"
}

test:assert_not_equal() {
	description "Checks that the 'assert_not_equal' function works."
	assert test_passed functions fn_assert_not_equal_good
	assert test_failed functions fn_assert_not_equal_bad
	assert test_failed_with_reason functions fn_assert_not_equal_bad2 \
		"Expected 1 != 1"
}

test:assert_greater() {
	description "Checks that the 'assert_greater' function works."
	assert test_passed functions fn_assert_greater_good
	assert test_failed functions fn_assert_greater_bad
	assert test_failed functions fn_assert_greater_bad2
	assert test_failed_with_reason functions fn_assert_greater_bad3 \
		"Expected 1 > 1"
}

test:assert_greater_or_equal() {
	description "Checks that the 'assert_greater_or_equal' function works."
	assert test_passed functions fn_assert_greater_or_equal_good
	assert test_failed functions fn_assert_greater_or_equal_bad
	assert test_failed_with_reason functions fn_assert_greater_or_equal_bad2 \
		"Expected 1 >= 2"
}

test:assert_less() {
	description "Checks that the 'assert_less' function works."
	assert test_passed functions fn_assert_less_good
	assert test_failed functions fn_assert_less_bad
	assert test_failed functions fn_assert_less_bad2
	assert test_failed_with_reason functions fn_assert_less_bad3 \
		"Expected 1 < 1"
}

test:assert_less_or_equal() {
	description "Checks that the 'assert_less_or_equal' function works."
	assert test_passed functions fn_assert_less_or_equal_good
	assert test_failed functions fn_assert_less_or_equal_bad
	assert test_failed_with_reason functions fn_assert_less_or_equal_bad2 \
		"Expected 2 <= 1"
}

test:expect() {
	description "Checks that the 'expect' function works."
	expect test_passed functions fn_expect_good
	expect test_failed functions fn_expect_bad
	expect test_failed_with_reason functions fn_expect_bad2 \
		"*" "*"
}

test:expect_equal() {
	description "Checks that the 'expect_equal' function works."
	expect test_passed functions fn_expect_equal_good
	expect test_failed functions fn_expect_equal_bad
	expect test_failed_with_reason functions fn_expect_equal_bad2 \
		"Expected 1 = 2"
}

test:expect_not_equal() {
	description "Checks that the 'expect_not_equal' function works."
	expect test_passed functions fn_expect_not_equal_good
	expect test_failed functions fn_expect_not_equal_bad
	expect test_failed_with_reason functions fn_expect_not_equal_bad2 \
		"Expected 1 != 1"
}

test:expect_greater() {
	description "Checks that the 'expect_greater' function works."
	expect test_passed functions fn_expect_greater_good
	expect test_failed functions fn_expect_greater_bad
	expect test_failed functions fn_expect_greater_bad2
	expect test_failed_with_reason functions fn_expect_greater_bad3 \
		"Expected 1 > 1"
}

test:expect_greater_or_equal() {
	description "Checks that the 'expect_greater_or_equal' function works."
	expect test_passed functions fn_expect_greater_or_equal_good
	expect test_failed functions fn_expect_greater_or_equal_bad
	expect test_failed_with_reason functions fn_expect_greater_or_equal_bad2 \
		"Expected 1 >= 2"
}

test:expect_less() {
	description "Checks that the 'expect_less' function works."
	expect test_passed functions fn_expect_less_good
	expect test_failed functions fn_expect_less_bad
	expect test_failed functions fn_expect_less_bad2
	expect test_failed_with_reason functions fn_expect_less_bad3 \
		"Expected 1 < 1"
}

test:expect_less_or_equal() {
	description "Checks that the 'expect_less_or_equal' function works."
	expect test_passed functions fn_expect_less_or_equal_good
	expect test_failed functions fn_expect_less_or_equal_bad
	expect test_failed_with_reason functions fn_expect_less_or_equal_bad2 \
		"Expected 2 <= 1"
}

test:array_contains() {
	description "Checks that the 'array_contains' function works."
	expect test_passed functions fn_array_contains_good
	expect test_failed functions fn_array_contains_bad
	expect test_failed functions fn_array_contains_bad2
}
