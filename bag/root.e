note
	description: "es-template application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization
	adt_bag: detachable ADT_BAG[STRING]
	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
