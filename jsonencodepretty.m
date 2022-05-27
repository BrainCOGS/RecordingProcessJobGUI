function json_pretty = jsonencodepretty(text)

json_pretty = jsonencode(text);
json_pretty = strrep(json_pretty, ',"', sprintf(',\r'));
json_pretty = strrep(json_pretty, '[{', sprintf('[\r{\r'));
json_pretty = strrep(json_pretty, '}]', sprintf('\r}\r]'));