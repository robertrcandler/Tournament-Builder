[#-- @ftlvariable name="userState" type="java.lang.String" --]
[#-- @ftlvariable name="RelayState" type="java.lang.String" --]
[#-- @ftlvariable name="SAMLResponse" type="java.lang.String" --]
[#-- @ftlvariable name="callbackURL" type="java.lang.String" --]
<html lang="en">
<body>
<form action="${callbackURL}" method="POST">
  <input type="hidden" name="SAMLResponse" value="${SAMLResponse}">
  <input type="hidden" name="RelayState" value="${RelayState!''}">
[#--  <input type="hidden" name="UserState" value="${userState!''}">--]
</form>
<script type="text/javascript">
  document.forms[0].submit();
</script>
</body>
</html>