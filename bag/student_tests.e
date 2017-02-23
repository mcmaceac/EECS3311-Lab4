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
			comment("Test extend with duplicate key")
			b1 := <<["nuts", 4], ["bolts", 5]>>
			b2 := <<["nuts", 4], ["bolts", 6]>>
			b1.extend ("bolts", 1)
			Result := b1 |=| b2
		end

	t2: BOOLEAN
		do
			comment("Testing non-proper subset")
			Result := bag  |<: bag
			check
				Result
			end
		end

end
