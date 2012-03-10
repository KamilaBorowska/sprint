(function() {
  var global,
    __slice = Array.prototype.slice,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  global = typeof exports !== "undefined" && exports !== null ? exports : this;

  global.sprint = function() {
    var arrayObjects, format, i, padString, string, values, _ref;
    string = arguments[0], values = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    arrayObjects = ['[object Array]', '[object Arguments]'];
    if ((_ref = toString.call(values[0]), __indexOf.call(arrayObjects, _ref) >= 0) && values.length === 1) {
      values = values[0];
    }
    format = /%(\d+[$])?((?:[+\x20\-#0])*)(\d*|[*])(?:[.](\d+|[*]))?(?:hh?|ll?|[Lzjtq]|I(?:32|64)?)?([diuDUfFeEgGxXoOscbB])|%%/g;
    i = -1;
    padString = function(string, length, joiner, leftPad) {
      string = "" + string;
      if (string.length > length) {
        return string;
      } else if (leftPad) {
        return "" + string + (new Array(length - string.length + 1).join(joiner));
      } else {
        return "" + (new Array(length - string.length + 1).join(joiner)) + string;
      }
    };
    return string.replace(format, function() {
      var alignCharacter, argument, flags, leftPad, length, matches, precission, special, string, toExponential, type;
      string = arguments[0], matches = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      argument = matches[0], flags = matches[1], length = matches[2], precission = matches[3], type = matches[4];
      toExponential = function() {
        argument = (+argument).toExponential(precission);
        if (special && __indexOf.call(argument, '.') < 0) {
          argument = argument.replace('e', '.e');
        }
        return argument.toLowerCase().replace(/\d+$/, function(string) {
          return padString(string, 3, 0);
        });
      };
      if (string === '%%') return '%';
      if (length === '*') length = values[++i];
      if (!length) length = 0;
      if (precission === '*') precission = values[++i];
      if (!precission) precission = 6;
      argument = values[parseInt(argument, 10) - 1 || ++i];
      argument = argument != null ? "" + argument : '';
      special = __indexOf.call(flags, '#') >= 0;
      argument = (function() {
        switch (type) {
          case 'd':
          case 'i':
          case 'u':
          case 'D':
          case 'U':
            return parseInt(argument, 10);
          case 'f':
          case 'F':
            argument = (+argument).toFixed(precission).toLowerCase();
            if (special && __indexOf.call(argument, '.') < 0 && !/^-?[a-z]+$/.test(argument)) {
              argument += '.';
            }
            return argument;
          case 'e':
          case 'E':
            return toExponential();
          case 'g':
          case 'G':
            if ((0.0001 <= argument && argument < Math.pow(10, precission))) {
              argument = ("" + argument).substr(0, +precission + 1);
              if (special) {
                return argument.replace(/[.]?$/, '.');
              } else {
                return argument.replace(/[.]$/, '');
              }
            } else {
              return toExponential().replace(/[.]?0+e/, 'e');
            }
            break;
          case 'x':
          case 'X':
            return "" + (special ? '0x' : '') + ((+argument).toString(16));
          case 'b':
          case 'B':
            return "" + (special ? '0b' : '') + ((+argument).toString(2));
          case 'o':
          case 'O':
            return "" + (special ? '0' : '') + ((+argument).toString(8));
          case 's':
            return argument;
          case 'c':
            return String.fromCharCode(argument);
        }
      })();
      argument = "" + argument;
      if (type === type.toUpperCase()) argument = argument.toUpperCase();
      if (argument[0] !== '-') {
        if (__indexOf.call(flags, '+') >= 0) {
          argument = "+" + argument;
        } else if (__indexOf.call(flags, ' ') >= 0) {
          argument = " " + argument;
        }
      }
      leftPad = __indexOf.call(flags, '-') >= 0;
      if (__indexOf.call(flags, '0') >= 0) alignCharacter = '0';
      return padString(argument, length, alignCharacter || ' ', leftPad);
    });
  };

}).call(this);
