setup() {
	source "${TEST_HELPERS}/porcelain.sh"
}

test:porcelain_list() {
	description "Checks that --porcelain --list mode prints a parsable list of tests."

	{
		assert porcelain_parse_list
		expect_equal "$P_TEST" "ptest_single:test:some_test"
		expect_equal "$P_TEST_NAME" "test:some_test"
		expect_equal "$P_TEST_SUITE" "ptest_single"
		expect_equal "$P_TEST_DESCRIPTION" "|DESCRIPTION HERE|"

		assert porcelain_parse_list_complete
	} < <(porcelain ptest_single --list)
}

test:porcelain_list_order() {
	description "Checks that --porcelain --list mode prints tests in order of appearance."

	{
		assert porcelain_parse_list
		expect_equal "$P_TEST" "ptest_order:test:0_test_first"
		expect_equal "$P_TEST_NAME" "test:0_test_first"
		expect_equal "$P_TEST_SUITE" "ptest_order"
		expect_equal "$P_TEST_DESCRIPTION" "Second"

		assert porcelain_parse_list
		expect_equal "$P_TEST" "ptest_order:test:1_test_second"
		expect_equal "$P_TEST_NAME" "test:1_test_second"
		expect_equal "$P_TEST_SUITE" "ptest_order"
		expect_equal "$P_TEST_DESCRIPTION" "First"

		porcelain_parse_list_complete
	} < <(porcelain ptest_order --list)
}

test:porcelain_order() {
	description "Checks that --porcelain mode prints test results in lexical order."
	{
		porcelain_parse_result
		expect_equal "$P_TEST" "ptest_order:0_test_first"
		
		porcelain_parse_result
		expect_equal "$P_TEST" "ptest_order:1_test_second"

		assert porcelain_parse_result_complete
	} < <(porcelain ptest_order)
}

test:porcelain_order_async() {
	description "Checks that --porcelain mode prints test results in lexical order with multiple threads."
	{
		porcelain_parse_result
		expect_equal "$P_TEST" "ptest_order:0_test_first"
		
		porcelain_parse_result
		expect_equal "$P_TEST" "ptest_order:1_test_second"

		assert porcelain_parse_result_complete
	} < <(porcelain_mt ptest_order)
}

test:porcelain_results_info() {
	description "Checks that --porcelain mode prints a parsable list of test results."
	
	{
		assert porcelain_parse_result
		expect_equal "$P_TEST" "ptest_single:some_test"
		expect_equal "$P_TEST_RESULT" "pass"
		expect_equal "$P_TEST_SUITE" "ptest_single"
		expect [ -n "$P_TEST_DURATION" ]
		
		assert porcelain_parse_result_complete
	} < <(porcelain ptest_single)
}

test:porcelain_results() {
	description "Checks that --porcelain mode prints the actual test results."
	{
		while porcelain_parse_result; do
			case "$P_TEST" in
				"ptest_results:pass") expect_equal "$P_TEST_RESULT" "pass" -- "$P_TEST to pass." ;;
				"ptest_results:skip") expect_equal "$P_TEST_RESULT" "skip" -- "$P_TEST to be skipped." ;;
				"ptest_results:fail") expect_equal "$P_TEST_RESULT" "fail" -- "$P_TEST to fail." ;;
				"ptest_results:fail_with_message") {
					expect_equal "$P_TEST_RESULT" "fail" -- "$P_TEST to fail"
					expect_equal "${#P_TEST_MESSAGES[@]}" 2 -- "$P_TEST to have two messages"
					expect_equal "Always deferred." "${P_TEST_MESSAGES[0]}"
					expect_equal "Always failed." "${P_TEST_MESSAGES[1]}" 
				} ;;
				*) fail "Unknown test: $P_TEST" ;;
			esac
		done
	} < <(porcelain ptest_results)
}
