<%@ page import="org.primeframework.mvc.action.ActionInvocation" %>
<%@ page import="org.primeframework.mvc.action.ActionInvocationStore" %>
<%@ page import="org.primeframework.mvc.action.result.ForwardResult" %>
<%@ page import="org.primeframework.mvc.action.result.ForwardResult.ForwardImpl" %>
<%@ page import="org.primeframework.mvc.servlet.PrimeServletContextListener" %>
<%@ page import="org.primeframework.mvc.servlet.ServletObjectsHolder" %>
<%@ page import="com.google.inject.Injector" %>
<%
  Injector injector = (Injector) pageContext.getServletContext().getAttribute(PrimeServletContextListener.GUICE_INJECTOR_KEY);
  if (ServletObjectsHolder.getServletContext() == null) {
    ServletObjectsHolder.setServletContext(config.getServletContext());
  }
  if (ServletObjectsHolder.getServletRequest() == null) {
    ServletObjectsHolder.setServletRequest(new HttpServletRequestWrapper(request));
  }
  if (ServletObjectsHolder.getServletResponse() == null) {
    ServletObjectsHolder.setServletResponse(response);
  }

  try {
    ActionInvocation action = new ActionInvocation(null, null, "/errors/404", null, null);
    ActionInvocationStore store = injector.getInstance(ActionInvocationStore.class);
    store.setCurrent(action);

    ForwardResult forward = injector.getInstance(ForwardResult.class);
    forward.execute(new ForwardImpl("/templates/errors/404.ftl", "error", "text/html; charset=UTF-8", 404));
  } finally {
    ServletObjectsHolder.clearServletRequest();
    ServletObjectsHolder.clearServletResponse();
  }
%>
