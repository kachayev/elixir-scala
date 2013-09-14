defmodule Scala do
	defmacro for(do: {:__block__, _, args}) do
		Enum.reduce (Enum.reverse args), nil, fn e, acc ->
			case e do
				{:<-, _, [name, right]} ->
					f = {:fn, [], [[do: {:->, [], [{[name], [], acc}]}]]}
					quote do
						Stream.flat_map(unquote(right), unquote(f))
					end
				{:yield,_,[block]} ->
					quote do: [unquote(block)]
        {:if,_,[clause]} ->
					quote do
						if unquote(clause) do
							unquote(acc)
						else
							[]
						end
					end
      end
    end
	end
end
