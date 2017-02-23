note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR[G -> {STRING}]

inherit
	ITERATION_CURSOR[G]

create
	make

feature
	make (other: MY_BAG[G])
		do
			create target.make_from_array (other.domain)
		end

feature --access
	target: ARRAY[G]
	index: INTEGER

feature
	item: G
		do
			Result := target[index]
		end

	start
		do
			index := 1
		end

	after: BOOLEAN
		do
			Result := index > target.count or target.count = 0
		end

	forth
		do
			index := index + 1
		end

end
