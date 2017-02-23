note
	description: "Summary description for {STUDENT_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST
		redefine setup end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_violation_case (agent t4)
		end

feature -- setup
	bag: MY_BAG[STRING]
		attribute
			create Result.make_empty end

	setup
			-- this runs before every test
		do
			bag := <<["nuts", 2], ["bolts", 5]>>
		end

feature --tests
	t1: BOOLEAN
		local
			b1: MY_BAG[STRING]
			b2: MY_BAG[STRING]
		do
			comment("t1: Test extend with duplicate key")
			b1 := <<["nuts", 4], ["bolts", 5]>>
			b2 := <<["nuts", 4], ["bolts", 6]>>
			b1.extend ("bolts", 1)
			Result := b1 |=| b2
		end

	t2: BOOLEAN
		local
			bag1: MY_BAG[STRING]
			bag2: MY_BAG[STRING]
		do
			comment("t2: Testing non-proper subset")
			bag1 := <<["one", 1], ["two", 2], ["three", 3]>>
			bag2 := <<["one", 2], ["two", 2], ["three", 3]>>
			Result := bag1  |<: bag1
			check
				Result
			end

			Result := bag1 |<: bag2 and not (bag2 |<: bag1)
			check
				Result
			end
		end

	t3: BOOLEAN
		do
			comment("t3: Testing is_non_negative")
			Result := bag.is_nonnegative (<<["one", 1], ["two", 2], ["three", 3], ["negative", -1]>>) = false
			check
				Result
			end
			Result := bag.is_nonnegative (<<["one", 1], ["negative", -1], ["two", 2], ["three", 3]>>) = false
			check
				Result
			end
			Result := bag.is_nonnegative (<<["negative", -1], ["one", 1], ["two", 2], ["three", 3]>>) = false
			check
				Result
			end
			Result := bag.is_nonnegative (<<["one", 1], ["two", 2], ["three", 3]>>)
			check
				Result
			end
			Result := bag.is_nonnegative (<<["one", 0], ["two", 0], ["three", 0]>>)
			check
				Result
			end
		end

	t4
		local
			bag1: MY_BAG[STRING]
		do
			comment("t4: testing items with 0 occurrences")
			bag1 := <<["one", 0], ["two", 0], ["three", 0], ["four", 4]>>
		end

end
