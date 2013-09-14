defmodule ScalaTest do
  use ExUnit.Case
	import Scala

	test "all in one" do
		s = for do
			f <- [1,2,3]
			g <- [1,2,3]
			if (rem (f + g), 2) == 0
			yield {f, g*2}
		end

		assert [{1, 2}, {1, 6}, {2, 4}, {3, 2}, {3, 6}] == Enum.to_list s
	end
end
