#tclsh 8.6

set ::objects { \
    {arrayList {} {symbol s1} {float f1 symbol s2} {float f1 float f2 symbol s3} {float f1 float f2} {float f1}} \
    {arrayHash {float arg1} {symbol arg1 float arg2}} \
    {arrayTest {float arg1 symbol arg2}} \
    {macarena {float arg1 symbol arg2} {float arg1 float arg2 symbol arg3}} \
}

proc get_object_name {s} {
   return [lindex $s 0]
}

proc get_overloads {object} {
   foreach external $::objects {
      if {[regexp $object $external]} {
         return [lrange $external 1 end]
      }
   }
}

proc get_string_up_to_index {s i} {
   return [string range $s 0 $i]
}

proc whitespaces_in_string {s} {
    set matches [regexp -inline -all {\s} $s]
    return [llength $matches]
}

#n is the number of the argument
proc get_input_argument {s n} {
    set matches [regexp -inline -all {\w+} $s]
    puts "matches =\n[join "\n---$matches" "\n---"]"
    return [lindex $matches $n]
}

set input "arrayHash 433"
set index 11
set input "arrayList 433 macarena"
set input "arrayList 433 12345678"
set index 16
set matches ""

#get the external the user is typing
set object [get_object_name $input]
    puts "ojbect = $object"
#get all the overloads for that external
set overloads [get_overloads $object]
    puts "overloads = $overloads"
#get the string from 0 to cursor
set prefix [get_string_up_to_index $input $index]
    puts "prefix = $prefix"
#get the nubmer of whitespaces in that so we know in which argument we are
set n_of_white_spaces [whitespaces_in_string $prefix]
   puts "n_of_white_spaces = $n_of_white_spaces"
#get the argument the user is typing
set input_arg [get_input_argument $input $n_of_white_spaces]
    puts "input_arg = $input_arg"

#test to see type
if { [string is double -strict $input_arg] } {
   set input_arg_type "float"
} else {
    set input_arg_type "symbol"
}
puts "input_arg_type = $input_arg_type"


#get all possible overloads
set possible_overloads ""

foreach overload $overloads {
   set n_of_args [llength $overload]
   if { ![expr {$n_of_white_spaces>$n_of_args/2}] } { ;#we divide by two because we have (type, name) pairs for each argument !
       puts "POSSIBLE overload = $overload"
       set i [expr {2*($n_of_white_spaces-1)}]
       set type_of_current_argument [lindex $overload $i]
       puts "---type of argument $n_of_white_spaces = $type_of_current_argument"
       if { $type_of_current_argument eq $input_arg_type } {
           lappend possible_overloads $overload
       }
   } else {
       puts "discarded overload = $overload"
   }
}

puts "FINAL LIST OF POSSIBLE OVERLOADS =\n$possible_overloads"


#puts "matches =\n[join $matches \n]"
