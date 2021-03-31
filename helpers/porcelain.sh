# ----------------------------------------------------------------------------------------------------------------------
# best | Copyright (C) 2021 eth-p | MIT License
#
# Repository: https://github.com/eth-p/best
# Issues:     https://github.com/eth-p/best/issues
# ----------------------------------------------------------------------------------------------------------------------

# Executes a porcelain command.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     ... [string] -- Any other arguments to pass to BEST.
#   
porcelain() {
	"$BEST_EXECUTABLE" -j0 --suite="$1"  --porcelain "${@:2}"
	return $?
}

# Executes a multi-threaded porcelain command.
#
# Arguments:
#
#     $1  [string] -- The test suite name.
#     ... [string] -- Any other arguments to pass to BEST.
#   
porcelain_mt() {
	"$BEST_EXECUTABLE" -j8 --suite="$1" --porcelain "${@:2}"
	return $?
}

# Parses a porcelain entry for a `--list-suotes` output.
#
# Variables:
#
#     $P_TEST_SUITE       -- The test suite.
#     $P_TEST_SUITE_FILE  -- The test suite file.
porcelain_parse_list_suites() {
	local command
	local args

	P_TEST_SUITE=''
	P_TEST_SUITE_FILE=''

	if [[ -n "$__PARSED_NEXT_TEST" ]]; then
		P_TEST_SUITE="$__PARSED_NEXT_TEST"
		__PARSED_NEXT_TEST=''
	fi

	while read -r command args; do
		if [[ "$command" == "test_suite" ]]; then
			if [[ -z "$P_TEST_SUITE" ]]; then
				P_TEST_SUITE="$args"
				continue
			else
				# Accidentally parsed the upcoming test.
				# Save it for the next invocation.
				__PARSED_NEXT_TEST="$args"
				return 0
			fi
		fi

		case "$command" in
			"test_suite_file") assert [ -z "$P_TEST_SUITE_FILE" ] && P_TEST_SUITE_FILE="$args" ;;
		esac
	done

	# If there's nothing left to read and a test hasn't been found, return 1 to signal the end.
	[[ -n "$P_TEST_SUITE" ]] || return 1
}

# Calls `porcelain_parse_list_suites`, returning 1 if a test was successfully parsed.
porcelain_parse_list_suites_complete() {
	if porcelain_parse_list_suites "$@"; then
		return 1
	else
		return 0
	fi
}

# Parses a porcelain entry for a `--list` output.
#
# Variables:
#
#     $P_TEST             -- The fully qualified test ID.
#     $P_TEST_NAME        -- The test name.
#     $P_TEST_SUITE       -- The test suite.
#     $P_TEST_DESCRIPTION -- The test description.
porcelain_parse_list() {
	local command
	local args

	P_TEST=''
	P_TEST_NAME=''
	P_TEST_SUITE=''
	P_TEST_DESCRIPTION=''

	if [[ -n "$__PARSED_NEXT_TEST" ]]; then
		P_TEST="$__PARSED_NEXT_TEST"
		__PARSED_NEXT_TEST=''
	fi

	while read -r command args; do
		if [[ "$command" == "test" ]]; then
			if [[ -z "$P_TEST" ]]; then
				P_TEST="$args"
				continue
			else
				# Accidentally parsed the upcoming test.
				# Save it for the next invocation.
				__PARSED_NEXT_TEST="$args"
				return 0
			fi
		fi

		case "$command" in
			"test_name")        assert [ -z "$P_TEST_NAME" ]        && P_TEST_NAME="$args" ;;
			"test_suite")       assert [ -z "$P_TEST_SUITE" ]       && P_TEST_SUITE="$args" ;;
			"test_description") assert [ -z "$P_TEST_DESCRIPTION" ] && P_TEST_DESCRIPTION="$args" ;;
		esac
	done

	# If there's nothing left to read and a test hasn't been found, return 1 to signal the end.
	[[ -n "$P_TEST" ]] || return 1
}

# Calls `porcelain_parse_list`, returning 1 if a test was successfully parsed.
porcelain_parse_list_complete() {
	if porcelain_parse_list "$@"; then
		return 1
	else
		return 0
	fi
}

# Parses a porcelain entry for a test result output.
#
# Variables:
#
#     $P_TEST             -- The fully qualified test ID.
#     $P_TEST_NAME        -- The test name.
#     $P_TEST_SUITE       -- The test suite.
#     $P_TEST_DESCRIPTION -- The test description.
porcelain_parse_result() {
	local command
	local args
	local arg
	local arg_name
	local arg_value
	local message_count=0
	local next_message=0
	local buffered=''

	P_TEST=''
	P_TEST_RESULT=''
	P_TEST_DURATION=''
	P_TEST_MESSAGES=()

	while {
		# Read the next line, using the saved line if one exists.
		if [[ -n "$__PARSED_NEXT_TEST" ]]; then
			read -r command args <<< "$__PARSED_NEXT_TEST"
			__PARSED_NEXT_TEST=''
		else
			read -r command args || break
		fi
	}; do
		case "$command" in
			"suite") P_TEST_SUITE="$args" ;;

			"result") {
				if [[ -n "$P_TEST" ]]; then
					# Accidentally parsed the upcoming test.
					# Save it for the next invocation.
					__PARSED_NEXT_TEST="result $args"
					break
				fi
				
				# Parse the test name and test result.
				read -r P_TEST P_TEST_RESULT args <<< "$args"
	
				# Parse the test extra arguments.
				while read -r arg; do
					arg_name="$(cut -d'=' -f1 <<< "$arg")"
					arg_value="$(cut -d'=' -f2- <<< "$arg")"
	
					case "$arg_name" in
						"duration") P_TEST_DURATION="$arg_value" ;;
						"messages") message_count="$arg_value" ;;
					esac
				done < <(tr ' ' $'\n' <<< "$args")
			} ;;

			"message") {
				# Parse a result message.
				while read -r arg arg_value; do
					assert_equal "$next_message" "$arg" -- "id of received message to be %s, but found %s"
					((next_message++)) || true;
					P_TEST_MESSAGES+=("$arg_value")
				done <<< "$args"
			} ;;
		
			*) fail "Unknown porcelain result command: %s" "$command $args" ;;
		esac
	done

	# Ensure the message counts line up.
	assert_equal "$message_count" "${#P_TEST_MESSAGES[@]}" -- "expected %s messages, but received %s"

	# If there's nothing left to read and a test hasn't been found, return 1 to signal the end.
	[[ -n "$P_TEST" ]] || return 1
}

# Calls `porcelain_parse_results`, returning 1 if a test result was successfully parsed.
porcelain_parse_result_complete() {
	if porcelain_parse_results "$@"; then
		return 1
	else
		return 0
	fi
}
