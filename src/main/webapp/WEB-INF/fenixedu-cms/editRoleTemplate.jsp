<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
${portal.toolkit()}

<div class="page-header">
    <h1>Permissions</h1>
    <h2><a href="${pageContext.request.contextPath}/cms/permissions"><small>Manage Role Template</small></a></h2>
</div>

<p>
  <a href="#" data-toggle="modal" data-target="#edit-modal" class="btn btn-default btn-primary">
    <span class="glyphicon glyphicon-edit"></span>&nbsp;Edit
  </a>
  <a href="#" data-toggle="modal" data-target="#connect-site-modal" class="btn btn-default">
    <span class="glyphicon glyphicon-plus"></span>&nbsp;Site
  </a>
</p>

<div class="row">
  <div class="col-sm-8">
    <c:choose>
      <c:when test="${roleTemplate.getRolesSet().size() == 0}">
        <div class="panel panel-default">
          <div class="panel-body">
            <i>There are no sites or roles associated with this template.</i>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <ul class="list-group">
          <c:forEach var="role" items="${roleTemplate.getRolesSet()}">
            <li class="list-group-item">
              <h3><a href='${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/${role.externalId}/edit'>${role.site.name.content}</a></h3>
              
              <small><code>${role.name.content}</code></small>

              <div class="btn-group pull-right">
                  <form action="${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/${role.externalId}/delete" method="post">
                    ${csrf.field()}
                    <a href="${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/${role.externalId}/edit" class="btn btn-icon btn-primary">
                        <i class="glyphicon glyphicon-cog"></i>
                    </a>

                    <button type="submit" class="btn btn-icon btn-danger">
                      <i class="glyphicon glyphicon-trash"></i>
                    </button>
                  </form>
              </div>
            </li>
          </c:forEach>
        </ul>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="col-sm-4">
      <div class="panel panel-primary">
        <div class="panel-heading">Details</div>
        <div class="panel-body">
          <dl class="dl-horizontal">
              <dt>Description</dt>
              <dd>${roleTemplate.description.content}</dd>

              <dt>Number of Sites</dt>
              <dd>${roleTemplate.numSites}</dd>
          </dl>
        </div>
      </div>

      <div class="panel panel-primary">
        <div class="panel-heading">Permissions</div>
        <div class="panel-body">
          <dl class="dl-horizontal">
            <dt>Number of Permissions</dt>
            <dd>${roleTemplate.permissions.get().size()}</dd>

            <c:forEach var="permission" items="${roleTemplate.permissions.get()}">
              <dt>${permission.localizedName.content}</dt>
            </c:forEach>
          </dl>
        </div>
      </div>

      <div class="panel panel-danger">
        <div class="panel-heading">Danger Zone</div>
        <div class="panel-body">
          <p class="help-block">Once you delete a role category, there is no going back. Please be certain.</p>
          <button data-toggle="modal" data-target="#delete-modal" class="btn btn-danger">Delete this template</button>
        </div>
      </div>
  </div>
</div>

<div class="modal fade" id="connect-site-modal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Connect with a new site</h4>
        <small>Using this functionality you are able to make this template available for an existing site.</small>
      </div>
      <form action="${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/addSite" method="post">
        ${csrf.field()}
        <div class="modal-body">
          <div class="form-group">
              <label class="col-sm-2 control-label">Name</label>
              <div class="col-sm-10">
                  <input required-any name="name" bennu-localized-string placeholder="Enter the name of the role" class="form-control" value='${roleTemplate.description.json()}'>
                  <p class="help-block">Please enter the name of the role.</p> 
              </div>
          </div>
          <div class="form-group">
              <label class="col-sm-2 control-label">Site</label>
              <div class="col-sm-10">
                  <input required-any name="siteSlug" placeholder="Enter the site slug" class="form-control">
                  <p class="help-block">Please enter the slug of the site you want to associate with.</p> 
              </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="reset" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Connect</button>
        </div>

      </form> 
    </div>
  </div>
</div>

<div class="modal fade" id="delete-modal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Are you sure?</h4>
      </div>
      <div class="modal-body">
        <p>You are about to delete the template '<c:out value="${roleTemplate.description.content}" />'. There is no way to rollback this operation. Are you sure? </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
        <button type="button" onclick="$('#deleteForm').submit();" class="btn btn-danger">Yes</button>
        <form action="${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/delete" method="post" id="deleteForm">${csrf.field()}</form> 
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="edit-modal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="POST" action="${pageContext.request.contextPath}/cms/permissions/${roleTemplate.externalId}/edit">
                ${csrf.field()}
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><spanclass="sr-only"></span></button>
                    <h4>Update</h4>
                    <small>Change the permissions of this role</small>
                </div>  


                <div class="modal-body">
                    <div class="form-group" id="role-description">
                        <label class="col-sm-2 control-label">Description</label>
                        <div class="col-sm-10">
                            <input bennu-localized-string required-any name="description" placeholder="Enter a description for this role template." value='${roleTemplate.description.json()}'>
                        </div>
                    </div>

                    <c:forEach var="permission" items="${allPermissions}">
                        <div class="form-group permissions-inputs">
                            <label class="col-sm-8 control-label">${permission.localizedName.content}</label>
                            <div class="col-sm-4">
                                <div class="checkbox">
                                    <input type="checkbox" data-permission-name="${permission.name()}" ${roleTemplate.permissions.get().contains(permission) ? 'checked' : ''}>
                                  </div>
                              </div>
                          </div>
                    </c:forEach>

                    <input type="text" name="permissions" id="permissions-json" class="hidden">

                </div>

                <div class="modal-footer">
                    <button type="reset" class="btn btn-default" data-dismiss="modal"><spring:message code="action.cancel"/></button>
                    <button type="submit" class="btn btn-primary"><spring:message code="action.save"/></button>
                </div>
            </form>

        </div>

    </div>
</div>

<script>
    $(document).ready(function() {
        function updatePermissionsJson() {
            var permissions = $('.permissions-inputs input[type="checkbox"]').filter(function(){
                return $(this).is(":checked");
            }).map(function() {
                return $(this).data("permission-name");
            });
            $('#permissions-json').val(JSON.stringify(permissions.toArray()));
        }

        updatePermissionsJson();
        $(".permissions-inputs").click(updatePermissionsJson);    
    });
</script>
