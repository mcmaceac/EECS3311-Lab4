note
	description: "Summary description for {INSTRUCTOR_TEST1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INSTRUCTOR_TEST1

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
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
		end

feature -- setup
	bag1: MY_BAG[STRING]
		attribute
			create Result.make_empty end

	bag2: MY_BAG[STRING]
		attribute create Result.make_empty end

	b1, b2, b3: BOOLEAN

	setup
			-- this runs before every test
		do
			bag1 := <<["nuts", 2], ["bolts", 5]>>
			bag2 := <<["nuts", 2], ["bolts", 6], ["hammers", 5]>>
		end

feature -- tests


	t1: BOOLEAN
		do
			comment("t1:test bag has, across, subset")
			Result := bag1.has ("nuts") and then bag1["nuts"] = 2
			check Result end

			sub_comment("t1:bag1 = <<[nuts, 2], [bolts, 5]>>")
			sub_comment("t1:bag2 = <<[nuts, 2], [bolts, 6], [hammers, 5]>>")

			sub_comment("check: across bag1 count >= 2")
			Result := across bag1 as it all
				it.item ~ "nuts" or it.item ~ "bolts"
				and then bag1["nuts"] >= 2
				and then bag1[it.item] >= 2
			end
			check Result end

			sub_comment("t1:check: across bag2 exists hammers")
			Result := across bag2 as it some
				it.item ~ "hammers"
			end
			check Result end

			sub_comment("t1:check ag subset: bag1 |<: bag2 and not bag2 |<: bag1")
			Result := bag1 |<: bag2 and not (bag2 |<: bag1)
			check Result  end
		end

	t2: BOOLEAN
		do
			comment("t2:test counting quantifier")
			sub_comment("t2:(#[g,i] in bag2 : i >= 5) = 2")
			Result :=
			  bag2.number_of (agent (g: STRING; i:INTEGER): BOOLEAN do Result := i >= 5 end)
			   = 2

		end

	t3: BOOLEAN
		local
			sorted_domain: ARRAY[STRING]
		do
			comment("t3:test sorted domain")
			sorted_domain := <<"bolts", "hammers", "nuts">>
			sorted_domain.compare_objects
			Result := bag2.domain ~ sorted_domain
			check Result end
		end

	t4: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t4:extend bag, then check is_equal, count and total")
			create bag.make_empty
			Result := bag.count = 0 and not bag.has("nuts")
			check Result end
			bag.extend ("nuts", 2)
			Result := bag.has ("nuts") and then bag.occurrences ("nuts") =2
			check Result end
			bag.extend ("hammers", 5)
			bag.extend ("bolts", 6)
			Result := bag |=| bag2
			check Result end
			bag.extend ("nails", 13)
			Result := not (bag |=| bag2) and bag.count = 4 and bag.total=26
			sub_comment("")
		end

	t5: BOOLEAN
		local
			bag: MY_BAG[STRING]
			bag3: like bag2
			bag4: MY_BAG[STRING]
		do
			comment("t5:test add_all, remove all, remove")
			bag := <<["nuts", 4], ["bolts", 11], ["hammers", 5]>>
			bag3 := <<["nuts", 2], ["bolts", 6], ["hammers", 5]>>
			-- add_all
			bag3.add_all (bag1)
			Result := bag3 |=| bag
			check Result end
			-- remove_all
			bag3.remove_all (bag1)
			Result := bag3 |=| bag2 and bag3.total = 13
			check Result end
			--remove
			bag4 := <<["nuts", 2], ["bolts", 6]>>
			bag3.remove ("hammers", 5)
			Result := bag3 |=| bag4
		end

	t6: BOOLEAN
		local
			bag: MY_BAG [STRING]
		do
			comment ("t6:repeated elements in contruction")
			bag := <<["foo",3], ["bar",3], ["foo",2], ["bar",0]>>
			Result := bag ["foo"] = 5
			check Result end
			Result := bag ["bar"] = 3
			check Result end
			Result := bag ["baz"] = 0
		end

end
