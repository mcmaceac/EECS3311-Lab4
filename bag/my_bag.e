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
				extend (a_array.at (i).x, a_array.at (i).y)
				i := i + 1
			end
		end

feature
	table: HASH_TABLE [INTEGER, G]

feature --queries

	bag_equal alias "|=|"(other: like Current): BOOLEAN
		do
			if domain /~ other.domain then
				Result := false
			else
				Result := across domain as it
				all
					table.at (it.item) = other.table.at (it.item)
				end
			end
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
				sorted.extend (table.key_for_iteration)
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
				Result.append (table.item_for_iteration.out)
				Result.append (",")
				Result.append (table.key_for_iteration)
				Result.append ("],")
				table.forth
			end
			Result.append ("}")
		end

	new_cursor: MY_BAG_ITERATION_CURSOR [G]
		do
			create Result.make (Current)
			Result.start
		end

	occurrences alias "[]" (key: G): INTEGER
		do
			Result := 0
			across domain as it
			loop
				if it.item ~ key then
					Result := Result + table.at (it.item)
				end
			end
		end

	is_nonnegative (a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
		do
			Result := across a_array as it
			all
				it.item.y >= 0
			end
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
		do
			Result := across domain as it
			all
				other.has (it.item) and
				occurrences (it.item) <= other.occurrences (it.item)
			end
		end

feature --commands
	add_all (other: like Current)
		do
			across other.domain as it
			loop
				extend (it.item, other.occurrences (it.item))
			end
		end

	extend (a_key: G; a_quantity: INTEGER)
		local
			temp_quant: INTEGER
		do
			if table.has (a_key) then
				--add a_quantity to the quantity associated with a_key
				temp_quant := table.at (a_key)
				table.remove (a_key)
				table.extend (a_quantity + temp_quant, a_key)
			else
				table.extend (a_quantity, a_key)
			end
		end

	remove (a_key: G; a_quantity: INTEGER)
		local
			temp_quant: INTEGER
		do
			temp_quant := table.at (a_key) - a_quantity
			if temp_quant = 0 then
				table.remove (a_key)
			else
				table.remove (a_key)
				table.extend (temp_quant, a_key)
			end
		end

	remove_all (other: like Current)
		do
			--remove the full quantity of each item in other from Current
			across other.domain as it
			loop
				remove (it.item, other.occurrences (it.item))
			end
		end

end
