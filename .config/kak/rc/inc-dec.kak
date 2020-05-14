define-command -params 2 inc-dec-modify-numbers %{
	evaluate-commands -save-regs 'oc|/' %{
		# "o" stores the operator we want to use ('+' or '-')
		set-register o %arg{1}
		# "c" stores the count we want to use (in decimal)
		set-register c %sh{ if [ $2 -eq 0 ]; then echo 1; else echo $2; fi }

		try %{
			# Try to find something that looks like a hex literal.
			execute-keys s [+-]?0[Xx][0-9A-Fa-f]+ <ret>
			# We've found one, so make sure it's upper-case.
			execute-keys ~
			# Wrap the selection in rectangular brackets so we can remember it.
			execute-keys i[<esc> a]<esc>
			# Match it again, pulling out the sign and digits as groups.
			execute-keys s ([+-]?)0X([0-9A-F]+) <ret>
			# Replace the selection with the bc expression we want to evaluate.
			execute-keys <a-i>r c\
				c=<c-r>c ';' \
				obase=16 ';' \
				ibase=16 ';' \
				<c-r>1<c-r>2 <c-r>o c \
				<esc>
			# Evaluate the expression with bc
			execute-keys <a-i>r |bc<ret>
			# Put the 0x prefix back between the sign and the digits.
			execute-keys <a-i>r s[0-9A-F]+<ret> i0x<esc>

		} catch %{
			# Try to find something that looks like an octal literal.
			execute-keys s ([+-]?)0[Oo]([0-7]+) <ret>
			# Wrap the selection in rectangular brackets so we can remember it.
			execute-keys i[<esc> a]<esc>
			# Replace the selection with the bc expression we want to evaluate.
			execute-keys <a-i>r c\
				c=<c-r>c ';' \
				obase=8 ';' \
				ibase=8 ';' \
				<c-r>1<c-r>2 <c-r>o c \
				<esc>
			# Evaluate the expression with bc
			execute-keys <a-i>r |bc<ret>
			# Put the 0o prefix back between the sign and the digits.
			execute-keys <a-i>r s[0-7]+<ret> i0o<esc>

		} catch %{
			# Try to find something that looks like an octal literal.
			# A 0-prefixed literal has to be followed by a non-digit to be
			# recognised, otherwise it's a 0-prefixed decimal.
			execute-keys s ([+-]?)0([0-7]+)(?![0-9]) <ret>
			# Wrap the selection in rectangular brackets so we can remember it.
			execute-keys i[<esc> a]<esc>
			# Replace the selection with the bc expression we want to evaluate.
			execute-keys <a-i>r c\
				c=<c-r>c ';' \
				obase=8 ';' \
				ibase=8 ';' \
				<c-r>1<c-r>2 <c-r>o c \
				<esc>
			# Evaluate the expression with bc
			execute-keys <a-i>r |bc<ret>
			# Put the 0 prefix back between the sign and the digits.
			execute-keys <a-i>r s[0-7]+<ret> i0<esc>

		} catch %{
			# Try to find something that looks like a decimal literal.
			execute-keys s ([+-]?[0-9]+) <ret>
			# Wrap the selection in rectangular brackets so we can remember it.
			execute-keys i[<esc> a]<esc>
			# Replace the selection with the bc expression we want to evaluate.
			execute-keys <a-i>r c\
				<c-r>1 <c-r>o <c-r>c \
				<esc>
			# Evaluate the expression with bc
			execute-keys <a-i>r |bc<ret>
		}

		# Remove the rectangular brackets around the selection.
		execute-keys <a-a>r i<del><esc> a<backspace><esc>
	}
}

