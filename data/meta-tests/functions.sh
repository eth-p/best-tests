test:fn_fail() {
	fail
}

test:fn_fail_with_reason() {
	fail "|%s|" "REASON"
}

test:fn_deferred_fail() {
	deferred_fail "|%s|" "REASON" 
	deferred_fail "Second"
}

test:fn_skip() {
	skip
}

test:fn_skip_with_reason() {
	skip "|%s|" "REASON"
}

test:fn_assert_good() {
	assert true
}

test:fn_assert_bad() {
	assert false
}

test:fn_expect_good() {
	expect true
}

test:fn_expect_bad() {
	expect false
}

test:fn_expect_bad2() {
	expect false
	expect false
}

test:fn_array_contains_good() {
	assert array_contains "1" in "1" "2" "3"
	assert array_contains "1" in 3 2 1
}

test:fn_array_contains_bad() {
	assert array_contains "0" in "1" "2" "3"
}

test:fn_array_contains_bad2() {
	assert array_contains "0" in
}

# ----------------------------------------------------------------------------------------------------------------------
# Tests: expect*
# ----------------------------------------------------------------------------------------------------------------------

test:fn_expect_equal_good() {
	expect_equal 1 1
}

test:fn_expect_equal_bad() {
	expect_equal 1 2
}

test:fn_expect_equal_bad2() {
	expect_equal 1 2 -- "%s = %s"
}

test:fn_expect_not_equal_good() {
	expect_not_equal 1 2
}

test:fn_expect_not_equal_bad() {
	expect_not_equal 1 1
}

test:fn_expect_not_equal_bad2() {
	expect_not_equal 1 1 -- "%s != %s"
}

test:fn_expect_greater_good() {
	expect_greater 2 1
}

test:fn_expect_greater_bad() {
	expect_greater 1 2
}

test:fn_expect_greater_bad2() {
	expect_greater 2 2
}

test:fn_expect_greater_bad3() {
	expect_greater 1 1 -- "%s > %s"
}

test:fn_expect_greater_or_equal_good() {
	expect_greater_or_equal 2 1
	expect_greater_or_equal 2 2
}

test:fn_expect_greater_or_equal_bad() {
	expect_greater_or_equal 2 3
}

test:fn_expect_greater_or_equal_bad2() {
	expect_greater_or_equal 1 2 -- "%s >= %s"
}

test:fn_expect_less_good() {
	expect_less 1 2
}

test:fn_expect_less_bad() {
	expect_less 2 1
}

test:fn_expect_less_bad2() {
	expect_less 2 2
}

test:fn_expect_less_bad3() {
	expect_less 1 1 -- "%s < %s"
}

test:fn_expect_less_or_equal_good() {
	expect_less_or_equal 1 2
	expect_less_or_equal 2 2
}

test:fn_expect_less_or_equal_bad() {
	expect_less_or_equal 3 2
}

test:fn_expect_less_or_equal_bad2() {
	expect_less_or_equal 2 1 -- "%s <= %s"
}

# ----------------------------------------------------------------------------------------------------------------------
# Tests: assert*
# ----------------------------------------------------------------------------------------------------------------------

test:fn_assert_equal_good() {
	assert_equal 1 1
}

test:fn_assert_equal_bad() {
	assert_equal 1 2
}

test:fn_assert_equal_bad2() {
	assert_equal 1 2 -- "%s = %s"
}

test:fn_assert_not_equal_good() {
	assert_not_equal 1 2
}

test:fn_assert_not_equal_bad() {
	assert_not_equal 1 1
}

test:fn_assert_not_equal_bad2() {
	assert_not_equal 1 1 -- "%s != %s"
}

test:fn_assert_greater_good() {
	assert_greater 2 1
}

test:fn_assert_greater_bad() {
	assert_greater 1 2
}

test:fn_assert_greater_bad2() {
	assert_greater 2 2
}

test:fn_assert_greater_bad3() {
	assert_greater 1 1 -- "%s > %s"
}

test:fn_assert_greater_or_equal_good() {
	assert_greater_or_equal 2 1
	assert_greater_or_equal 2 2
}

test:fn_assert_greater_or_equal_bad() {
	assert_greater_or_equal 2 3
}

test:fn_assert_greater_or_equal_bad2() {
	assert_greater_or_equal 1 2 -- "%s >= %s"
}

test:fn_assert_less_good() {
	assert_less 1 2
}

test:fn_assert_less_bad() {
	assert_less 2 1
}

test:fn_assert_less_bad2() {
	assert_less 2 2
}

test:fn_assert_less_bad3() {
	assert_less 1 1 -- "%s < %s"
}

test:fn_assert_less_or_equal_good() {
	assert_less_or_equal 1 2
	assert_less_or_equal 2 2
}

test:fn_assert_less_or_equal_bad() {
	assert_less_or_equal 3 2
}

test:fn_assert_less_or_equal_bad2() {
	assert_less_or_equal 2 1 -- "%s <= %s"
}
