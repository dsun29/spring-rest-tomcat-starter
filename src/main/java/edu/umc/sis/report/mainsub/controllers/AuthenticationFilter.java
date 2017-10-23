package edu.umc.sis.report.mainsub.controllers;


import com.mysap.sso.SSO_Authenticate;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.container.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import java.io.IOException;
import java.util.List;

/**
 * Class TokenValidationFilter aims to validate the token coming from every request
 * <p/>
 * Author: Dayong Sun
 * Created: 7/8/2016
 * Last Changed: 7/8/2016
 * <p/>
 * History:
 * 7/8/2016 Dayong Sun
 * Class created
 **/

@PreMatching
@Provider
public class AuthenticationFilter
        implements ContainerRequestFilter
{
    @Context
    private HttpServletRequest httpServletRequest;

    public void filter(ContainerRequestContext requestContext)
            throws IOException
    {
       try
        {

            SSO_Authenticate sso__auth = new SSO_Authenticate();
            if (!sso__auth.authenticate(httpServletRequest)){
                requestContext.abortWith(Response.status(Response.Status.UNAUTHORIZED).entity("{\"message\": \"Wrong user id or token\"}").build());
                return;
            }
            else {

                String userid = sso__auth.getUserID();

                MultivaluedMap<String, String> headers = requestContext.getHeaders();
                String useridFromHeader = ((String)((List)headers.get("user")).get(0)).toString();
                if (!userid.equals(useridFromHeader)) {
                    requestContext.abortWith(Response.status(Response.Status.UNAUTHORIZED).entity("{\"message\": \"Wrong user id or token\"}").build());
                    return;
                }

            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            String output = "{\"message\": \"" + e.toString() + "\"}";
            requestContext.abortWith(Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(output).build());
        }
    }

}