def one := 1

@[implemented_by one]
def two := 2

-- in the kernel, two is still two
theorem two_is_two : two = 2 := rfl

-- but we told the compiler / interpreter that it can use `one` to execute `two`
#eval two -- prints `1`

