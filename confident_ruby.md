There are implicit and explicit type conversions.  When crafting methods if you
need to type check and be confident you are getting the type you are expecting
to use then implement: ``to_str``, ``to_int``, or ``to_a``.

Using the built in conversion functions: Array(), Integer(), etc. will do
everything possible to convert an object into what you want, it will also supply
stricter qualifications than the tradition .to_s methods.  See page 63 for
examples on how to use them. 


