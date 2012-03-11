assert = require 'assert'
{sprint} = require '../lib/sprint'
i = 0

test = (args..., expect, message) ->
  try
    assert.equal sprint(args...), expect, message
  catch e
    console.log "Expected: #{expect}"
    console.log "Got:      #{sprint args...}"
    throw e
  console.log sprint '%3s: OK %s', ++i, message

test 'Message', 'Message',
     'sprintf() without arguments'
test '%$s', '%$s',
     'Invalid % values should be ignored by RegExp'
test '%s', '%s', '%s',
     '%s as value shouldn\'t be affected by sprintf()'
test '%s', '',
     'Not found values should be replaced with nothing.'
test '%%%%', '%%',
     '%% should be changed to %'
test '%s %s', ['a', 'b'], 'a b',
     'Array with sprint()'
test '%d', 404, '404',
     '%d format'
test '%2$d %1$d', 1, 2, '2 1',
     'Numbered parameters'
test '%3$d %s %2$d %s %s', 1, 2, 3, '3 1 2 2 3',
     'Numbered paramters with normal parameters'
test '%+d %+d', 1, -2, '+1 -2',
     '%+ modifier'
test '<% d> % d', 3, -4, '< 3> -4',
     '<% > modifier (space)'
test '%+ d % +d', 2, 3.14, '+2 +3',
     '<% > and %+ modifier at once.'
test '%i', 3.14, '3',
     '%i alias for %d format'
test '%5s', 'test', ' test',
     'Padding'
test '%-5s', 'test', 'test ',
     'Padding left'
test '%5d', 1234, ' 1234',
     'Padding numbers'
test '%05d', 1234, '01234',
     'Padding using "0" characters'
test '%-05d', 1234, '12340',
     'Padding left using "0" characters'
test '%*.*f', 6, 1, 12.34, '  12.3',
     'Star (*) operator in padding.'
test '%3s', 'test', 'test',
     'Length smaller than string'
test '%4s', 'test', 'test',
     'Length equal to string length'
test '%I64d', 42, '42',
     'Type argument should be ignored'
test '%f', 3.14, '3.140000',
     'Floats'
test '%.1f', 3.14, '3.1',
     'Accuracy'
test '%.1f', 3.16, '3.2',
     'Rounding'
test '%4.1f', 4.123, ' 4.1',
     'Width and accuracy together'
test '%#.0f %.0f', 4.1, 4.1, '4. 4',
     'Force floating dot'
test '%f %#.0f', -4.2, -4.3, '-4.200000 -4.',
     'Negative numbers'
test '%#.0f', Infinity, 'infinity',
     'Infinity constant'
test '%e %E', 1, 2.14, '1.000000e+000 2.140000E+000',
     'Exponential notation'
test '%.0e', 1000, '1e+003',
     '1000 > 1e+003'
test '%.3e', 3.1234, '3.123e+000',
     'Exponential accuracy'
test '%.0e %#.0e', 3.55, 3.55, '4e+000 4.e+000',
     'Exponential floating dot'
test '%#e', NaN, 'nan',
     'NaN constant in exponential notation.'
test '%g %g', 3, 3.14, '3 3.14',
     '%g format'
test '%g %.1g', 0.0000001, 10, '1e-007 1e+001',
     '%g modifier with exponential notation'
test '%g %g', NaN, Infinity, 'nan infinity',
     'NaN and Infinity with %g modifier.'
test '%#.1g %#g', 3.01, 3, '3. 3.',
     '%g with force floating dot'
test '%G %G', NaN, Infinity, 'NAN INFINITY',
     'Uppercase NaN and Infinity'
test '%G', 0.0000001, '1E-007',
     'Uppercase exponential notation'
test '%x %X', 0xA, 0xFF, 'a FF',
     'Hexadecimal numbers'
test '%#x %#X', 0xABCD, 0xDEF004242, '0xabcd 0XDEF004242',
     'Hexadecimal numbers with prefixes'
# Octal is intentionally used in those two tests
test '%o %O', 0755, 0312, '755 312',
     'Octal numbers'
test '%#o %#O', 0123, 012345671234567, '0123 012345671234567',
     'Octal numbers with prefixes'
# End of intentional octal numbers
test '%b %B', 255, 256, '11111111 100000000',
     'Binary numbers'
test '%#b %#B', 12, 18, '0b1100 0B10010',
     'Binary numbers with prefixes'
test '%c', 0x21, '!',
     '%c format'
test '%c', "\x00",
     '%c format without argument'
