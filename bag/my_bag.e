note
	description: "Summary description for {MY_BAG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG [G -> {STRING}]
inherit
	ADT_BAG [G]
	DEBUG_OUTPUT

create
	make_empty,
	make_from_tupled_array

convert
	make_from_tupled_array ({attached ARRAY [attached TUPLE [G, INTEGER]]})

feature
	make_empty
		do
			create table.make (0)
		end

	make_from_tupled_array (a_array: ARRAY [TUPLE [x: G; y: INTEGER]])
		local
			i: INTEGER
		do
			create table.make (0)
			from
				i := 1
			until
				i > a_array.count
			loop
				table.extend (a_array.at (i).x, a_array.at (i).y)
				i := i + 1
			end
		end

feature
	table: HASH_TABLE [G, INTEGER]

feature --queries

	bag_equal alias "|=|"(other: like Current): BOOLEAN
		do
			Result := true
		end

	count: INTEGER
		do
			Result := table.count
		end

	domain: ARRAY [G]
		--puts the keys in a sorted list and then returns the array
		--representation of the sorted keys
		local
			i: INTEGER
			sorted: SORTED_TWO_WAY_LIST [G]
		do
			create sorted.make
			create Result.make_empty
			Result.compare_objects

			from
				table.start
			until
				table.after
			loop
				sorted.extend (table.item_for_iteration)
				table.forth
			end

			from
				i := 1
				sorted.start
			until
				sorted.after
			loop
				Result.force (sorted.item_for_iteration, i)
				sorted.forth
				i := i + 1
			end
		end

	debug_output: STRING
		do
			create Result.make_from_string ("{")
			from
				table.start
			until
				table.after
			loop
				Result.append ("[")
				Result.append (table.item_for_iteration)
				Result.append (",")
				Result.append (table.key_for_iteration.out)
				Result.append ("],")
				table.forth
			end
			Result.append ("}")
		end

	new_cursor: ITERATION_CURSOR [G]
		do
			Result := table.new_cursor
		end

	occurrences alias "[]" (key: G): INTEGER
		do
			Result := 0
			from
				table.start
			until
				table.after
			loop
				if table.item_for_iteration.as_string_8 ~ key then
					Result := Result + table.key_for_iteration
				end
				table.forth
			end
		end

	is_nonnegative (a_array: ARRAY [TUPLE [G, INTEGER]]): BOOLEAN
		do
			Result := true
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
		do
			Result := true
			from
				table.start
			until
				table.after
			loop
				if not other.has(table.item_for_iteration) then
					Result := false
				end
				table.forth
			end
		end

feature --commands
	add_all (other: like Current)
		do

		end

	extend (a_key: G; a_quantity: INTEGER)
		do
			if has(a_key) then

			else
				table.extend (a_key, a_quantity)
			end
		end

	remove (a_key: G; a_quantity: INTEGER)
		do

		end

	remove_all (other: like Current)
		do

		end

end