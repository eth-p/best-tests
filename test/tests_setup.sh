setup() {
	SETUP=true
}

test:setup_function() {
	description "Checks that the setup function is run."
	assert_equal "${SETUP:-false}" true
}
