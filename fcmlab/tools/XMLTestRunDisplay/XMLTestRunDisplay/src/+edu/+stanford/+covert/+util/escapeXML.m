%XML excape a string
function str = escapeXML(str)
str = strrep(str, '&', '&amp;');
str = strrep(str, '"', '&quot;');
str = strrep(str, '''', '&#039;');
str = strrep(str, '<', '&lt;');
str = strrep(str, '>', '&gt;');
