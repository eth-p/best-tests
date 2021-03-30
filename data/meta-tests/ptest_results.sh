test:pass() {
	assert true
}

test:skip() {
	skip "Always skipped."
}

test:fail() {
	fail
}

test:fail_with_message() {
	deferred_fail "Always deferred."
	fail "Always failed."
}
