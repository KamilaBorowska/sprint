global = if exports? then exports else this

global.sprint = (string, values...) ->
  arrayObjects = ['[object Array]', '[object Arguments]']

  # Detect values sent as array
  if toString.call(values[0]) in arrayObjects and values.length is 1
    values = values[0]

  format = ///
    %
    # Argument number
    (\d+[$])?
    # Flags (\x20 is space)
    ((?:[+\x20\-#0])*)
    # Width
    (\d*|[*])
    # Precision
    (?:[.](\d+|[*]))?
    # Length (ignored, for compatibility with C)
    (?:hh?|ll?|[Lzjtq]|I(?:32|64)?)?
    # Type
    ([diuDUfFeEgGxXoOscbB])
    |
    # Literal % mark
    %%
    ///g

  i = -1

  padString = (string, length, joiner, leftPad) ->
    string = "#{string}"
    if string.length > length
      string
    else if leftPad
      # new Array(2 + 1).join('-') creates '--' because it generates array of
      # undefined elements (when converted to strings they become nothing).
      # Every array value is joined using specified value. Note that joining
      # only happens inside strings, so you need to add 1 to array
      # constructor in order to get required number of characters.
      "#{string}#{new Array(length - string.length + 1).join joiner}"
    else
      "#{new Array(length - string.length + 1).join joiner}#{string}"

  string.replace format, (string, matches...) ->
    [argument, flags, length, precission, type] = matches

    toExponential = ->
      argument = (+argument).toExponential(precission)
      if special and '.' not in argument
        argument = argument.replace 'e', '.e'
      argument.toLowerCase().replace /\d+$/, (string) ->
        padString string, 3, 0

    return '%' if string is '%%'

    if length is '*'
      length = values[++i]
    if not length
      length = 0

    if precission is '*'
      precission = values[++i]
    if not precission
      precission = 6

    argument = values[parseInt(argument, 10) - 1 or ++i]

    argument = if argument? then "#{argument}" else ''

    special = '#' in flags

    argument = switch type
      when 'd', 'i', 'u', 'D', 'U'
        parseInt argument, 10
      when 'f', 'F'
        argument = (+argument).toFixed(precission).toLowerCase()
        # Dot shouldn't be added if argument is NaN or Infinity
        if special and '.' not in argument and not /^-?[a-z]+$/.test argument
          argument += '.'
        argument
      when 'e', 'E'
        toExponential()
      when 'g', 'G'
        if 0.0001 <= argument < Math.pow 10, precission
          # Precision doesn't include magical dot
          argument = "#{argument}".substr 0, +precission + 1
          if special
            argument.replace /[.]?$/, '.'
          else
            argument.replace /[.]$/, ''
        else
          toExponential().replace(/[.]?0+e/, 'e')
      when 'x', 'X'
        "#{if special then '0x' else ''}#{(+argument).toString 16}"
      when 'b', 'B'
        "#{if special then '0b' else ''}#{(+argument).toString 2}"
      when 'o', 'O'
        "#{if special then '0' else ''}#{(+argument).toString 8}"
      when 's'
        argument
      when 'c'
        String.fromCharCode argument

    argument = "#{argument}"

    if type is type.toUpperCase()
      argument = argument.toUpperCase()

    if argument[0] isnt '-'
      if '+' in flags
        argument = "+#{argument}"
      else if ' ' in flags
        argument = " #{argument}"

    leftPad = '-' in flags

    if '0' in flags
      alignCharacter = '0'

    padString argument, length, alignCharacter or ' ', leftPad
