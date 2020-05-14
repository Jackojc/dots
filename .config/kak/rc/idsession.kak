declare-option str-list idsession_adjectives \
	"kantian"   "kaput"     "kashmiri"  "katabolic" "katari"    \
	"kayoed"    "kadenced"  "kaesarian" "kaffeinic" "kalcific"  \
	"kalorific" "kancelled" "kanicular" "kanine"    "kanonized" \
	"kapable"   "kapillary" "karamel"   "kareful"   "kasual"    \


declare-option str-list idsession_nouns \
	"keeper"    "keg"       "kernel"  "kerosene" "ketchup" "kettle"  \
	"key"       "keyboard"  "keyhole" "keynote"  "kick"    "kickoff" \
	"kid"       "kilometer" "kimono"  "kingdom"  "kiosk"   "kit"     \
	"kitchen"   "kite"      "kitten"  "klaxon"   "knife"   "knight"  \
	"knockdown" "knot"      "konga"   "kinesis"  "kicker"  "koala"   \
	"kangaroo"  "kraken"


define-command idsession %{ evaluate-commands %sh{
	seed="${kak_session}"


	# Pick a random adjective.
	eval set -- "${kak_opt_idsession_adjectives}"

	n=$(( seed % $# + 1 ))
	name_session=$(eval "printf %s \${${n}}")


	# Pick a random noun.
	eval set -- "${kak_opt_idsession_nouns}"

	n=$((seed % $# + 1))
	name_session="${name_session}-"$(eval "printf %s \${${n}}")


	printf 'rename-session "%s"' $(printf %s "${name_session}" | sed 's/"/""/g')
} }

