#!/usr/bin/env bash

DEBUG=false

_sum () {
        python3 -c "from functools import reduce; import sys; print(reduce(lambda x,y:float(x)+float(y), sys.argv[1:]));" $@
}

_n () {
        python3 -c "import sys; print(len(sys.argv[1:]))" $@
}


## Samples usage
##  _filter_values 12 3 4 5 6 7 8 89 2 5 ">"
##  _filter_values 1 2 3 4 5 6 7 8 5 "<="
##  _filter_values 1 2 3 4 5 6 7 8 5 "="
_filter_values ()  {
        # Copy passed arguments into a local array
        local values=("$@")
        [[ $DEBUG == true ]] && echo "values: ${values[@]}"

        local length=${#arr[@]}                # total length

        value=${values[-2]};
        operator="${values[-1]}"                # operator:: > < >=

        [[ $DEBUG == true ]] && echo "value: $value"
        [[ $DEBUG == true ]] && echo "opeartor: $operator"

        slice_length=$((length - 2)) ;
        value_array="${values[@]:0:${#values[@]}-2}"

        [[ $DEBUG == true ]] && echo "value_array: $value_array"

        # python3 -c "import sys; print(sys.argv[1:]); res=filter(lambda x: int(x) $operator int($value), sys.argv[1:]); print(list(res));" $value_array
        python3 -c """
import sys
res=filter(lambda x: float(x) $operator float($value), sys.argv[1:])
result=''
for x in list(res):
        result+='{} '.format(x)
print(result)
""" $value_array
}

_filter_lt () {
        _filter_values $@ "<"
}

_filter_lte () {
        _filter_values $@ "<="
}

_filter_gt () {
        _filter_values $@ ">"
}

_filter_gte () {
        _filter_values $@ ">="
}

_filter_eq () {
        _filter_values $@ "="
}

_median () {
        values=$@
        minimum_value=5;

        sum=$(_sum $values);
        n=$(_n $values);
        echo "$sum / $n" | bc
}


