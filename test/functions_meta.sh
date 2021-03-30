setup() {
	source "${TEST_HELPERS}/porcelain.sh"
}

test:quotes() {
	description "Tests parsing of the 'description' meta-function."

	{
		while porcelain_parse_list; do
			expect_equal "$P_TEST_DESCRIPTION" "This is the description."
		done
	} < <(porcelain descriptions --list)
}
