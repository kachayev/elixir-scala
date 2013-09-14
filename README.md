**Attention! Active development stage**

# Elixir-Scala

Elixir-Scala provides you fancy `for` macro to deal with nested map/filter calls (ported from Scala `for..yield` syntax).

## The Idea

Assume, you have a `Facebook` module that can find all users' friends (for concrete user). What if you need to build pairs of names of your friends and "friends of your friends" for all "friends-of-friends" whose age is equal or greater than 21?

In `Scala` you can write:

```scala
f-names = for {
    f <- Facebook.friends(:me)
    fof <- Facebook.friends(f)
    if fof.age > 21
} yield (f.name, fof.name)
```

Each line in `for {}` block is either `flatMap` description (`<var> <- <expr>`) or `filter` operaion (`if <expr>`). `yield` outside the block describes what do you want to get. `f-names` will be evaluated to `Scala` `Stream`.

Now you can do the same thing in `Elixir`:

```elixir
import Scala
require Facebook

f-names = for do
    f <- Facebook.friends :me
    fof <- Facebook.friend f
    if fof.age > 21
    yield {f.name, fof.name}
end
```

Meaning of each line is the same as in `Scala` code. `for` macro will be evaluated to `Elixir` `Stream` during compilation.

If you are falimiar with `Python` syntax, you can express the same block in `Python` as:

```python
def f-names():
    for f in Facebook.friends('me'):
        for fof in Facebook.friends(f):
            if fof.age > 21:
                yield f.name, fof.name
```

## Step by step

Lets explore `for...yield` mechanic step-by-step.

`for` macro accepts `do .. end` block as single argument. Each code line in given block (at least 2 is required) should be either:

1. `<var> <- <expr>`

Means `for` loop (nested to all previous lines). `<expr>` should be enumarable. You are able to use in `<expr>` all `<var>` that was declared on the right side of previous lines.

2. `if <expr>`

Skips step of appropriate `for` loop if `<expr>` is evaluated to `false`.

3. `yield <expr>`

Pushes `<expr>` into resulting stream. This line should go last one.

## Few examples:

1. Simplest loop

```elixir
iex(1)> s = for do
...(1)>    f <- [1,2,3,4,5]
...(1)>    yield f
...(1)> end
Stream.Lazy[enumerable: [1, 2, 3, 4, 5],
 fun: #Function<1.15041239 in Stream.flat_map/2>, acc: nil]
iex(2)> Enum.to_list s
[1, 2, 3, 4, 5]
```

2. Reject odd elements

```elixir
iex(1)> s = for do
...(1)>    f <- [1,2,3,4,5]
...(1)>    if (rem f, 2) == 0
...(1)>    yield f
...(1)> end
Stream.Lazy[enumerable: [1, 2, 3, 4, 5],
 fun: #Function<1.15041239 in Stream.flat_map/2>, acc: nil]
iex(2)> Enum.to_list s
[2, 4]
```

3. Yielding even squares

```elixir
iex(1)> s = for do
...(1)>    f <- [1,2,3,4,5]
...(1)>    if (rem f, 2) == 0
...(1)>    yield f*f
...(1)> end
Stream.Lazy[enumerable: [1, 2, 3, 4, 5],
 fun: #Function<1.15041239 in Stream.flat_map/2>, acc: nil]
iex(2)> Enum.to_list s
[4, 16]
```

4. Nested loops

```elixir
iex(1)> s = for do
...(1)>    f <- [1,2,3]
...(1)>    g <- Range[first: 1, last: (f+1)]
...(1)>    yield {f, g}
...(1)> end
Stream.Lazy[enumerable: [1, 2, 3],
 fun: #Function<1.15041239 in Stream.flat_map/2>, acc: nil]
iex(2)> Enum.to_list s
[{1, 1}, {1, 2}, {2, 1}, {2, 2}, {2, 3}, {3, 1}, {3, 2}, {3, 3}, {3, 4}]
```

**Note**, you can find more examples in unit tests.

## Plans/todos

* nested `yield` and/or `yield from`

* more unit tests

* exepctions with readable messages

# Contributors

* Alexey Kachayev <kachayev@gmail.com>

# License

TODO