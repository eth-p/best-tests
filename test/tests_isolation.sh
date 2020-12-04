test:000_global_set() {
	description "Sets a global variable."
	GLOBAL=true
}

test:001_global_get() {
	description "Gets a global variable."
	assert_equal "${GLOBAL:-false}" false
}
